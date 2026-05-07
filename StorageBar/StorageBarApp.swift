import SwiftUI
import AppKit
import Combine
import ServiceManagement

// MARK: - Constantes do Gumroad (TROCAR antes de publicar)

enum GumroadConfig {
    static let productID = "s9ubE4y7SjpJFl5xFUmJqg=="
    static let purchaseURL = URL(string: "https://gumroad.com/l/YOUR_PERMALINK_HERE")!
    static let trialDurationSeconds: TimeInterval = 24 * 3600
    static let masterKey = "heitchola"
}

// MARK: - Localization

enum Language: String, CaseIterable {
    case en, es, pt

    var displayName: String {
        switch self {
        case .en: return "English"
        case .es: return "Español"
        case .pt: return "Português (BR)"
        }
    }
}

enum L {
    static var current: Language {
        Language(rawValue: UserDefaults.standard.string(forKey: "language") ?? "") ?? .en
    }

    static func t(_ key: String) -> String {
        return strings[current]?[key] ?? strings[.en]?[key] ?? key
    }

    static let strings: [Language: [String: String]] = [
        .en: [
            "menu.loading": "Loading…",
            "menu.details": "Details",
            "menu.settings": "Settings…",
            "menu.quit": "Quit",
            "menu.usageFormat": "%@ of %@ used (%d%%)",
            "menu.lockedDetail": "Trial expired — please activate",
            "menu.activated": "Activated ✓",
            "menu.activate": "Activate StorageBar…",
            "menu.trial": "Trial — %@ — Activate…",
            "settings.title": "Settings — StorageBar",
            "settings.section.appearance": "Appearance",
            "settings.section.colors": "Colors",
            "settings.section.percentText": "Percentage text",
            "settings.section.language": "Language",
            "settings.section.system": "System",
            "settings.barStyle": "Bar style",
            "settings.useCustomTint": "Custom fill color",
            "settings.useCustomBorder": "Custom border color",
            "settings.useCustomBackground": "Custom background color",
            "settings.color": "Color",
            "settings.font": "Font",
            "settings.weight": "Weight",
            "settings.language": "Language",
            "settings.percentSize": "Size",
            "settings.percentPosition": "Position",
            "settings.percentContent": "Show",
            "settings.openOnLogin": "Open at login",
            "position.insideFilled": "Inside the filled area",
            "position.outside": "Outside the bar",
            "content.percent": "Percentage",
            "content.gbUsed": "Used (GB)",
            "content.gbFree": "Free (GB)",
            "activation.title": "Activation — StorageBar",
            "activation.activated": "Activated",
            "activation.trialRemaining": "Trial — %@ remaining",
            "activation.trialExpired": "Trial expired",
            "activation.expiredHint": "Enter a license key to keep using it.",
            "activation.trialHint": "You can use everything during the trial.",
            "activation.placeholder": "License key",
            "activation.activate": "Activate",
            "activation.buyKey": "Buy a key",
            "activation.removeActivation": "Remove activation",
            "activation.errorInvalid": "Invalid or already used key.",
            "activation.errorNetwork": "Network error: %@",
            "style.outline": "Outline",
            "style.solid": "Solid",
            "style.track": "Track + fill",
            "style.pillWithPercent": "Pill with %",
            "style.outlineColor": "Outline (color)",
            "style.solidColor": "Solid (color)",
            "style.trackColor": "Track + fill (color)",
            "style.pillWithPercentColor": "Pill with % (color)",
            "font.system": "System",
            "font.rounded": "Rounded",
            "font.monospaced": "Monospaced",
            "font.serif": "Serif",
            "weight.regular": "Regular",
            "weight.medium": "Medium",
            "weight.semibold": "Semibold",
            "weight.bold": "Bold",
            "weight.heavy": "Heavy",
            "time.lessThanMinute": "less than 1min",
        ],
        .es: [
            "menu.loading": "Cargando…",
            "menu.details": "Detalles",
            "menu.settings": "Ajustes…",
            "menu.quit": "Salir",
            "menu.usageFormat": "%@ de %@ usados (%d%%)",
            "menu.lockedDetail": "Prueba expirada — activa para continuar",
            "menu.activated": "Activado ✓",
            "menu.activate": "Activar StorageBar…",
            "menu.trial": "Prueba — %@ — Activar…",
            "settings.title": "Ajustes — StorageBar",
            "settings.section.appearance": "Apariencia",
            "settings.section.colors": "Colores",
            "settings.section.percentText": "Texto del porcentaje",
            "settings.section.language": "Idioma",
            "settings.section.system": "Sistema",
            "settings.barStyle": "Estilo de la barra",
            "settings.useCustomTint": "Color de relleno personalizado",
            "settings.useCustomBorder": "Color de borde personalizado",
            "settings.useCustomBackground": "Color de fondo personalizado",
            "settings.color": "Color",
            "settings.font": "Fuente",
            "settings.weight": "Grosor",
            "settings.language": "Idioma",
            "settings.percentSize": "Tamaño",
            "settings.percentPosition": "Posición",
            "settings.percentContent": "Mostrar",
            "settings.openOnLogin": "Abrir al iniciar sesión",
            "position.insideFilled": "Dentro del área llena",
            "position.outside": "Fuera de la barra",
            "content.percent": "Porcentaje",
            "content.gbUsed": "Usado (GB)",
            "content.gbFree": "Libre (GB)",
            "activation.title": "Activación — StorageBar",
            "activation.activated": "Activado",
            "activation.trialRemaining": "Prueba — %@ restante",
            "activation.trialExpired": "Prueba expirada",
            "activation.expiredHint": "Introduce una license key para seguir usando.",
            "activation.trialHint": "Puedes usar todo durante la prueba.",
            "activation.placeholder": "License key",
            "activation.activate": "Activar",
            "activation.buyKey": "Comprar key",
            "activation.removeActivation": "Eliminar activación",
            "activation.errorInvalid": "Key inválida o ya usada.",
            "activation.errorNetwork": "Error de red: %@",
            "style.outline": "Contorno",
            "style.solid": "Sólido",
            "style.track": "Barra + relleno",
            "style.pillWithPercent": "Píldora con %",
            "style.outlineColor": "Contorno (color)",
            "style.solidColor": "Sólido (color)",
            "style.trackColor": "Barra + relleno (color)",
            "style.pillWithPercentColor": "Píldora con % (color)",
            "font.system": "Sistema",
            "font.rounded": "Redondeada",
            "font.monospaced": "Monoespaciada",
            "font.serif": "Serif",
            "weight.regular": "Regular",
            "weight.medium": "Medio",
            "weight.semibold": "Semi-negrita",
            "weight.bold": "Negrita",
            "weight.heavy": "Extra-negrita",
            "time.lessThanMinute": "menos de 1min",
        ],
        .pt: [
            "menu.loading": "Carregando…",
            "menu.details": "Detalhes",
            "menu.settings": "Ajustes…",
            "menu.quit": "Sair",
            "menu.usageFormat": "%@ de %@ usados (%d%%)",
            "menu.lockedDetail": "Trial expirado — ative para continuar",
            "menu.activated": "Ativação ✓",
            "menu.activate": "Ativar StorageBar…",
            "menu.trial": "Trial — %@ — Ativar…",
            "settings.title": "Ajustes — StorageBar",
            "settings.section.appearance": "Aparência",
            "settings.section.colors": "Cores",
            "settings.section.percentText": "Texto da porcentagem",
            "settings.section.language": "Idioma",
            "settings.section.system": "Sistema",
            "settings.barStyle": "Estilo da barra",
            "settings.useCustomTint": "Cor de preenchimento personalizada",
            "settings.useCustomBorder": "Cor de borda personalizada",
            "settings.useCustomBackground": "Cor de fundo personalizada",
            "settings.color": "Cor",
            "settings.font": "Fonte",
            "settings.weight": "Espessura",
            "settings.language": "Idioma",
            "settings.percentSize": "Tamanho",
            "settings.percentPosition": "Posição",
            "settings.percentContent": "Mostrar",
            "settings.openOnLogin": "Abrir ao fazer login",
            "position.insideFilled": "Dentro da área preenchida",
            "position.outside": "Fora da barra",
            "content.percent": "Porcentagem",
            "content.gbUsed": "Usado (GB)",
            "content.gbFree": "Livre (GB)",
            "activation.title": "Ativação — StorageBar",
            "activation.activated": "Ativado",
            "activation.trialRemaining": "Trial — %@ restante",
            "activation.trialExpired": "Trial expirado",
            "activation.expiredHint": "Insira uma license key para continuar usando.",
            "activation.trialHint": "Você pode usar tudo durante o período de teste.",
            "activation.placeholder": "License key",
            "activation.activate": "Ativar",
            "activation.buyKey": "Comprar key",
            "activation.removeActivation": "Remover ativação",
            "activation.errorInvalid": "Key inválida ou já usada.",
            "activation.errorNetwork": "Erro de rede: %@",
            "style.outline": "Contorno",
            "style.solid": "Sólida",
            "style.track": "Trilho + preenchimento",
            "style.pillWithPercent": "Pílula com %",
            "style.outlineColor": "Contorno (cor)",
            "style.solidColor": "Sólida (cor)",
            "style.trackColor": "Trilho + preenchimento (cor)",
            "style.pillWithPercentColor": "Pílula com % (cor)",
            "font.system": "Sistema",
            "font.rounded": "Arredondada",
            "font.monospaced": "Monoespaçada",
            "font.serif": "Serifa",
            "weight.regular": "Regular",
            "weight.medium": "Médio",
            "weight.semibold": "Semi-negrito",
            "weight.bold": "Negrito",
            "weight.heavy": "Extra-negrito",
            "time.lessThanMinute": "menos de 1min",
        ],
    ]
}

