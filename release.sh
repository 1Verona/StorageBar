#!/bin/bash
# release.sh — Build, sign, notarize, zip, update appcast, and push GitHub release
# Usage: ./release.sh [version] [release_notes]
# Example: ./release.sh 1.1 "Quick Clean feature, new popover UI, Sparkle auto-updates"

set -e

export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

VERSION="${1:-}"
NOTES="${2:-}"
TEAM_ID="9SZ8SL4LH5"
BUNDLE_ID="Aether.StorageBar"
SCHEME="StorageBar"
PROJECT="StorageBar.xcodeproj"
BUILD_DIR="/tmp/storagebar-release"
DIST_DIR="$(dirname "$0")/dist"
APPCAST="$(dirname "$0")/appcast.xml"
REPO="1Verona/StorageBar"
APPCAST_URL="https://github.com/$REPO/releases/download/appcast/appcast.xml"
NOTARY_PROFILE="StorageBarNotarize"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[release]${NC} $1"; }
warn() { echo -e "${YELLOW}[release]${NC} $1"; }
err()  { echo -e "${RED}[release]${NC} $1"; }

# --- Validate ---
if [ -z "$VERSION" ]; then
    err "Usage: $0 <version> [release_notes]"
    err "Example: $0 1.1 \"Bug fixes and improvements\""
    exit 1
fi

if ! command -v xcodebuild &>/dev/null; then
    err "xcodebuild not found. Set DEVELOPER_DIR or install Xcode."
    exit 1
fi

log "Releasing StorageBar v$VERSION"
[ -n "$NOTES" ] && log "Notes: $NOTES"

# --- 1. Update project version ---
log "Updating version to $VERSION..."
cd "$(dirname "$0")"

# Update MARKETING_VERSION and CURRENT_PROJECT_VERSION in project.pbxproj
sed -i '' "s/MARKETING_VERSION = [0-9.]*;/MARKETING_VERSION = $VERSION;/g" StorageBar.xcodeproj/project.pbxproj

# Increment build number
CURRENT_BUILD=$(grep -m1 "CURRENT_PROJECT_VERSION = " StorageBar.xcodeproj/project.pbxproj | grep -o "[0-9]*")
NEW_BUILD=$((CURRENT_BUILD + 1))
sed -i '' "s/CURRENT_PROJECT_VERSION = [0-9]*;/CURRENT_PROJECT_VERSION = $NEW_BUILD;/g" StorageBar.xcodeproj/project.pbxproj
log "Build number: $CURRENT_BUILD → $NEW_BUILD"

# --- 2. Build Release with Developer ID ---
log "Building Release with Developer ID signing..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

xcodebuild -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration Release \
    -destination 'platform=macOS' \
    build \
    CODE_SIGN_IDENTITY="Developer ID Application: Aether Tech LTDA. ($TEAM_ID)" \
    CODE_SIGN_STYLE=Manual \
    DEVELOPMENT_TEAM="$TEAM_ID" \
    CODE_SIGN_INJECT_BASE_ENTITLEMENTS=NO \
    OTHER_CODE_SIGN_FLAGS="--timestamp" \
    CONFIGURATION_BUILD_DIR="$BUILD_DIR" \
    -quiet

if [ ! -d "$BUILD_DIR/StorageBar.app" ]; then
    err "Build failed — StorageBar.app not found in $BUILD_DIR"
    exit 1
fi
log "Build successful ✓"

# --- 2.5. Re-sign Sparkle framework binaries ---
log "Re-signing Sparkle framework binaries..."
SPARKLE_FRAMEWORK="$BUILD_DIR/StorageBar.app/Contents/Frameworks/Sparkle.framework"
if [ -d "$SPARKLE_FRAMEWORK" ]; then
    # Sign all binaries inside Sparkle.framework
    find "$SPARKLE_FRAMEWORK" -type f \( -name "*.dylib" -o -name "*.so" -o -perm +111 \) ! -name "*.plist" ! -name "*.strings" ! -name "*.nib" ! -name "*.css" -exec codesign --force --sign "Developer ID Application: Aether Tech LTDA. ($TEAM_ID)" --timestamp --options runtime {} \; 2>/dev/null || true
    # Sign Updater.app specifically
    if [ -d "$SPARKLE_FRAMEWORK/Versions/B/Updater.app" ]; then
        codesign --force --sign "Developer ID Application: Aether Tech LTDA. ($TEAM_ID)" --timestamp --options runtime "$SPARKLE_FRAMEWORK/Versions/B/Updater.app" 2>/dev/null || true
    fi
    # Sign Autoupdate
    if [ -f "$SPARKLE_FRAMEWORK/Versions/B/Autoupdate" ]; then
        codesign --force --sign "Developer ID Application: Aether Tech LTDA. ($TEAM_ID)" --timestamp --options runtime "$SPARKLE_FRAMEWORK/Versions/B/Autoupdate" 2>/dev/null || true
    fi
    # Re-sign the framework itself
    codesign --force --sign "Developer ID Application: Aether Tech LTDA. ($TEAM_ID)" --timestamp --options runtime "$SPARKLE_FRAMEWORK" 2>/dev/null || true
    log "Sparkle re-signed ✓"
