import SwiftUI
import AppKit
import Combine
import ServiceManagement
import Sparkle

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
            "menu.checkUpdates": "Check for Updates…",
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
            "settings.pillWidth": "Pill width",
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
            "style.solid": "Solid",
            "style.outline": "Outline",
            "style.track": "Track",
            "style.pill": "Pill",
            "style.pillWithPercent": "Pill + %",
            "style.trackOutline": "Track Outline",
            "style.gradient": "Gradient",
            "style.minimal": "Minimal",
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
            "settings.section.quickClean": "Quick Clean",
            "clean.scan": "Scan",
            "clean.scanning": "Scanning…",
            "clean.cleanSelected": "Clean Selected",
            "clean.cleaning": "Cleaning…",
            "clean.totalSelected": "Total selected: %@",
            "clean.cleaned": "Cleaned: %@",
            "clean.emptyTrash": "Empty Trash",
            "clean.userCaches": "User Caches",
            "clean.logFiles": "Log Files",
            "clean.oldDownloads": "Old Downloads (>30d)",
            "clean.screenshots": "Screenshots",
            "clean.xcodeDerivedData": "Xcode Derived Data",
            "clean.browserCaches": "Browser Caches",
            "clean.iosBackups": "iOS Backups",
            "clean.iosBackupWarning": "This will delete all iPhone/iPad backups stored locally. Continue?",
            "clean.dmgFiles": "DMG Installers",
            "menu.quickClean": "Quick Clean",
            "menu.cleanNow": "Clean Selected",
        ],
        .es: [
            "menu.loading": "Cargando…",
            "menu.details": "Detalles",
            "menu.settings": "Ajustes…",
            "menu.quit": "Salir",
            "menu.checkUpdates": "Buscar actualizaciones…",
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
            "settings.pillWidth": "Ancho de la píldora",
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
            "style.solid": "Sólido",
            "style.outline": "Contorno",
            "style.track": "Trilho",
            "style.pill": "Pílula",
            "style.pillWithPercent": "Pílula + %",
            "style.trackOutline": "Trilho Contorno",
            "style.gradient": "Gradiente",
            "style.minimal": "Mínimo",
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
            "settings.section.quickClean": "Limpieza rápida",
            "clean.scan": "Escanear",
            "clean.scanning": "Escaneando…",
            "clean.cleanSelected": "Limpiar seleccionados",
            "clean.cleaning": "Limpiando…",
            "clean.totalSelected": "Total seleccionado: %@",
            "clean.cleaned": "Limpiado: %@",
            "clean.emptyTrash": "Vaciar papelera",
            "clean.userCaches": "Cachés de usuario",
            "clean.logFiles": "Archivos de registro",
            "clean.oldDownloads": "Descargas antiguas (>30d)",
            "clean.screenshots": "Capturas de pantalla",
            "clean.xcodeDerivedData": "Datos derivados de Xcode",
            "clean.browserCaches": "Cachés del navegador",
            "clean.iosBackups": "Copias de iOS",
            "clean.iosBackupWarning": "Esto eliminará todas las copias de iPhone/iPad almacenadas localmente. ¿Continuar?",
            "clean.dmgFiles": "Instaladores DMG",
            "menu.quickClean": "Limpieza rápida",
            "menu.cleanNow": "Limpiar seleccionados",
        ],
        .pt: [
            "menu.loading": "Carregando…",
            "menu.details": "Detalhes",
            "menu.settings": "Ajustes…",
            "menu.quit": "Sair",
            "menu.checkUpdates": "Verificar atualizações…",
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
            "settings.pillWidth": "Largura da pílula",
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
            "style.solid": "Sólida",
            "style.outline": "Contorno",
            "style.track": "Trilho",
            "style.pill": "Pílula",
            "style.pillWithPercent": "Pílula + %",
            "style.trackOutline": "Trilho Contorno",
            "style.gradient": "Gradiente",
            "style.minimal": "Mínima",
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
            "settings.section.quickClean": "Limpeza rápida",
            "clean.scan": "Escanear",
            "clean.scanning": "Escaneando…",
            "clean.cleanSelected": "Limpar selecionados",
            "clean.cleaning": "Limpando…",
            "clean.totalSelected": "Total selecionado: %@",
            "clean.cleaned": "Limpo: %@",
            "clean.emptyTrash": "Esvaziar lixeira",
            "clean.userCaches": "Caches do usuário",
            "clean.logFiles": "Arquivos de log",
            "clean.oldDownloads": "Downloads antigos (>30d)",
            "clean.screenshots": "Capturas de tela",
            "clean.xcodeDerivedData": "Dados derivados do Xcode",
            "clean.browserCaches": "Caches do navegador",
            "clean.iosBackups": "Backups de iOS",
            "clean.iosBackupWarning": "Isso excluirá todos os backups de iPhone/iPad armazenados localmente. Continuar?",
            "clean.dmgFiles": "Instaladores DMG",
            "menu.quickClean": "Limpeza rápida",
            "menu.cleanNow": "Limpar selecionados",
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
    @AppStorage("barStyle") private var barStyleRaw: String = BarStyle.solid.rawValue

    @AppStorage("useCustomTint") private var useCustomTint: Bool = true
    @AppStorage("tintR") private var tintR: Double = 0.45
    @AppStorage("tintG") private var tintG: Double = 0.75
    @AppStorage("tintB") private var tintB: Double = 0.25

    @AppStorage("useCustomBorder") private var useCustomBorder: Bool = false
    @AppStorage("borderR") private var borderR: Double = 0.5
    @AppStorage("borderG") private var borderG: Double = 0.5
    @AppStorage("borderB") private var borderB: Double = 0.5

    @AppStorage("selectedTintColor") private var selectedTintColor: String = "green"
    @AppStorage("backgroundOpacity") private var backgroundOpacity: Double = 0.2

    @AppStorage("percentFont") private var percentFontRaw: String = PercentFont.system.rawValue
    @AppStorage("percentWeight") private var percentWeightRaw: String = PercentWeight.heavy.rawValue
    @AppStorage("percentSize") private var percentSize: Double = 0.7
    @AppStorage("percentPosition") private var percentPositionRaw: String = PercentPosition.insideFilled.rawValue
    @AppStorage("percentContent") private var percentContentRaw: String = PercentContent.percent.rawValue
    @AppStorage("pillWidthFactor") private var pillWidthFactor: Double = 1.0
    @AppStorage("openOnLogin") private var openOnLogin: Bool = true

    @StateObject private var cleaner = StorageCleaner()
    @State private var showIOSBackupAlert = false

    private var languageBinding: Binding<Language> {
        Binding(
            get: { Language(rawValue: languageRaw) ?? .en },
            set: { languageRaw = $0.rawValue }
        )
    }
    private var styleBinding: Binding<BarStyle> {
        Binding(
            get: { BarStyle(rawValue: barStyleRaw) ?? .solid },
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
        NSColor.labelColor.withAlphaComponent(backgroundOpacity)
    }

    var body: some View {
        let _ = languageRaw

        Form {
            Section {
                HStack {
                    Spacer()
                    StorageBarPreview(
                        style: BarStyle(rawValue: barStyleRaw) ?? .solid,
                        customTint: previewTint,
                        customBorder: previewBorder,
                        customBackground: previewBackground,
                        percentFont: PercentFont(rawValue: percentFontRaw) ?? .system,
                        percentWeight: PercentWeight(rawValue: percentWeightRaw) ?? .heavy,
                        percentSize: percentSize,
                        percentPosition: PercentPosition(rawValue: percentPositionRaw) ?? .insideFilled,
                        percentContent: PercentContent(rawValue: percentContentRaw) ?? .percent,
                        pillWidthFactor: pillWidthFactor,
                        fraction: 0.62
                    )
                    .frame(width: 220, height: 80)
                    Spacer()
                }
                .padding(.vertical, 6)
            }

            Section(L.t("settings.section.appearance")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(L.t("settings.barStyle")).font(.subheadline).foregroundStyle(.secondary)
                    HStack(spacing: 6) {
                        ForEach([BarStyle.solid, .outline, .track], id: \.self) { s in
                            Button {
                                barStyleRaw = s.rawValue
                            } label: {
                                Text(L.t("style.\(s.rawValue)"))
                                    .font(.system(size: 12, weight: .medium))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(barStyleRaw == s.rawValue ? Color.accentColor : Color.secondary.opacity(0.1))
                                    .foregroundStyle(barStyleRaw == s.rawValue ? .white : .primary)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text(L.t("settings.color")).font(.subheadline).foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        ForEach(tintColors, id: \.0) { name, color in
                            Circle()
                                .fill(color)
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 2)
                                        .opacity(useCustomTint && selectedTintColor == name ? 1 : 0)
                                )
                                .shadow(radius: useCustomTint && selectedTintColor == name ? 2 : 0)
                                .onTapGesture {
                                    selectedTintColor = name
                                    useCustomTint = true
                                    let ns = NSColor(color)
                                    tintR = Double(ns.redComponent)
                                    tintG = Double(ns.greenComponent)
                                    tintB = Double(ns.blueComponent)
                                }
                        }
                    }
                }
                .padding(.vertical, 4)

                HStack {
                    Text(L.t("settings.useCustomBackground")).font(.subheadline).foregroundStyle(.secondary)
                    Spacer()
                    Slider(value: $backgroundOpacity, in: 0...0.4)
                        .frame(maxWidth: 120)
                    Text("\(Int(backgroundOpacity * 100))%").font(.caption).foregroundStyle(.secondary).frame(width: 30, alignment: .trailing)
                }
                .padding(.vertical, 4)

                HStack {
                    Text(L.t("settings.pillWidth")).font(.subheadline).foregroundStyle(.secondary)
                    Spacer()
                    Slider(value: $pillWidthFactor, in: 0.3...1.0)
                        .frame(maxWidth: 120)
                    Text("\(Int(pillWidthFactor * 100))%").font(.caption).foregroundStyle(.secondary).frame(width: 30, alignment: .trailing)
                }
                .padding(.vertical, 4)
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
                        .frame(maxWidth: 200)
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

            Section {
                HStack(spacing: 8) {
                    Button {
                        Task { await cleaner.scanAll() }
                    } label: {
                        Label(
                            cleaner.isScanning ? L.t("clean.scanning") : L.t("clean.scan"),
                            systemImage: cleaner.isScanning ? "arrow.triangle.2.circlepath" : "magnifyingglass"
                        )
                    }
                    .disabled(cleaner.isScanning || cleaner.isCleaning)

                    Button {
                        let hasIOS = cleaner.categories.first(where: { $0.category == .iosBackups })?.selected ?? false
                        if hasIOS {
                            showIOSBackupAlert = true
                        } else {
                            Task { await cleaner.cleanSelected() }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: cleaner.isCleaning ? "arrow.triangle.2.circlepath" : "broom")
                                .font(.system(size: 13))
                            Text(cleaner.isCleaning ? L.t("clean.cleaning") : L.t("clean.cleanSelected"))
                                .font(.system(size: 13, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(cleaner.isScanning || cleaner.isCleaning || cleaner.totalSelectedBytes == 0)

                    Spacer()

                    if cleaner.showCleanResult {
                        Text(String(format: L.t("clean.cleaned"), ByteCountFormatter.string(fromByteCount: cleaner.cleanedBytes, countStyle: .file)))
                            .foregroundStyle(.green)
                            .font(.caption)
                    }
                }

                ForEach($cleaner.categories) { $cat in
                    HStack {
                        Toggle(L.t("clean.\(cat.category.rawValue)"), isOn: $cat.selected)
                            .onChange(of: cat.selected) { _, _ in
                                cleaner.toggleSelection(cat.category)
                            }
                        Spacer()
                        if cat.scanning {
                            ProgressView().controlSize(.small)
                        } else if cat.sizeBytes > 0 {
                            Text(ByteCountFormatter.string(fromByteCount: cat.sizeBytes, countStyle: .file))
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                }

                if cleaner.totalSelectedBytes > 0 {
                    Text(String(format: L.t("clean.totalSelected"), ByteCountFormatter.string(fromByteCount: cleaner.totalSelectedBytes, countStyle: .file)))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text(L.t("settings.section.quickClean"))
            }
        }
        .formStyle(.grouped)
        .frame(width: 520, height: 1000)
        .alert(L.t("clean.iosBackups"), isPresented: $showIOSBackupAlert) {
            Button(L.t("clean.cleanSelected"), role: .destructive) {
                Task { await cleaner.cleanSelected() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(L.t("clean.iosBackupWarning"))
        }
        .onChange(of: openOnLogin) { _, newValue in
            LoginItemManager.setEnabled(newValue)
        }
    }

    private var tintColors: [(String, Color)] {
        [
            ("green", Color(red: 0.45, green: 0.75, blue: 0.25)),
            ("orange", Color(red: 0.9, green: 0.55, blue: 0.2)),
            ("pink", Color(red: 0.9, green: 0.35, blue: 0.5)),
            ("blue", Color(red: 0.25, green: 0.5, blue: 0.85)),
            ("purple", Color(red: 0.55, green: 0.3, blue: 0.75)),
            ("teal", Color(red: 0.2, green: 0.65, blue: 0.55))
        ]
    }
}

// MARK: - MenuBarPopoverView

struct MenuBarPopoverView: View {
    @ObservedObject var cleaner: StorageCleaner
    let onSettings: () -> Void
    let onDetails: () -> Void
    let onActivate: () -> Void
    let onCheckUpdates: () -> Void
    let onQuit: () -> Void

    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "v\(v) (\(b))"
    }

    @State private var usage: DiskUsage?
    @State private var showCleanConfirm = false
    @State private var isCleaning = false
    @State private var cleanedBytes: Int64 = 0
    @State private var showCleanResult = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("StorageBar")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                Text(appVersion)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.white.opacity(0.35))
                Spacer()
                Button {
                    Task {
                        usage = DiskUsage.current()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .buttonStyle(.plain)
                .padding(.trailing, 4)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            if let usage = usage {
                StorageRingView(fraction: usage.fraction, size: 120)
                    .padding(.top, 4)
                    .padding(.bottom, 8)

                let used = ByteCountFormatter.string(fromByteCount: usage.usedBytes, countStyle: .file)
                let total = ByteCountFormatter.string(fromByteCount: usage.totalBytes, countStyle: .file)

                Text("\(used) / \(total)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 12)
            } else {
                ProgressView()
                    .padding(20)
            }

            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.horizontal, 16)

            Button {
                showCleanConfirm = true
            } label: {
                HStack {
                    Image(systemName: "broom")
                        .font(.system(size: 13))
                    Text(L.t("menu.quickClean"))
                        .font(.system(size: 13, weight: .medium))
                    Spacer()
                    if isCleaning {
                        ProgressView().controlSize(.small)
                    } else if showCleanResult {
                        Text(ByteCountFormatter.string(fromByteCount: cleanedBytes, countStyle: .file))
                            .font(.system(size: 11))
                            .foregroundStyle(.green)
                    }
                }
                .foregroundStyle(.white.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
            .background(Color.white.opacity(0.05))
            .cornerRadius(8)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .disabled(isCleaning)
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.15), value: isCleaning)
            .confirmationDialog(L.t("menu.quickClean"), isPresented: $showCleanConfirm) {
                Button(L.t("clean.cleanSelected"), role: .destructive) {
                    runClean()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                let total = ByteCountFormatter.string(fromByteCount: cleaner.totalSelectedBytes, countStyle: .file)
                Text("This will clean selected categories (~\(total)).")
            }

            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.horizontal, 16)

            MenuRow(icon: "info.circle", label: L.t("menu.details"), action: onDetails)
            MenuRow(icon: "gear", label: L.t("menu.settings"), action: onSettings)
            MenuRow(icon: LicenseManager.shared.isActivated ? "checkmark.seal.fill" : "lock.fill",
                    label: LicenseManager.shared.isActivated ? L.t("menu.activated") : L.t("menu.activate"),
                    action: onActivate)
            MenuRow(icon: "arrow.triangle.2.circlepath", label: L.t("menu.checkUpdates"), action: onCheckUpdates)

            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.horizontal, 16)

            MenuRow(icon: "xmark.circle", label: L.t("menu.quit"), action: onQuit)
                .padding(.bottom, 8)
        }
        .frame(width: 260)
        .background(Color(.black).opacity(0.85))
        .cornerRadius(12)
        .onAppear {
            usage = DiskUsage.current()
        }
        .onChange(of: cleaner.cleanedBytes) { _, newVal in
            if newVal > 0 {
                cleanedBytes = newVal
                showCleanResult = true
            }
        }
    }

    private func runClean() {
        isCleaning = true
        showCleanResult = false
        Task {
            await cleaner.cleanSelected()
            isCleaning = false
            usage = DiskUsage.current()
        }
    }
}

struct MenuRow: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .frame(width: 20)
                    .foregroundStyle(.white.opacity(0.5))
                Text(label)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.8))
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

struct StorageRingView: View {
    let fraction: Double
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: size * 0.12)
                .frame(width: size, height: size)

            Circle()
                .trim(from: 0, to: CGFloat(fraction))
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(red: 0.95, green: 0.35, blue: 0.3),
                            Color(red: 0.7, green: 0.3, blue: 0.65),
                            Color(red: 0.5, green: 0.3, blue: 0.9)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: size * 0.12, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))

            VStack(spacing: 4) {
                Text("\(Int((fraction * 100).rounded()))%")
                    .font(.system(size: size * 0.28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("Used")
                    .font(.system(size: size * 0.1, weight: .medium))
                    .foregroundStyle(.white.opacity(0.45))
            }
        }
        .padding(.bottom, 8)
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
    let pillWidthFactor: Double
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
        view.pillWidthFactor = pillWidthFactor
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
    private var activationItem: NSMenuItem?
    private var timer: Timer?
    private var settingsWindow: NSWindow?
    private var activationWindow: NSWindow?
    private var cleaner = StorageCleaner()
    private var popover: NSPopover?
    private var popoverHosting: NSHostingController<MenuBarPopoverView>?
    private let updaterController: SPUStandardUpdaterController

    override init() {
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
        super.init()
    }

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
            view.pillWidthFactor = loadPillWidthFactor()
            view.locked = !LicenseManager.shared.isLicensed
            button.addSubview(view)
            barView = view

            button.action = #selector(togglePopover)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        let hosting = NSHostingController(rootView: MenuBarPopoverView(
            cleaner: cleaner,
            onSettings: { [weak self] in self?.openSettingsWindow() },
            onDetails: { [weak self] in self?.openStorageSettings() },
            onActivate: { [weak self] in self?.openActivationWindow() },
            onCheckUpdates: { [weak self] in self?.checkForUpdates() },
            onQuit: { NSApplication.shared.terminate(nil) }
        ))
        popoverHosting = hosting

        let pop = NSPopover()
        pop.contentViewController = hosting
        pop.behavior = .transient
        pop.animates = true
        popover = pop

        refresh()
        Task {
            await cleaner.scanAll()
        }
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

    @objc private func togglePopover() {
        if let pop = popover, pop.isShown {
            pop.performClose(nil)
        } else {
            refreshPopover()
            if let button = statusItem.button {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    private func refreshPopover() {
        popoverHosting?.rootView = MenuBarPopoverView(
            cleaner: cleaner,
            onSettings: { [weak self] in
                self?.popover?.performClose(nil)
                self?.openSettingsWindow()
            },
            onDetails: { [weak self] in
                self?.popover?.performClose(nil)
                self?.openStorageSettings()
            },
            onActivate: { [weak self] in
                self?.popover?.performClose(nil)
                self?.openActivationWindow()
            },
            onCheckUpdates: { [weak self] in
                self?.popover?.performClose(nil)
                self?.checkForUpdates()
            },
            onQuit: { NSApplication.shared.terminate(nil) }
        )
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
        barView.pillWidthFactor = loadPillWidthFactor()
        let nowLocked = !LicenseManager.shared.isLicensed
        if barView.locked != nowLocked { barView.locked = nowLocked }
        refresh()
        if popover?.isShown == true { refreshPopover() }
        // títulos de janelas
        settingsWindow?.title = L.t("settings.title")
        activationWindow?.title = L.t("activation.title")
    }

    @objc private func closeActivationWindowNotif() {
        activationWindow?.close()
        barView.locked = !LicenseManager.shared.isLicensed
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

    @objc private func checkForUpdates() {
        updaterController.checkForUpdates(nil)
    }

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
              let style = BarStyle(rawValue: raw) else { return .solid }
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

    private func loadPillWidthFactor() -> Double {
        let v = UserDefaults.standard.double(forKey: "pillWidthFactor")
        return v == 0 ? 1.0 : v
    }

    private func refresh() {
        let nowLocked = !LicenseManager.shared.isLicensed
        if barView.locked != nowLocked { barView.locked = nowLocked }

        guard let usage = DiskUsage.current() else { return }
        barView.fraction = usage.fraction
        barView.usedBytes = usage.usedBytes
        barView.freeBytes = usage.availableBytes
        if popover?.isShown == true { refreshPopover() }
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
    case solid, outline, track, pillWithPercent, trackOutline, gradient, minimal

    enum RenderKind { case solid, outline, track, pillWithPercent, trackOutline, gradient, minimal }

    var displayName: String { L.t("style.\(rawValue)") }

    var fillColor: NSColor {
        switch self {
        case .gradient: return .controlAccentColor
        default: return .labelColor
        }
    }

    var renderKind: RenderKind {
        switch self {
        case .solid:          return .solid
        case .outline:        return .outline
        case .track:          return .track
        case .pillWithPercent: return .pillWithPercent
        case .trackOutline:   return .trackOutline
        case .gradient:       return .gradient
        case .minimal:        return .minimal
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

// MARK: - StorageCleaner

enum CleanCategory: String, CaseIterable, Identifiable {
    case emptyTrash, userCaches, logFiles, oldDownloads, screenshots, xcodeDerivedData, browserCaches, iosBackups, dmgFiles
    var id: String { rawValue }
}

@MainActor
final class StorageCleaner: ObservableObject {
    struct CategoryInfo: Identifiable {
        let category: CleanCategory
        var sizeBytes: Int64 = 0
        var selected: Bool = true
        var scanning: Bool = false
        var id: String { category.rawValue }
    }

    @Published var categories: [CategoryInfo] = CleanCategory.allCases.map { CategoryInfo(category: $0) }
    @Published var isScanning: Bool = false
    @Published var isCleaning: Bool = false
    @Published var cleanedBytes: Int64 = 0
    @Published var showCleanResult: Bool = false

    private let ud = UserDefaults.standard

    init() {
        for cat in CleanCategory.allCases {
            let key = "cleanSelected_\(cat.rawValue)"
            if ud.object(forKey: key) == nil {
                ud.set(true, forKey: key)
            }
        }
        loadSelections()
    }

    private func loadSelections() {
        for i in categories.indices {
            let key = "cleanSelected_\(categories[i].category.rawValue)"
            categories[i].selected = ud.bool(forKey: key)
        }
    }

    func toggleSelection(_ cat: CleanCategory) {
        if let idx = categories.firstIndex(where: { $0.category == cat }) {
            categories[idx].selected.toggle()
            ud.set(categories[idx].selected, forKey: "cleanSelected_\(cat.rawValue)")
        }
    }

    var totalSelectedBytes: Int64 {
        categories.filter(\.selected).reduce(0) { $0 + $1.sizeBytes }
    }

    func scanAll() async {
        isScanning = true
        let cats = categories.map(\.category)
        await withTaskGroup(of: (Int, Int64).self) { group in
            for i in cats.indices {
                let cat = cats[i]
                group.addTask {
                    let size = Self.scanSize(for: cat)
                    return (i, size)
                }
            }
            for await (idx, size) in group {
                categories[idx].sizeBytes = size
            }
        }
        isScanning = false
    }

    func cleanSelected() async {
        isCleaning = true
        cleanedBytes = 0
        let selected = categories.filter(\.selected).map(\.category)
        for cat in selected {
            cleanedBytes += Self.cleanSize(for: cat)
        }
        showCleanResult = cleanedBytes > 0
        isCleaning = false
        await scanAll()
    }

    nonisolated static func scanSize(for cat: CleanCategory) -> Int64 {
        let paths = targetPaths(for: cat)
        return paths.reduce(0) { $0 + directorySize(at: $1) }
    }

    nonisolated static func cleanSize(for cat: CleanCategory) -> Int64 {
        let paths = targetPaths(for: cat)
        var total: Int64 = 0
        for path in paths {
            total += directorySize(at: path)
            try? FileManager.default.removeItem(atPath: path)
        }
        return total
    }

    nonisolated static func targetPaths(for cat: CleanCategory) -> [String] {
        let home = NSHomeDirectory()
        switch cat {
        case .emptyTrash:
            return [home + "/.Trash"]
        case .userCaches:
            let cachesDir = home + "/Library/Caches"
            guard let contents = try? FileManager.default.contentsOfDirectory(atPath: cachesDir) else { return [] }
            return contents
                .filter { $0 != "com.apple" && !$0.hasPrefix("com.apple.") }
                .map { cachesDir + "/" + $0 }
        case .logFiles:
            return [home + "/Library/Logs"]
        case .oldDownloads:
            let dlDir = home + "/Downloads"
            guard let contents = try? FileManager.default.contentsOfDirectory(atPath: dlDir) else { return [] }
            let cutoff = Date().addingTimeInterval(-30 * 86400)
            return contents.compactMap { name -> String? in
                let fullPath = dlDir + "/" + name
                if let fmAttrs = try? FileManager.default.attributesOfItem(atPath: fullPath),
                   let modDate = fmAttrs[.modificationDate] as? Date,
                   modDate < cutoff {
                    return fullPath
                }
                return nil
            }
        case .screenshots:
            let desktop = home + "/Desktop"
            guard let contents = try? FileManager.default.contentsOfDirectory(atPath: desktop) else { return [] }
            return contents
                .filter { $0.hasPrefix("Screenshot") && ($0.hasSuffix(".png") || $0.hasSuffix(".jpg")) }
                .map { desktop + "/" + $0 }
        case .xcodeDerivedData:
            return [home + "/Library/Developer/Xcode/DerivedData"]
        case .browserCaches:
            return [
                home + "/Library/Caches/com.apple.Safari",
                home + "/Library/Caches/com.apple.Safari.Search",
                home + "/Library/Caches/com.apple.SafariTechnologyPreview",
                home + "/Library/Caches/Google/Chrome",
                home + "/Library/Caches/Google/Chrome/Default/Cache",
                home + "/Library/Caches/Google/Chrome/Default/Media Cache",
                home + "/Library/Caches/com.google.Chrome"
            ]
        case .iosBackups:
            return [home + "/Library/Application Support/MobileSync/Backup"]
        case .dmgFiles:
            let dlDir = home + "/Downloads"
            guard let contents = try? FileManager.default.contentsOfDirectory(atPath: dlDir) else { return [] }
            return contents
                .filter { $0.lowercased().hasSuffix(".dmg") }
                .map { dlDir + "/" + $0 }
        }
    }

    nonisolated static func directorySize(at path: String) -> Int64 {
        guard let enumerator = FileManager.default.enumerator(atPath: path) else {
            if let attrs = try? FileManager.default.attributesOfItem(atPath: path),
               let size = attrs[.size] as? NSNumber {
                return size.int64Value
            }
            return 0
        }
        var total: Int64 = 0
        while let file = enumerator.nextObject() as? String {
            let fullPath = path + "/" + file
            if let attrs = try? FileManager.default.attributesOfItem(atPath: fullPath),
               let size = attrs[.size] as? NSNumber {
                total += size.int64Value
            }
        }
        return total
    }
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
    var pillWidthFactor: Double = 1.0 { didSet { needsDisplay = true } }
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
        let tint = customTint ?? style.fillColor
        let border = customBorder ?? tint.withAlphaComponent(0.45)
        let background = customBackground ?? NSColor.labelColor.withAlphaComponent(0.18)

        switch style.renderKind {
        case .solid:
            let barWidthFactor = pillWidthFactor
            let barAreaWidth = rect.width * barWidthFactor
            let barAreaRect = NSRect(x: rect.minX, y: rect.minY, width: barAreaWidth, height: rect.height)
            let barRadius = barAreaRect.height / 2
            let barShape = NSBezierPath(roundedRect: barAreaRect, xRadius: barRadius, yRadius: barRadius)
            background.setFill()
            barShape.fill()
            clipFill(shape: barShape, rect: barAreaRect, fraction: f, color: tint)

        case .outline:
            let barWidthFactor = pillWidthFactor
            let barAreaWidth = rect.width * barWidthFactor
            let barAreaRect = NSRect(x: rect.minX, y: rect.minY, width: barAreaWidth, height: rect.height)
            let barRadius = barAreaRect.height / 2
            let barShape = NSBezierPath(roundedRect: barAreaRect, xRadius: barRadius, yRadius: barRadius)
            border.setStroke()
            barShape.lineWidth = max(1, h / 22.0)
            barShape.stroke()
            clipFill(shape: barShape, rect: barAreaRect, fraction: f, color: tint)

        case .track:
            let barWidthFactor = pillWidthFactor
            let barAreaWidth = rect.width * barWidthFactor
            let barAreaRect = NSRect(x: rect.minX, y: rect.minY, width: barAreaWidth, height: rect.height)
            let barRadius = barAreaRect.height / 2
            let barShape = NSBezierPath(roundedRect: barAreaRect, xRadius: barRadius, yRadius: barRadius)
            background.setFill()
            barShape.fill()
            clipFill(shape: barShape, rect: barAreaRect, fraction: f, color: tint)

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

            let barWidthFactor = pillWidthFactor
            let barAreaWidth = rect.width * barWidthFactor
            let barAreaRect = NSRect(x: rect.minX, y: rect.minY, width: barAreaWidth, height: rect.height)

            let textOriginX: CGFloat
            if outside {
                let spacing = h * 0.15
                textOriginX = barAreaRect.maxX + spacing
            } else {
                let filledW = max(barAreaRect.height, barAreaWidth * f)
                textOriginX = barAreaRect.minX + filledW / 2 - textSize.width / 2
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

        case .trackOutline:
            let barWidthFactor = pillWidthFactor
            let barAreaWidth = rect.width * barWidthFactor
            let barAreaRect = NSRect(x: rect.minX, y: rect.minY, width: barAreaWidth, height: rect.height)
            let barRadius = barAreaRect.height / 2
            let barShape = NSBezierPath(roundedRect: barAreaRect, xRadius: barRadius, yRadius: barRadius)
            background.setFill()
            barShape.fill()
            clipFill(shape: barShape, rect: barAreaRect, fraction: f, color: tint)
            border.setStroke()
            barShape.lineWidth = max(1, h / 28.0)
            barShape.stroke()

        case .gradient:
            let barWidthFactor = pillWidthFactor
            let barAreaWidth = rect.width * barWidthFactor
            let barAreaRect = NSRect(x: rect.minX, y: rect.minY, width: barAreaWidth, height: rect.height)
            let barRadius = barAreaRect.height / 2
            let barShape = NSBezierPath(roundedRect: barAreaRect, xRadius: barRadius, yRadius: barRadius)
            background.setFill()
            barShape.fill()
            clipFillGradient(shape: barShape, rect: barAreaRect, fraction: f, startColor: NSColor(red: 0.45, green: 0.75, blue: 0.25, alpha: 1), endColor: NSColor(red: 0.9, green: 0.55, blue: 0.2, alpha: 1))

        case .minimal:
            let barWidthFactor = pillWidthFactor
            let barAreaWidth = rect.width * barWidthFactor
            let barAreaRect = NSRect(x: rect.minX, y: rect.midY - 1.5, width: barAreaWidth, height: 3)
            let trackPath = NSBezierPath()
            trackPath.move(to: NSPoint(x: barAreaRect.minX, y: barAreaRect.midY))
            trackPath.line(to: NSPoint(x: barAreaRect.maxX, y: barAreaRect.midY))
            NSColor.labelColor.withAlphaComponent(0.15).setStroke()
            trackPath.lineWidth = 3
            trackPath.stroke()
            let fillW = max(0, barAreaWidth * Double(f))
            let fillPath = NSBezierPath()
            fillPath.move(to: NSPoint(x: barAreaRect.minX, y: barAreaRect.midY))
            fillPath.line(to: NSPoint(x: barAreaRect.minX + fillW, y: barAreaRect.midY))
            tint.setStroke()
            fillPath.lineWidth = 3
            fillPath.lineCapStyle = .round
            fillPath.stroke()
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

    private func clipFillGradient(shape: NSBezierPath, rect: NSRect, fraction: CGFloat, startColor: NSColor, endColor: NSColor) {
        guard fraction > 0 else { return }
        let minW = rect.height
        let w = max(minW, rect.width * fraction)
        let fillRect = NSRect(x: rect.minX, y: rect.minY, width: w, height: rect.height)
        let radius = rect.height / 2
        let gradient = NSGradient(starting: startColor, ending: endColor)
        gradient?.draw(in: NSBezierPath(roundedRect: fillRect, xRadius: radius, yRadius: radius), angle: 0)
    }
}