// MARK: - App entry point

@main
struct StorageBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}

// MARK: - SettingsView

struct SettingsView: View {
    @AppStorage("language") private var languageRaw: String = Language.en.rawValue
    @AppStorage("barStyle") private var barStyleRaw: String = BarStyle.outline.rawValue

    @AppStorage("useCustomTint") private var useCustomTint: Bool = false
    @AppStorage("tintR") private var tintR: Double = 0.0
    @AppStorage("tintG") private var tintG: Double = 0.478
    @AppStorage("tintB") private var tintB: Double = 1.0

    @AppStorage("useCustomBorder") private var useCustomBorder: Bool = false
    @AppStorage("borderR") private var borderR: Double = 0.5
    @AppStorage("borderG") private var borderG: Double = 0.5
    @AppStorage("borderB") private var borderB: Double = 0.5

    @AppStorage("useCustomBackground") private var useCustomBackground: Bool = false
    @AppStorage("backgroundR") private var backgroundR: Double = 0.85
    @AppStorage("backgroundG") private var backgroundG: Double = 0.85
    @AppStorage("backgroundB") private var backgroundB: Double = 0.85

    @AppStorage("percentFont") private var percentFontRaw: String = PercentFont.system.rawValue
    @AppStorage("percentWeight") private var percentWeightRaw: String = PercentWeight.heavy.rawValue
    @AppStorage("percentSize") private var percentSize: Double = 0.7
    @AppStorage("percentPosition") private var percentPositionRaw: String = PercentPosition.insideFilled.rawValue
    @AppStorage("percentContent") private var percentContentRaw: String = PercentContent.percent.rawValue
    @AppStorage("openOnLogin") private var openOnLogin: Bool = true