fi

# --- 3. Verify signature ---
log "Verifying code signature..."
codesign -dv --verbose=4 "$BUILD_DIR/StorageBar.app" 2>&1 | grep -E "Authority|Timestamp" || true

# --- 4. Create zip ---
log "Creating zip archive..."
cd "$BUILD_DIR"
rm -f StorageBar.zip
ditto -c -k --sequesterRsrc --keepParent StorageBar.app StorageBar.zip
ZIP_SIZE=$(stat -f%z StorageBar.zip)
log "Zip created: $(numfmt --to=iec-i --suffix=B $ZIP_SIZE 2>/dev/null || echo "${ZIP_SIZE} bytes")"

# --- 5. Notarize ---
log "Submitting for notarization..."
# notarytool submit --wait exits non-zero on rejection, so set -e handles failures.
xcrun notarytool submit StorageBar.zip --keychain-profile "$NOTARY_PROFILE" --wait
log "Notarization accepted ✓"

# --- 6. Staple ---
log "Stapling notarization ticket..."
xcrun stapler staple "$BUILD_DIR/StorageBar.app"
spctl -a -vv "$BUILD_DIR/StorageBar.app" 2>&1 | grep "accepted" && log "Staple verified ✓" || warn "Staple verification inconclusive"

# --- 7. Copy to dist ---
log "Copying to dist/..."
cd "$(dirname "$0")"
rm -rf "$DIST_DIR/StorageBar.app" "$DIST_DIR/StorageBar.zip"
cp -R "$BUILD_DIR/StorageBar.app" "$DIST_DIR/"
cp "$BUILD_DIR/StorageBar.zip" "$DIST_DIR/"

# --- 8. Create DMG (with Applications symlink + custom window) ---
log "Creating DMG..."
DMG_STAGING="$BUILD_DIR/dmg-staging"
DMG_TMP="$BUILD_DIR/StorageBar-tmp.dmg"
DMG_FINAL="$DIST_DIR/StorageBar.dmg"
DMG_BG="$(dirname "$0")/dmg-background.png"

rm -rf "$DMG_STAGING" "$DMG_TMP" "$DMG_FINAL"
mkdir -p "$DMG_STAGING/.background"
cp -R "$DIST_DIR/StorageBar.app" "$DMG_STAGING/"
ln -s /Applications "$DMG_STAGING/Applications"
if [ -f "$DMG_BG" ]; then
    cp "$DMG_BG" "$DMG_STAGING/.background/background.png"
else
    warn "dmg-background.png not found — DMG will use default background"
fi

# Estimate size with headroom
STAGING_SIZE_MB=$(du -sm "$DMG_STAGING" | awk '{print $1 + 50}')

hdiutil create -volname "StorageBar Installer" -srcfolder "$DMG_STAGING" \
    -ov -format UDRW -fs HFS+ -size "${STAGING_SIZE_MB}m" "$DMG_TMP"

MOUNT_OUT=$(hdiutil attach -readwrite -noverify -noautoopen "$DMG_TMP")
MOUNT_DEV=$(echo "$MOUNT_OUT" | grep -E 'Apple_HFS|Apple_APFS' | awk '{print $1}' | head -1)
MOUNT_DIR="/Volumes/StorageBar Installer"
# Wait for mount to settle
for i in 1 2 3 4 5; do
    [ -d "$MOUNT_DIR" ] && break
    sleep 1
done

# Layout via AppleScript
osascript <<EOF
tell application "Finder"
    tell disk "StorageBar Installer"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {200, 120, 740, 500}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 128
        try
            set background picture of viewOptions to file ".background:background.png"
        end try
        set position of item "StorageBar.app" of container window to {140, 190}
        set position of item "Applications" of container window to {400, 190}
        update without registering applications
        delay 1
        close
    end tell
end tell
EOF

sync
hdiutil detach "$MOUNT_DEV" -quiet || hdiutil detach "$MOUNT_DIR" -quiet || true
hdiutil convert "$DMG_TMP" -format UDZO -imagekey zlib-level=9 -o "$DMG_FINAL"
rm -f "$DMG_TMP"

