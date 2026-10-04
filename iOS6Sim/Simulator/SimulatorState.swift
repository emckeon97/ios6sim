import SwiftUI

/// Which mini-app is open inside the simulated iPhone.
enum AppID: String, CaseIterable, Identifiable {
    case notes
    case calculator
    case clock
    case weather
    case settings
    case photos
    case messages
    case reminders

    var id: String { rawValue }

    var title: String {
        switch self {
        case .notes: return "Notes"
        case .calculator: return "Calculator"
        case .clock: return "Clock"
        case .weather: return "Weather"
        case .settings: return "Settings"
        case .photos: return "Photos"
        case .messages: return "Messages"
        case .reminders: return "Reminders"
        }
    }
}

/// Where the simulated iPhone is.
enum SimScreen: Equatable {
    case locked
    case home
    case app(AppID)
}

/// Shared simulator state: lock/home/app, wallpaper, and per-app data.
final class SimulatorState: ObservableObject {
    @Published var screen: SimScreen = .locked
    @Published var wallpaperIndex = 0

    func unlock() { withAnimation(.easeInOut(duration: 0.35)) { screen = .home } }
    func open(_ app: AppID) { screen = .app(app) }
    func goHome() { withAnimation(.easeInOut(duration: 0.3)) { screen = .home } }
    func lock() { withAnimation(.easeInOut(duration: 0.3)) { screen = .locked } }
}