    private var languageBinding: Binding<Language> {
        Binding(
            get: { Language(rawValue: languageRaw) ?? .en },
            set: { languageRaw = $0.rawValue }
        )
    }
    private var styleBinding: Binding<BarStyle> {
        Binding(
            get: { BarStyle(rawValue: barStyleRaw) ?? .outline },
            set: { barStyleRaw = $0.rawValue }
        )
    }
    private var fontBinding: Binding<PercentFont> {
        Binding(
            get: { PercentFont(rawValue: percentFontRaw) ?? .system },
            set: { percentFontRaw = $0.rawValue }
        )
    }
    private var weightBinding: Binding<PercentWeight> {
        Binding(
            get: { PercentWeight(rawValue: percentWeightRaw) ?? .heavy },
            set: { percentWeightRaw = $0.rawValue }
        )
    }
    private var positionBinding: Binding<PercentPosition> {
        Binding(
            get: { PercentPosition(rawValue: percentPositionRaw) ?? .insideFilled },
            set: { percentPositionRaw = $0.rawValue }
        )
    }
    private var contentBinding: Binding<PercentContent> {
        Binding(
            get: { PercentContent(rawValue: percentContentRaw) ?? .percent },
            set: { percentContentRaw = $0.rawValue }
        )
    }

    private func colorBinding(_ r: Binding<Double>, _ g: Binding<Double>, _ b: Binding<Double>) -> Binding<Color> {
        Binding(
            get: { Color(.sRGB, red: r.wrappedValue, green: g.wrappedValue, blue: b.wrappedValue, opacity: 1) },
            set: { newColor in
                if let ns = NSColor(newColor).usingColorSpace(.sRGB) {
                    r.wrappedValue = Double(ns.redComponent)
                    g.wrappedValue = Double(ns.greenComponent)
                    b.wrappedValue = Double(ns.blueComponent)
                }
            }
        )
    }

    private var previewTint: NSColor? {
        useCustomTint ? NSColor(srgbRed: tintR, green: tintG, blue: tintB, alpha: 1) : nil
    }
    private var previewBorder: NSColor? {
        useCustomBorder ? NSColor(srgbRed: borderR, green: borderG, blue: borderB, alpha: 1) : nil
    }
    private var previewBackground: NSColor? {
        useCustomBackground ? NSColor(srgbRed: backgroundR, green: backgroundG, blue: backgroundB, alpha: 1) : nil
    }

