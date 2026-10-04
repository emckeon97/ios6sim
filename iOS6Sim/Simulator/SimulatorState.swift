import SwiftUI

/// A user-built Cydia tweak: kind is "carrier", "tint", "hidelabels", or "pageeffect".
struct CustomTweak: Codable, Identifiable {
    var id = UUID()
    var name: String
    var kind: String
    var value: String
}

/// Which mini-app is open inside the simulated iPhone.
/// Stock iOS 6 lineup: dock + two home pages.
enum AppID: String, CaseIterable, Identifiable {
    // Dock
    case phone
    case mail
    case safari
    case music
    // Page 1
    case messages
    case calendar
    case photos
    case camera
    case weather
    case clock
    case maps
    case notes
    case reminders
    case stocks
    case newsstand
    case settings
    // Page 2
    case itunes
    case appstore
    case gamecenter
    case youtube
    case passbook
    case compass
    case evasi0n
    case cydia
    // Bonus (not stock iPhone, kept from earlier)
    case calculator

    var id: String { rawValue }

    var title: String {
        switch self {
        case .phone: return "Phone"
        case .mail: return "Mail"
        case .safari: return "Safari"
        case .music: return "Music"
        case .messages: return "Messages"
        case .calendar: return "Calendar"
        case .photos: return "Photos"
        case .camera: return "Camera"
        case .weather: return "Weather"
        case .clock: return "Clock"
        case .maps: return "Maps"
        case .notes: return "Notes"
        case .reminders: return "Reminders"
        case .stocks: return "Stocks"
        case .newsstand: return "Newsstand"
        case .settings: return "Settings"
        case .itunes: return "iTunes"
        case .appstore: return "App Store"
        case .gamecenter: return "Game Center"
        case .youtube: return "YouTube"
        case .passbook: return "Passbook"
        case .compass: return "Compass"
        case .evasi0n: return "evasi0n"
        case .cydia: return "Cydia"
        case .calculator: return "Calculator"
        }
    }

    /// Apps in the dock.
    static var dockApps: [AppID] { [.phone, .mail, .safari, .music] }
    /// Apps on home page 1.
    static var page1Apps: [AppID] {
        [.messages, .calendar, .photos, .camera,
         .weather, .clock, .maps, .notes,
         .reminders, .stocks, .newsstand, .settings]
    }
    /// Apps on home page 2.
    static var page2Apps: [AppID] {
        [.itunes, .appstore, .gamecenter, .youtube,
         .passbook, .compass, .evasi0n, .calculator]
    }
    /// Cydia joins page 2 once jailbroken.
    static func page2Apps(jailbroken: Bool) -> [AppID] {
        jailbroken ? page2Apps + [.cydia] : page2Apps
    }
}

/// Where the simulated iPhone is.
enum SimScreen: Equatable {
    case locked
    case home
    case app(AppID)
}

/// Shared simulator state: lock/home/app, wallpaper, multitasking, and per-app data.
final class SimulatorState: ObservableObject {
    @Published var screen: SimScreen = .locked
    @Published var wallpaperIndex = 0
    /// Recently used apps, most recent first (for the app switcher).
    @Published var recentApps: [AppID] = []
    /// Whether the multitasking switcher tray is visible.
    @Published var showingSwitcher = false

    // MARK: - Jailbreak (simulated, like a VM)
    /// Persisted jailbreak state.
    @Published var isJailbroken: Bool {
        didSet { UserDefaults.standard.set(isJailbroken, forKey: "ios6sim.jailbroken") }
    }
    /// Installed Cydia tweak IDs, persisted as a comma-separated string.
    @Published var installedTweaks: Set<String> {
        didSet { UserDefaults.standard.set(installedTweaks.sorted().joined(separator: ","), forKey: "ios6sim.tweaks") }
    }

    init() {
        self.isJailbroken = UserDefaults.standard.bool(forKey: "ios6sim.jailbroken")
        let raw = UserDefaults.standard.string(forKey: "ios6sim.tweaks") ?? ""
        self.installedTweaks = Set(raw.split(separator: ",").map(String.init).filter { !$0.isEmpty })
        self.customTweaks = []
        self.customTweaks = loadCustomTweaks()
    }

