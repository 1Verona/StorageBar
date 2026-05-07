"use client";

import { useState, useCallback } from "react";
import { Download, ExternalLink, Loader2 } from "lucide-react";

export function useDownload() {
  const [isDownloading, setIsDownloading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const downloadLatest = useCallback(async () => {
    setIsDownloading(true);
    setError(null);

    try {
      const response = await fetch(
        "https://api.github.com/repos/1Verona/StorageBar/releases"
      );
      if (!response.ok) throw new Error("Failed to fetch releases");

      const releases = await response.json();
      
      // Find the latest release with a DMG asset
      const releaseWithDmg = releases.find((release: any) =>
        release.assets?.some((asset: any) => asset.name.endsWith(".dmg"))
      );

      if (!releaseWithDmg) {
        throw new Error("No DMG found in releases");
      }

      const dmgAsset = releaseWithDmg.assets.find((asset: any) =>
        asset.name.endsWith(".dmg")
      );

      if (!dmgAsset) {
        throw new Error("DMG asset not found");
      }

      // Open download in new tab - this triggers the browser download
      window.open(dmgAsset.browser_download_url, "_blank");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Download failed");
      // Fallback: open releases page
      window.open("https://github.com/1Verona/StorageBar/releases", "_blank");
    } finally {
      setIsDownloading(false);
    }
  }, []);

  return { isDownloading, error, downloadLatest };
}