    var body: some View {
        // referenciar languageRaw força re-render quando muda
        let _ = languageRaw

        Form {
            Section {
                HStack {
                    Spacer()
                    StorageBarPreview(
                        style: BarStyle(rawValue: barStyleRaw) ?? .outline,
                        customTint: previewTint,
                        customBorder: previewBorder,
                        customBackground: previewBackground,
                        percentFont: PercentFont(rawValue: percentFontRaw) ?? .system,
                        percentWeight: PercentWeight(rawValue: percentWeightRaw) ?? .heavy,
                        percentSize: percentSize,
                        percentPosition: PercentPosition(rawValue: percentPositionRaw) ?? .insideFilled,
                        percentContent: PercentContent(rawValue: percentContentRaw) ?? .percent,
                        fraction: 0.62
                    )
                    .frame(width: 220, height: 80)
                    Spacer()
                }
                .padding(.vertical, 6)
            }

            Section(L.t("settings.section.appearance")) {
                Picker(L.t("settings.barStyle"), selection: styleBinding) {
                    ForEach(BarStyle.allCases, id: \.self) { s in
                        Text(L.t("style.\(s.rawValue)")).tag(s)
                    }
                }
                .pickerStyle(.menu)
            }

            Section(L.t("settings.section.colors")) {
                let kind = (BarStyle(rawValue: barStyleRaw) ?? .outline).renderKind

                Toggle(L.t("settings.useCustomTint"), isOn: $useCustomTint)
                if useCustomTint {
                    ColorPicker(L.t("settings.color"), selection: colorBinding($tintR, $tintG, $tintB), supportsOpacity: false)
                }

                if kind == .outline {
                    Toggle(L.t("settings.useCustomBorder"), isOn: $useCustomBorder)
                    if useCustomBorder {
                        ColorPicker(L.t("settings.color"), selection: colorBinding($borderR, $borderG, $borderB), supportsOpacity: false)
                    }
                }

                if kind == .track || kind == .pillWithPercent {
                    Toggle(L.t("settings.useCustomBackground"), isOn: $useCustomBackground)
                    if useCustomBackground {
                        ColorPicker(L.t("settings.color"), selection: colorBinding($backgroundR, $backgroundG, $backgroundB), supportsOpacity: false)
                    }
                }
            }

            Section(L.t("settings.section.percentText")) {
                Picker(L.t("settings.percentContent"), selection: contentBinding) {
                    ForEach(PercentContent.allCases, id: \.self) { c in
                        Text(L.t("content.\(c.rawValue)")).tag(c)
                    }
                }
                Picker(L.t("settings.percentPosition"), selection: positionBinding) {
                    ForEach(PercentPosition.allCases, id: \.self) { p in
                        Text(L.t("position.\(p.rawValue)")).tag(p)
                    }
                }
                Picker(L.t("settings.font"), selection: fontBinding) {
                    ForEach(PercentFont.allCases, id: \.self) { f in
                        Text(L.t("font.\(f.rawValue)")).tag(f)
                    }
                }
                Picker(L.t("settings.weight"), selection: weightBinding) {
                    ForEach(PercentWeight.allCases, id: \.self) { w in
                        Text(L.t("weight.\(w.rawValue)")).tag(w)
                    }
                }
                HStack {
                    Text(L.t("settings.percentSize"))
                    Slider(value: $percentSize, in: 0.4...0.95)
                }
            }

            Section(L.t("settings.section.language")) {
                Picker(L.t("settings.language"), selection: languageBinding) {
                    ForEach(Language.allCases, id: \.self) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
            }

            Section(L.t("settings.section.system")) {
                Toggle(L.t("settings.openOnLogin"), isOn: $openOnLogin)
            }
        }
        .formStyle(.grouped)
        .frame(width: 520, height: 760)
        .onChange(of: openOnLogin) { _, newValue in
            LoginItemManager.setEnabled(newValue)
        }
    }
}

// MARK: - StorageBarPreview

struct StorageBarPreview: NSViewRepresentable {
    let style: BarStyle
    let customTint: NSColor?
    let customBorder: NSColor?
    let customBackground: NSColor?
    let percentFont: PercentFont
    let percentWeight: PercentWeight
    let percentSize: Double
    let percentPosition: PercentPosition
    let percentContent: PercentContent
    let fraction: Double

    func makeNSView(context: Context) -> StorageBarView {
        StorageBarView(frame: NSRect(x: 0, y: 0, width: 220, height: 80))
    }

    func updateNSView(_ view: StorageBarView, context: Context) {
        view.style = style
        view.customTint = customTint
        view.customBorder = customBorder
        view.customBackground = customBackground
        view.percentFont = percentFont
        view.percentWeight = percentWeight
        view.percentSize = percentSize
        view.percentPosition = percentPosition
        view.percentContent = percentContent
        // valores fictícios pro preview de "GB used/free"
        view.usedBytes = 120 * 1_000_000_000
        view.freeBytes = 80 * 1_000_000_000
        view.fraction = fraction
    }
}

// MARK: - LicenseManager

@MainActor
final class LicenseManager: ObservableObject {
    static let shared = LicenseManager()

    private static let installDateKey = "installDate"
    private static let licenseKeyKey = "licenseKey"
    private static let activatedKey = "licenseActivated"

    @Published private(set) var isActivated: Bool = false
    @Published private(set) var licenseKey: String? = nil
    private(set) var isFirstLaunch: Bool = false

    private init() {
        let d = UserDefaults.standard
        if d.object(forKey: Self.installDateKey) == nil {
            d.set(Date(), forKey: Self.installDateKey)
            isFirstLaunch = true
        }
        isActivated = d.bool(forKey: Self.activatedKey)
        licenseKey = d.string(forKey: Self.licenseKeyKey)
    }

    var installDate: Date {
        UserDefaults.standard.object(forKey: Self.installDateKey) as? Date ?? Date()
    }

    var remainingSeconds: TimeInterval {
        let elapsed = Date().timeIntervalSince(installDate)
        return max(0, GumroadConfig.trialDurationSeconds - elapsed)
    }

    var remainingTimeText: String {
        let r = remainingSeconds
        let hours = Int(r) / 3600
        let minutes = (Int(r) % 3600) / 60
        if hours > 0 { return "\(hours)h \(minutes)min" }
        if minutes > 0 { return "\(minutes)min" }
        return L.t("time.lessThanMinute")
    }

    var trialExpired: Bool { remainingSeconds <= 0 }

    var isLicensed: Bool { isActivated || !trialExpired }

    enum ActivationError: LocalizedError {
        case invalidKey
        case network(String)
        var errorDescription: String? {
            switch self {
            case .invalidKey: return L.t("activation.errorInvalid")
            case .network(let m): return String(format: L.t("activation.errorNetwork"), m)
            }
        }
    }

    func activate(key: String) async throws {
        let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw ActivationError.invalidKey }

        if trimmed.lowercased() == GumroadConfig.masterKey {
            persistActivated(key: trimmed)
            return
        }