    var winterboardOn: Bool { installedTweaks.contains("winterboard") && isJailbroken }
    /// Barrel page effects active?
    var barrelOn: Bool { installedTweaks.contains("barrel") && isJailbroken }
    /// SBSettings quick toggles in the switcher?
    var sbsettingsOn: Bool { installedTweaks.contains("sbsettings") && isJailbroken }

    func installTweak(_ id: String) { installedTweaks.insert(id) }
    func removeTweak(_ id: String) { installedTweaks.remove(id) }

    /// Remove the jailbreak entirely (restore to stock).
    func unjailbreak() {
        isJailbroken = false
        installedTweaks = []
        customTweaks = []
        recentApps.removeAll { $0 == .cydia }
        if case .app(.cydia) = screen { screen = .home }
    }

    // MARK: - Custom tweaks (built in Cydia's tweak builder)
    @Published var customTweaks: [CustomTweak] {
        didSet { persistCustomTweaks() }
    }

    private func persistCustomTweaks() {
        if let data = try? JSONEncoder().encode(customTweaks) {
            UserDefaults.standard.set(data, forKey: "ios6sim.customtweaks")
        }
    }

    private func loadCustomTweaks() -> [CustomTweak] {
        guard let data = UserDefaults.standard.data(forKey: "ios6sim.customtweaks"),
              let tweaks = try? JSONDecoder().decode([CustomTweak].self, from: data)
        else { return [] }
        return tweaks
    }

    func addCustomTweak(name: String, kind: String, value: String) {
        // One tweak per kind (except carriers stack to the last one).
        customTweaks.removeAll { $0.kind == kind }
        customTweaks.append(CustomTweak(name: name, kind: kind, value: value))
    }

    func removeCustomTweak(_ tweak: CustomTweak) {
        customTweaks.removeAll { $0.id == tweak.id }
    }

    /// Fake carrier text ("MakeItMine"-style).
    var customCarrier: String? {
        customTweaks.first(where: { $0.kind == "carrier" })?.value
    }
    /// Icon tint hex ("IconTint"-style).
    var iconTintHex: String? {
        customTweaks.first(where: { $0.kind == "tint" })?.value
    }
    var iconTint: Color? {
        iconTintHex.flatMap { Color(hex: $0) }
    }
    /// Hide icon labels ("NoLabels"-style).
    var hideIconLabels: Bool {
        isJailbroken && customTweaks.contains(where: { $0.kind == "hidelabels" })
    }
    /// Page transition effect: "cube", "flip", or "fade".
    var pageEffectName: String? {
        guard isJailbroken else { return nil }
        if let custom = customTweaks.first(where: { $0.kind == "pageeffect" })?.value {
            return custom
        }
        return barrelOn ? "cube" : nil
    }

    func unlock() { withAnimation(.easeInOut(duration: 0.35)) { screen = .home } }
    func open(_ app: AppID) {
        // Track for multitasking (most recent first, no duplicates).
        recentApps.removeAll { $0 == app }
        recentApps.insert(app, at: 0)
        if recentApps.count > 12 { recentApps = Array(recentApps.prefix(12)) }
        showingSwitcher = false
        screen = .app(app)
    }
    func goHome() {
        withAnimation(.easeInOut(duration: 0.3)) {
            screen = .home
            showingSwitcher = false
        }
    }
    func lock() {
        withAnimation(.easeInOut(duration: 0.3)) {
            screen = .locked
            showingSwitcher = false
        }
    }
    /// Toggle the multitasking switcher (double-click home).
    func toggleSwitcher() {
        withAnimation(.easeInOut(duration: 0.25)) {
            showingSwitcher.toggle()
        }
    }
    /// Home button: single press goes home, double-click opens the switcher.
    func homeButtonTap() {
        guard screen != .locked else { return }
        let now = Date()
        if now.timeIntervalSince(lastHomeTap) < 0.4 {
            lastHomeTap = .distantPast
            toggleSwitcher()
        } else {
            lastHomeTap = now
            goHome()
        }
    }
    private var lastHomeTap = Date.distantPast
    /// Remove an app from recents (swipe up / tap X in switcher).
    func closeApp(_ app: AppID) {
        recentApps.removeAll { $0 == app }
        // If closing the currently open app, go home.
        if case .app(let current) = screen, current == app {
            screen = .home
        }
        if recentApps.isEmpty { showingSwitcher = false }
    }
}
