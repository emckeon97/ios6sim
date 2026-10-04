import SwiftUI

/// iOS 6 home screen: wallpaper, icon grid, page dots.
struct HomeScreen: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var pressedApp: AppID?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

    var body: some View {
        ZStack {
            Wallpapers.view(index: sim.wallpaperIndex)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                iOS6StatusBar()
                    .padding(.top, 2)

                LazyVGrid(columns: columns, spacing: 22) {
                    ForEach(AppID.allCases) { app in
                        Button {
                            pressedApp = app
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                                pressedApp = nil
                                sim.open(app)
                            }
                        } label: {
                            VStack(spacing: 4) {
                                iOS6Icon(app: app, size: 60)
                                    .scaleEffect(pressedApp == app ? 0.85 : 1.0)
                                    .brightness(pressedApp == app ? 0.2 : 0)
                                Text(app.title)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.6), radius: 2, y: 1)
                            }
                        }
                        .buttonStyle(.plain)
                        .animation(.spring(response: 0.25), value: pressedApp == app)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 24)

                Spacer()

                // Page dots (single page).
                HStack(spacing: 8) {
                    Circle().fill(Color.white).frame(width: 7, height: 7)
                    Circle().fill(Color.white.opacity(0.4)).frame(width: 7, height: 7)
                }
                .padding(.bottom, 10)
            }
        }
    }
}