        var request = URLRequest(url: URL(string: "https://api.gumroad.com/v2/licenses/verify")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "product_id=\(GumroadConfig.productID)&license_key=\(trimmed)&increment_uses_count=false"
        request.httpBody = body.data(using: .utf8)

        let data: Data
        do {
            (data, _) = try await URLSession.shared.data(for: request)
        } catch {
            throw ActivationError.network(error.localizedDescription)
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let success = json["success"] as? Bool, success else {
            throw ActivationError.invalidKey
        }

        if let purchase = json["purchase"] as? [String: Any] {
            if let refunded = purchase["refunded"] as? Bool, refunded {
                throw ActivationError.invalidKey
            }
            if let chargebacked = purchase["chargebacked"] as? Bool, chargebacked {
                throw ActivationError.invalidKey
            }
        }

        persistActivated(key: trimmed)
    }

    private func persistActivated(key: String) {
        let d = UserDefaults.standard
        d.set(true, forKey: Self.activatedKey)
        d.set(key, forKey: Self.licenseKeyKey)
        isActivated = true
        licenseKey = key
    }

    func deactivate() {
        let d = UserDefaults.standard
        d.set(false, forKey: Self.activatedKey)
        d.removeObject(forKey: Self.licenseKeyKey)
        isActivated = false
        licenseKey = nil
    }
}

// MARK: - ActivationView

extension Notification.Name {
    static let closeActivationWindow = Notification.Name("StorageBar.closeActivationWindow")
}

struct ActivationView: View {
    @AppStorage("language") private var languageRaw: String = Language.en.rawValue
    @ObservedObject private var manager = LicenseManager.shared
    @State private var keyInput: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var justActivated: Bool = false

    var body: some View {
        let _ = languageRaw

        VStack(spacing: 18) {
            Image(systemName: manager.isActivated ? "checkmark.seal.fill" : "lock.fill")
                .font(.system(size: 36))
                .foregroundStyle(manager.isActivated ? .green : .secondary)

            Text("StorageBar")
                .font(.title2.bold())

            if manager.isActivated {
                VStack(spacing: 4) {
                    Text(L.t("activation.activated")).font(.headline)
                    if let key = manager.licenseKey {
                        Text(key)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .textSelection(.enabled)
                    }
                }
                Button(L.t("activation.removeActivation"), role: .destructive) {
                    manager.deactivate()
                }
                .buttonStyle(.bordered)
            } else {
                if manager.trialExpired {
                    Text(L.t("activation.trialExpired")).font(.headline).foregroundStyle(.orange)
                    Text(L.t("activation.expiredHint"))
                        .font(.subheadline).foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text(String(format: L.t("activation.trialRemaining"), manager.remainingTimeText))
                        .font(.headline)
                    Text(L.t("activation.trialHint"))
                        .font(.subheadline).foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                TextField(L.t("activation.placeholder"), text: $keyInput)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .frame(maxWidth: 320)

                if let err = errorMessage {
                    Text(err).foregroundStyle(.red).font(.caption)
                }

                HStack(spacing: 10) {
                    Button {
                        activate()
                    } label: {
                        Group {
                            if isLoading {
                                ProgressView().controlSize(.small)
                            } else {
                                Text(L.t("activation.activate"))
                            }
                        }
                        .frame(minWidth: 80)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(keyInput.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)

                    Link(L.t("activation.buyKey"), destination: GumroadConfig.purchaseURL)
                        .buttonStyle(.bordered)
                }
            }
        }
        .padding(32)
        .frame(width: 420, height: 340)
    }

    private func activate() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await manager.activate(key: keyInput)
                isLoading = false
                justActivated = true
                try? await Task.sleep(nanoseconds: 600_000_000)
                NotificationCenter.default.post(name: .closeActivationWindow, object: nil)
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}

// MARK: - AppDelegate

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private static let styleKey = "barStyle"

    private var statusItem: NSStatusItem!
    private var barView: StorageBarView!
    private var detailItem: NSMenuItem!
    private var activationItem: NSMenuItem!
    private var timer: Timer?
    private var settingsWindow: NSWindow?
    private var activationWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: 60)

        if let button = statusItem.button {
            let view = StorageBarView(
                frame: NSRect(x: 0, y: 0, width: 60, height: button.bounds.height)
            )
            view.autoresizingMask = [.width, .height]
            view.style = loadSavedStyle()
            view.customTint = loadCustomTint()
            view.customBorder = loadCustomBorder()
            view.customBackground = loadCustomBackground()
            view.percentFont = loadPercentFont()
            view.percentWeight = loadPercentWeight()
            view.percentSize = loadPercentSize()
            view.percentPosition = loadPercentPosition()
            view.percentContent = loadPercentContent()
            view.locked = !LicenseManager.shared.isLicensed
            button.addSubview(view)
            barView = view
        }

