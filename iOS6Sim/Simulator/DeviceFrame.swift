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
                            Button { sim.goHome() } label: {
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

/// Fullscreen iOS 6 experience — true black, iPhone 5 layout.
/// The simulated 320×568 screen fills the width; bottom black area
/// holds a visible circular home button, like the real iPhone.
struct FullscreenSimView: View {
    @EnvironmentObject var sim: SimulatorState

    var body: some View {
        GeometryReader { geo in
            let scale = geo.size.width / 320
            let contentHeight = 568 * scale
            // Top inset for Dynamic Island / notch area.
            let topInset: CGFloat = 28
            ZStack {
                // True black — blends into the OLED display.
                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top black bar.
                    Color.black
                        .frame(height: topInset)

                    // The simulated iOS 6 screen, scaled to fill width.
                    ScreenHost()
                        .frame(width: 320, height: 568)
                        .scaleEffect(scale, anchor: .top)
                        .frame(width: geo.size.width, height: contentHeight)

                    // Bottom black area with visible home button.
                    ZStack {
                        Color.black
                        Button { sim.goHome() } label: {
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
            case .notes: NotesApp()
            case .calculator: CalculatorApp()
            case .clock: ClockApp()
            case .weather: WeatherApp()
            case .settings: SettingsApp()
            case .photos: PhotosApp()
            case .messages: MessagesApp()
            case .reminders: RemindersApp()
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
