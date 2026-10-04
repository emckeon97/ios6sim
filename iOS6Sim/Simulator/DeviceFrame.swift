import SwiftUI

/// The iPhone 5 hardware frame around the simulated iOS 6 screen.
/// Screen content is 320×568 points, scaled to fit the window.
struct DeviceFrame: View {
    @EnvironmentObject var sim: SimulatorState

    var body: some View {
        GeometryReader { geo in
            let scale = min(geo.size.width / 400, geo.size.height / 720)
            ZStack {
                Color(red: 0.12, green: 0.12, blue: 0.14)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    // The iPhone.
                    ZStack {
                        // Bezel.
                        RoundedRectangle(cornerRadius: 44 * scale, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.18, green: 0.18, blue: 0.20),
                                             Color(red: 0.05, green: 0.05, blue: 0.06)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 400 * scale, height: 720 * scale)
                            .shadow(color: .black.opacity(0.5), radius: 24, y: 10)

                        VStack(spacing: 0) {
                            // Earpiece + camera.
                            ZStack {
                                RoundedRectangle(cornerRadius: 3 * scale)
                                    .fill(Color(red: 0.02, green: 0.02, blue: 0.03))
                                    .frame(width: 56 * scale, height: 8 * scale)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3 * scale)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                Circle()
                                    .fill(Color(red: 0.10, green: 0.12, blue: 0.18))
                                    .frame(width: 10 * scale, height: 10 * scale)
                                    .offset(x: -44 * scale)
                            }
                            .frame(height: 44 * scale)

                            // Screen.
                            ScreenHost()
                                .frame(width: 320 * scale, height: 568 * scale)
                                .clipShape(RoundedRectangle(cornerRadius: 4 * scale))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4 * scale)
                                        .stroke(Color.black, lineWidth: 2 * scale))

                            // Home button (circular, like the real iPhone).
                            Button { sim.homeButtonTap() } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.10, green: 0.10, blue: 0.11))
                                        .frame(width: 56 * scale, height: 56 * scale)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray.opacity(0.35), lineWidth: 1.5))
                                    RoundedRectangle(cornerRadius: 4 * scale)
                                        .stroke(Color.gray.opacity(0.6), lineWidth: 2 * scale)
                                        .frame(width: 20 * scale, height: 20 * scale)
                                }
                            }
                            .buttonStyle(.plain)
                            .frame(height: 76 * scale)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }
}

/// Fullscreen iOS 6 experience, tuned for iPhone 16e (390×844 pt).
/// The 320×568 simulated screen is scaled to fit above a fixed
/// home-button zone — screen content can never bleed into the button area.
struct FullscreenSimView: View {
    @EnvironmentObject var sim: SimulatorState

    // iPhone 16e: 390×844 pt (1170×2532 px @3x), notch up top.
    private let homeZone: CGFloat = 112
    private let topInset: CGFloat = 30

    var body: some View {
        GeometryReader { geo in
            let availH = max(geo.size.height - topInset - homeZone, 1)
            let scale = min(geo.size.width / 320, availH / 568)
            let sw = 320 * scale
            let sh = 568 * scale
            ZStack {
                // True black — blends into the OLED display.
                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top black bar (notch clearance).
                    Color.black
                        .frame(height: topInset)

                    // The simulated iOS 6 screen, scaled to fit.
                    // .topLeading anchor + matching frame alignment means the
                    // rendered pixels exactly fill the frame — no drift.
                    ScreenHost()
                        .frame(width: 320, height: 568)
                        .scaleEffect(scale, anchor: .topLeading)
                        .frame(width: sw, height: sh, alignment: .topLeading)
                        .clipped()

                    // Bottom black area with visible home button.
                    ZStack {
                        Color.black
                        Button { sim.homeButtonTap() } label: {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.12, green: 0.12, blue: 0.13))
                                    .frame(width: 58, height: 58)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1.5))
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray.opacity(0.65), lineWidth: 2)
                                    .frame(width: 22, height: 22)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(height: homeZone)

                    // Any leftover strip (home-indicator area) stays black.
                    Color.black
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .ignoresSafeArea()
            }
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .persistentSystemOverlays(.hidden)
    }
}

/// Routes the simulated screen: lock → home → app.
struct ScreenHost: View {
    @EnvironmentObject var sim: SimulatorState

    var body: some View {
        ZStack {
            switch sim.screen {
            case .locked:
                LockScreen()
                    .transition(.opacity)
            case .home:
                HomeScreen()
                    .transition(.opacity)
            case .app(let app):
                AppHost(app: app)
                    .transition(.scale(scale: 1.15).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: sim.screen)
        .background(Color.black)
    }
}

/// Wraps a mini-app with the iOS 6 status bar.
struct AppHost: View {
    let app: AppID

    var body: some View {
        VStack(spacing: 0) {
            switch app {
            case .phone: PhoneApp()
            case .mail: MailApp()
            case .safari: SafariApp()
            case .music: MusicApp()
            case .notes: NotesApp()
            case .calculator: CalculatorApp()
            case .clock: ClockApp()
            case .weather: WeatherApp()
            case .settings: SettingsApp()
            case .photos: PhotosApp()
            case .messages: MessagesApp()
            case .reminders: RemindersApp()
            case .calendar: CalendarApp()
            case .camera: CameraApp()
            case .maps: MapsApp()
            case .stocks: StocksApp()
            case .newsstand: NewsstandApp()
            case .itunes: iTunesApp()
            case .appstore: AppStoreApp()
            case .gamecenter: GameCenterApp()
            case .youtube: YouTubeApp()
            case .passbook: PassbookApp()
            case .compass: CompassApp()
            case .evasi0n: Evasi0nApp()
            case .cydia: CydiaApp()
            }
        }
    }
}

/// Classic iOS 6 blue navigation bar.
struct iOS6NavBar: View {
    let title: String
    var left: AnyView? = nil
    var right: AnyView? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.45, green: 0.60, blue: 0.78),
                         Color(red: 0.28, green: 0.42, blue: 0.62)],
                startPoint: .top, endPoint: .bottom)
            HStack {
                if let left { left } else { Spacer().frame(width: 60) }
                Spacer()
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 1, y: 1)
                Spacer()
                if let right { right } else { Spacer().frame(width: 60) }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 44)
        .overlay(
            Rectangle().fill(Color.black.opacity(0.3)).frame(height: 1),
            alignment: .bottom)
    }
}

/// iOS 6-style back button.
struct iOS6BackButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 2) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .bold))
                Text(label)
                    .font(.system(size: 13, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.35, green: 0.50, blue: 0.70),
                             Color(red: 0.20, green: 0.32, blue: 0.52)],
                    startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black.opacity(0.35), lineWidth: 1))
            .shadow(color: .black.opacity(0.25), radius: 1, y: 1)
        }
        .buttonStyle(.plain)
    }
}