        statusItem.menu = buildMenu()
        refresh()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.refresh() }
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDefaultsChanged),
            name: UserDefaults.didChangeNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(closeActivationWindowNotif),
            name: .closeActivationWindow,
            object: nil
        )

        // Login on launch — primeiro launch registra por padrão
        if UserDefaults.standard.object(forKey: "openOnLogin") == nil {
            UserDefaults.standard.set(true, forKey: "openOnLogin")
            LoginItemManager.setEnabled(true)
        } else {
            LoginItemManager.setEnabled(UserDefaults.standard.bool(forKey: "openOnLogin"))
        }

        let m = LicenseManager.shared
        if !m.isActivated && (m.isFirstLaunch || m.trialExpired) {
            openActivationWindow()
        }
    }

    @objc private func userDefaultsChanged() {
        let newStyle = loadSavedStyle()
        if barView.style != newStyle { barView.style = newStyle }
        barView.customTint = loadCustomTint()
        barView.customBorder = loadCustomBorder()
        barView.customBackground = loadCustomBackground()
        barView.percentFont = loadPercentFont()
        barView.percentWeight = loadPercentWeight()
        barView.percentSize = loadPercentSize()
        barView.percentPosition = loadPercentPosition()
        barView.percentContent = loadPercentContent()
        let nowLocked = !LicenseManager.shared.isLicensed
        if barView.locked != nowLocked { barView.locked = nowLocked }
        // rebuilda o menu pra refletir mudanças de idioma
        statusItem.menu = buildMenu()
        refresh()
        // títulos de janelas
        settingsWindow?.title = L.t("settings.title")
        activationWindow?.title = L.t("activation.title")
    }

    @objc private func closeActivationWindowNotif() {
        activationWindow?.close()
        barView.locked = !LicenseManager.shared.isLicensed
        updateActivationMenuItem()
    }

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()

        detailItem = NSMenuItem(title: L.t("menu.loading"), action: nil, keyEquivalent: "")
        detailItem.isEnabled = false
        menu.addItem(detailItem)
        menu.addItem(.separator())

        let detailsItem = NSMenuItem(
            title: L.t("menu.details"),
            action: #selector(openStorageSettings),
            keyEquivalent: ""
        )
        detailsItem.target = self
        menu.addItem(detailsItem)

        let prefsItem = NSMenuItem(
            title: L.t("menu.settings"),
            action: #selector(openSettingsWindow),
            keyEquivalent: ","
        )
        prefsItem.target = self
        menu.addItem(prefsItem)

        activationItem = NSMenuItem(
            title: activationItemTitle(),
            action: #selector(openActivationWindowAction),
            keyEquivalent: ""
        )
        activationItem.target = self
        menu.addItem(activationItem)

        menu.addItem(.separator())
        menu.addItem(NSMenuItem(
            title: L.t("menu.quit"),
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        ))
        return menu
    }

    private func activationItemTitle() -> String {
        let m = LicenseManager.shared
        if m.isActivated { return L.t("menu.activated") }
        if m.trialExpired { return L.t("menu.activate") }
        return String(format: L.t("menu.trial"), m.remainingTimeText)
    }

    private func updateActivationMenuItem() {
        activationItem?.title = activationItemTitle()
    }

    @objc private func openStorageSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.settings.Storage") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func openSettingsWindow() {
        if settingsWindow == nil {
            let hosting = NSHostingController(rootView: SettingsView())
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 480, height: 640),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            window.contentViewController = hosting
            window.isReleasedWhenClosed = false
            window.center()
            settingsWindow = window
        }
        settingsWindow?.title = L.t("settings.title")
        NSApp.activate(ignoringOtherApps: true)
        settingsWindow?.makeKeyAndOrderFront(nil)
    }

    @objc private func openActivationWindowAction() { openActivationWindow() }

    private func openActivationWindow() {
        if activationWindow == nil {
            let hosting = NSHostingController(rootView: ActivationView())
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 420, height: 340),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            window.contentViewController = hosting
            window.isReleasedWhenClosed = false
            window.center()
            activationWindow = window
        }
        activationWindow?.title = L.t("activation.title")
        NSApp.activate(ignoringOtherApps: true)
        activationWindow?.makeKeyAndOrderFront(nil)
    }

    private func loadSavedStyle() -> BarStyle {
        guard let raw = UserDefaults.standard.string(forKey: Self.styleKey),
              let style = BarStyle(rawValue: raw) else { return .outline }
        return style
    }

    private func loadCustomTint() -> NSColor? {
        let d = UserDefaults.standard
        guard d.bool(forKey: "useCustomTint") else { return nil }
        let r = d.double(forKey: "tintR")
        let g = d.double(forKey: "tintG")
        let b = d.double(forKey: "tintB")
        return NSColor(srgbRed: r, green: g, blue: b, alpha: 1)
    }

    private func loadCustomBorder() -> NSColor? {
        let d = UserDefaults.standard
        guard d.bool(forKey: "useCustomBorder") else { return nil }
        let r = d.double(forKey: "borderR")
        let g = d.double(forKey: "borderG")
        let b = d.double(forKey: "borderB")
        return NSColor(srgbRed: r, green: g, blue: b, alpha: 1)
    }

    private func loadCustomBackground() -> NSColor? {
        let d = UserDefaults.standard
        guard d.bool(forKey: "useCustomBackground") else { return nil }
        let r = d.double(forKey: "backgroundR")
        let g = d.double(forKey: "backgroundG")
        let b = d.double(forKey: "backgroundB")
        return NSColor(srgbRed: r, green: g, blue: b, alpha: 1)
    }

    private func loadPercentFont() -> PercentFont {
        let raw = UserDefaults.standard.string(forKey: "percentFont") ?? ""
        return PercentFont(rawValue: raw) ?? .system
    }

    private func loadPercentWeight() -> PercentWeight {
        let raw = UserDefaults.standard.string(forKey: "percentWeight") ?? ""
        return PercentWeight(rawValue: raw) ?? .heavy
    }

    private func loadPercentSize() -> Double {
        let v = UserDefaults.standard.double(forKey: "percentSize")
        return v == 0 ? 0.7 : v
    }

    private func loadPercentPosition() -> PercentPosition {
        let raw = UserDefaults.standard.string(forKey: "percentPosition") ?? ""
        return PercentPosition(rawValue: raw) ?? .insideFilled
    }

    private func loadPercentContent() -> PercentContent {
        let raw = UserDefaults.standard.string(forKey: "percentContent") ?? ""
        return PercentContent(rawValue: raw) ?? .percent
    }

    private func refresh() {
        updateActivationMenuItem()
        let nowLocked = !LicenseManager.shared.isLicensed
        if barView.locked != nowLocked { barView.locked = nowLocked }

        if nowLocked {
            detailItem.title = L.t("menu.lockedDetail")
            return
        }

        guard let usage = DiskUsage.current() else { return }
        barView.fraction = usage.fraction
        barView.usedBytes = usage.usedBytes
        barView.freeBytes = usage.availableBytes
        let used = ByteCountFormatter.string(fromByteCount: usage.usedBytes, countStyle: .file)
        let total = ByteCountFormatter.string(fromByteCount: usage.totalBytes, countStyle: .file)
        let pct = Int((usage.fraction * 100).rounded())
        detailItem.title = String(format: L.t("menu.usageFormat"), used, total, pct)
    }
}