# Sign DMG
codesign --force --sign "Developer ID Application: Aether Tech LTDA. ($TEAM_ID)" --timestamp "$DMG_FINAL"
log "DMG criado e assinado ✓"

# Notarize DMG
log "Submitting DMG for notarization..."
xcrun notarytool submit "$DMG_FINAL" --keychain-profile "$NOTARY_PROFILE" --wait
xcrun stapler staple "$DMG_FINAL" && log "DMG stapled ✓" || warn "DMG staple failed"

# --- 9. Sign update for Sparkle ---
log "Signing update for Sparkle..."
PRIVATE_KEY_FILE="$(dirname "$0")/../.sparkle/private_key.txt"
if [ -f "$PRIVATE_KEY_FILE" ]; then
    PRIVATE_KEY=$(cat "$PRIVATE_KEY_FILE" | tr -d '[:space:]')
    SPARKLE_SIG=$(swift -e "
import Foundation
import CryptoKit
guard let keyData = Data(base64Encoded: \"$PRIVATE_KEY\") else { exit(1) }
let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: keyData)
guard let zipData = try? Data(contentsOf: URL(fileURLWithPath: \"$DIST_DIR/StorageBar.zip\")) else { exit(1) }
let signature = try privateKey.signature(for: zipData)
print(signature.base64EncodedString())
" 2>/dev/null)
    if [ -n "$SPARKLE_SIG" ]; then
        log "Sparkle signature: $SPARKLE_SIG"
    else
        warn "Failed to generate Sparkle signature"
        SPARKLE_SIG=""
    fi
else
    warn "Private key not found at $PRIVATE_KEY_FILE"
    warn "Updates will only verify via Developer ID signature"
    SPARKLE_SIG=""
fi

# --- 10. Update appcast.xml ---
log "Updating appcast.xml..."
RELEASE_DATE=$(date -u +"%a, %d %b %Y %H:%M:%S +0000")
ZIP_LEN=$(stat -f%z "$DIST_DIR/StorageBar.zip")

# Download URL for the zip (GitHub release asset)
DOWNLOAD_URL="https://github.com/$REPO/releases/download/v$VERSION/StorageBar.zip"

# Build the new item XML
NEW_ITEM="<item>
    <title>Version $VERSION</title>
    <pubDate>$RELEASE_DATE</pubDate>
    <enclosure url=\"$DOWNLOAD_URL\"
               sparkle:version=\"$NEW_BUILD\"
               sparkle:shortVersionString=\"$VERSION\"
               length=\"$ZIP_LEN\"
               type=\"application/octet-stream\"
               sparkle:edSignature=\"$SPARKLE_SIG\" />
    <description><![CDATA[$NOTES]]></description>
</item>"

# Insert before </channel>
sed -i '' "s|</channel>|${NEW_ITEM}
</channel>|" "$APPCAST"

log "appcast.xml updated ✓"

# --- 11. Git commit ---
log "Committing changes..."
git add StorageBar.xcodeproj/project.pbxproj appcast.xml
git commit -m "Release v$VERSION ($NEW_BUILD)

$NOTES" || warn "No changes to commit or git not configured"

# --- Summary ---
echo ""
log "========================================="
log " Release v$VERSION ($NEW_BUILD) ready!"
log "========================================="
log ""
log " Files in dist/:"
log "   - StorageBar.app"
log "   - StorageBar.zip  ($(numfmt --to=iec-i --suffix=B $ZIP_SIZE 2>/dev/null || echo "${ZIP_SIZE} bytes"))"
log "   - StorageBar.dmg"
log "   - appcast.xml (updated)"
log ""
warn " NEXT STEPS (manual):"
warn " 1. If sign_update wasn't available, get the ed25519 signature:"
warn "    brew install sparkle"
warn "    sign_update dist/StorageBar.zip"
warn "    Then update appcast.xml with the signature"
warn ""
warn " 2. Create GitHub release:"
warn "    gh release create v$VERSION dist/StorageBar.zip dist/StorageBar.dmg --title \"v$VERSION\" --notes \"$NOTES\""
warn ""
warn " 3. Push appcast.xml to the 'appcast' release tag:"
warn "    gh release create appcast appcast.xml --title \"Appcast Feed\" --notes \"Sparkle appcast feed\" --prerelease"
warn "    (or upload appcast.xml to the existing appcast release)"
warn ""
warn " 4. Push git changes:"
warn "    git push origin main"
echo ""