// MARK: - DiskUsage

struct DiskUsage {
    let totalBytes: Int64
    let availableBytes: Int64
    var usedBytes: Int64 { totalBytes - availableBytes }
    var fraction: Double {
        totalBytes > 0 ? Double(usedBytes) / Double(totalBytes) : 0
    }

    static func current() -> DiskUsage? {
        let url = URL(fileURLWithPath: "/")
        guard let values = try? url.resourceValues(forKeys: [
                .volumeTotalCapacityKey,
                .volumeAvailableCapacityForImportantUsageKey
              ]),
              let total = values.volumeTotalCapacity,
              let avail = values.volumeAvailableCapacityForImportantUsage
        else { return nil }
        return DiskUsage(totalBytes: Int64(total), availableBytes: avail)
    }
}

// MARK: - BarStyle

enum BarStyle: String, CaseIterable {
    case outline, solid, track, pillWithPercent
    case outlineColor, solidColor, trackColor, pillWithPercentColor

    enum RenderKind { case outline, solid, track, pillWithPercent }

    var displayName: String { L.t("style.\(rawValue)") }

    var fillColor: NSColor {
        switch self {
        case .outlineColor, .solidColor, .trackColor, .pillWithPercentColor:
            return .controlAccentColor
        default:
            return .labelColor
        }
    }

    var renderKind: RenderKind {
        switch self {
        case .outline, .outlineColor:                 return .outline
        case .solid, .solidColor:                     return .solid
        case .track, .trackColor:                     return .track
        case .pillWithPercent, .pillWithPercentColor: return .pillWithPercent
        }
    }
}

// MARK: - PercentFont / PercentWeight

enum PercentFont: String, CaseIterable {
    case system, rounded, monospaced, serif

    var displayName: String { L.t("font.\(rawValue)") }

    func font(size: CGFloat, weight: NSFont.Weight) -> NSFont {
        let base = NSFont.systemFont(ofSize: size, weight: weight)
        let design: NSFontDescriptor.SystemDesign?
        switch self {
        case .system:     design = nil
        case .rounded:    design = .rounded
        case .monospaced: design = .monospaced
        case .serif:      design = .serif
        }
        guard let d = design,
              let descriptor = base.fontDescriptor.withDesign(d) else { return base }
        return NSFont(descriptor: descriptor, size: size) ?? base
    }
}

enum PercentPosition: String, CaseIterable {
    case insideFilled, outside
    var displayName: String { L.t("position.\(rawValue)") }
}

enum PercentContent: String, CaseIterable {
    case percent, gbUsed, gbFree
    var displayName: String { L.t("content.\(rawValue)") }
}

// MARK: - Login Item

enum LoginItemManager {
    static func setEnabled(_ enabled: Bool) {
        let service = SMAppService.mainApp
        do {
            if enabled {
                if service.status != .enabled { try service.register() }
            } else {
                if service.status == .enabled { try service.unregister() }
            }
        } catch {
            NSLog("LoginItem error: \(error.localizedDescription)")
        }
    }
}

enum PercentWeight: String, CaseIterable {
    case regular, medium, semibold, bold, heavy

    var displayName: String { L.t("weight.\(rawValue)") }

    var nsWeight: NSFont.Weight {
        switch self {
        case .regular:  return .regular
        case .medium:   return .medium
        case .semibold: return .semibold
        case .bold:     return .bold
        case .heavy:    return .heavy
        }
    }
}

// MARK: - StorageBarView

@MainActor
final class StorageBarView: NSView {
    var fraction: Double = 0  { didSet { needsDisplay = true } }
    var style: BarStyle = .outline { didSet { needsDisplay = true } }
    var locked: Bool = false { didSet { needsDisplay = true } }
    var customTint: NSColor? = nil { didSet { needsDisplay = true } }
    var customBorder: NSColor? = nil { didSet { needsDisplay = true } }
    var customBackground: NSColor? = nil { didSet { needsDisplay = true } }
    var percentFont: PercentFont = .system { didSet { needsDisplay = true } }
    var percentWeight: PercentWeight = .heavy { didSet { needsDisplay = true } }
    var percentSize: Double = 0.7 { didSet { needsDisplay = true } }
    var percentPosition: PercentPosition = .insideFilled { didSet { needsDisplay = true } }
    var percentContent: PercentContent = .percent { didSet { needsDisplay = true } }
    var usedBytes: Int64 = 0 { didSet { needsDisplay = true } }
    var freeBytes: Int64 = 0 { didSet { needsDisplay = true } }

    override func draw(_ dirtyRect: NSRect) {
        let h = bounds.height
        let dxInset = h * 3.0 / 22.0
        let dyInset = h * 6.0 / 22.0

        if locked {
            drawLocked(referenceHeight: h)
            return
        }

        let rect = bounds.insetBy(dx: dxInset, dy: dyInset)
        let radius = rect.height / 2
        let f = CGFloat(max(0, min(1, fraction)))
        let shape = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
        let tint = customTint ?? style.fillColor
        let border = customBorder ?? tint.withAlphaComponent(0.45)
        let background = customBackground ?? NSColor.labelColor.withAlphaComponent(0.18)

        switch style.renderKind {
        case .outline:
            border.setStroke()
            shape.lineWidth = max(1, h / 22.0)
            shape.stroke()
            clipFill(shape: shape, rect: rect, fraction: f, color: tint)

        case .solid:
            guard f > 0 else { return }
            let minW = rect.height
            let w = max(minW, rect.width * f)
            let fillRect = NSRect(x: rect.minX, y: rect.minY, width: w, height: rect.height)
            tint.setFill()
            NSBezierPath(roundedRect: fillRect, xRadius: radius, yRadius: radius).fill()

        case .track:
            background.setFill()
            shape.fill()
            clipFill(shape: shape, rect: rect, fraction: f, color: tint)

        case .pillWithPercent:
            let text = labelText(fraction: Double(f))
            let outside = percentPosition == .outside
            let fontSize = h * 9.0 / 22.0 * percentSize
            let textColor: NSColor = outside ? .labelColor : .controlBackgroundColor
            let attrs: [NSAttributedString.Key: Any] = [
                .font: percentFont.font(size: fontSize, weight: percentWeight.nsWeight),
                .foregroundColor: textColor
            ]
            let textSize = (text as NSString).size(withAttributes: attrs)

            let barAreaRect: NSRect
            let textOriginX: CGFloat
            if outside {
                let spacing = h * 0.15
                let barWidth = max(rect.height, rect.width - textSize.width - spacing)
                barAreaRect = NSRect(x: rect.minX, y: rect.minY, width: barWidth, height: rect.height)
                textOriginX = barAreaRect.maxX + spacing
            } else {
                barAreaRect = rect
                let filledW = max(rect.height, rect.width * f)
                textOriginX = rect.minX + filledW / 2 - textSize.width / 2
            }

            let barRadius = barAreaRect.height / 2
            let barShape = NSBezierPath(roundedRect: barAreaRect, xRadius: barRadius, yRadius: barRadius)
            background.setFill()
            barShape.fill()
            clipFill(shape: barShape, rect: barAreaRect, fraction: f, color: tint)

            let textRect = NSRect(
                x: textOriginX,
                y: rect.midY - textSize.height / 2,
                width: textSize.width, height: textSize.height
            )
            (text as NSString).draw(in: textRect, withAttributes: attrs)
        }
    }

    private func labelText(fraction f: Double) -> String {
        switch percentContent {
        case .percent:
            return "\(Int((f * 100).rounded()))%"
        case .gbUsed:
            return ByteCountFormatter.string(fromByteCount: usedBytes, countStyle: .file)
        case .gbFree:
            return ByteCountFormatter.string(fromByteCount: freeBytes, countStyle: .file)
        }
    }

    private func drawLocked(referenceHeight h: CGFloat) {
        let pointSize = h * 12.0 / 22.0
        let config = NSImage.SymbolConfiguration(pointSize: pointSize, weight: .medium)
        guard let image = NSImage(systemSymbolName: "lock.fill", accessibilityDescription: "Locked")?
                .withSymbolConfiguration(config) else { return }
        image.isTemplate = true
        let size = image.size
        let origin = NSPoint(
            x: bounds.midX - size.width / 2,
            y: bounds.midY - size.height / 2
        )
        NSColor.tertiaryLabelColor.set()
        image.draw(at: origin, from: .zero, operation: .sourceOver, fraction: 0.85)
    }

    private func clipFill(shape: NSBezierPath, rect: NSRect, fraction: CGFloat, color: NSColor) {
        guard fraction > 0 else { return }
        let minW = rect.height
        let w = max(minW, rect.width * fraction)
        let fillRect = NSRect(x: rect.minX, y: rect.minY, width: w, height: rect.height)
        let radius = rect.height / 2
        color.setFill()
        NSBezierPath(roundedRect: fillRect, xRadius: radius, yRadius: radius).fill()
    }
}
