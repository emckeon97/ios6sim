import SwiftUI

/// iOS 6 home screen: Spotlight, paged icon grids, glass dock, multitasking tray.
struct HomeScreen: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var page = 1
    @State private var pressedApp: AppID? = nil
    @State private var searchText = ""
    @State private var cube: Double = 0
    @State private var flip: Double = 0
    @State private var pageFade: Double = 1
    @State private var editMode = false

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

    private var page2: [AppID] { AppID.page2Apps(jailbroken: sim.isJailbroken) }

    var body: some View {
        ZStack {
            Wallpapers.view(index: sim.wallpaperIndex)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                iOS6StatusBar()
                    .padding(.top, 2)

                TabView(selection: $page) {
                    spotlightPage.tag(0)
                    iconPage(AppID.page1Apps).tag(1)
                    iconPage(page2).tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .rotation3DEffect(.degrees(cube), axis: (x: 0, y: 1, z: 0), perspective: 0.6)
                .rotation3DEffect(.degrees(flip), axis: (x: 1, y: 0, z: 0), perspective: 0.6)
                .opacity(pageFade)
                .onChange(of: page) {
                    guard let effect = sim.pageEffectName else { return }
                    switch effect {
                    case "cube":
                        withAnimation(.easeInOut(duration: 0.16)) { cube = 48 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
                            withAnimation(.easeInOut(duration: 0.16)) { cube = 0 }
                        }
                    case "flip":
                        withAnimation(.easeInOut(duration: 0.16)) { flip = 70 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
                            withAnimation(.easeInOut(duration: 0.16)) { flip = 0 }
                        }
                    case "fade":
                        withAnimation(.easeInOut(duration: 0.14)) { pageFade = 0.15 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
                            withAnimation(.easeInOut(duration: 0.14)) { pageFade = 1 }
                        }
                    default: break
                    }
                }

                // Page dots: magnifier + 2 dots, like iOS 6.
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(page == 0 ? .white : .white.opacity(0.4))
                    Circle().fill(page == 1 ? Color.white : Color.white.opacity(0.4))
                        .frame(width: 7, height: 7)
                    Circle().fill(page == 2 ? Color.white : Color.white.opacity(0.4))
                        .frame(width: 7, height: 7)
                }
                .padding(.bottom, 8)

                // Glass dock.
                HStack(spacing: 0) {
                    ForEach(AppID.dockApps) { app in
                        Button { tapApp(app) } label: {
                            iOS6Icon(app: app, size: 56, themed: sim.winterboardOn, tint: sim.iconTint)
                                .scaleEffect(pressedApp == app ? 0.88 : 1.0)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(colors: [Color.white.opacity(0.45),
                                                      Color.white.opacity(0.18)],
                                             startPoint: .top, endPoint: .bottom))
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1))
                )
                .padding(.horizontal, 8)
                .padding(.bottom, 10)
            }

            // Multitasking switcher tray (double-click home).
            if sim.showingSwitcher {
                switcherTray
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: sim.showingSwitcher)
    }

    // MARK: - Icon pages

    private func iconPage(_ apps: [AppID]) -> some View {
        LazyVGrid(columns: columns, spacing: 22) {
            ForEach(apps) { app in
                Button { tapApp(app) } label: {
                    VStack(spacing: 4) {
                        iOS6Icon(app: app, size: 60, themed: sim.winterboardOn, tint: sim.iconTint)
                            .scaleEffect(pressedApp == app ? 0.85 : 1.0)
                            .brightness(pressedApp == app ? 0.2 : 0)
                        if !sim.hideIconLabels {
                            Text(app.title)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.6), radius: 2, y: 1)
                        }
                    }
                }
                .buttonStyle(.plain)
                .animation(.spring(response: 0.25), value: pressedApp == app)
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 24)
    }

    private func tapApp(_ app: AppID) {
        pressedApp = app
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            pressedApp = nil
            sim.open(app)
        }
    }

    // MARK: - Spotlight

    private var spotlightPage: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Spotlight Search", text: $searchText)
                    .font(.system(size: 15))
            }
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.92)))
            .padding(.horizontal, 14)
            .padding(.top, 20)
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(spotlightResults) { app in
                        Button { tapApp(app) } label: {
                            HStack(spacing: 10) {
                                iOS6Icon(app: app, size: 36, themed: sim.winterboardOn, tint: sim.iconTint)
                                Text(app.title)
                                    .font(.system(size: 15))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 12).padding(.vertical, 6)
                        }.buttonStyle(.plain)
                        Divider().padding(.leading, 60)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                .padding(.horizontal, 14)
                .padding(.top, 10)
            }
            Spacer()
        }
    }

    private var spotlightResults: [AppID] {
        let all = AppID.dockApps + AppID.page1Apps + page2
        guard !searchText.isEmpty else { return all }
        return all.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    // MARK: - Multitasking switcher

    private var switcherTray: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                // SBSettings quick toggles (jailbreak tweak).
                if sim.sbsettingsOn { sbSettingsRow }
                // Recent apps.
                if sim.recentApps.isEmpty {
                    Text("No recent apps")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .padding(.vertical, 26)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 18) {
                            ForEach(sim.recentApps) { app in
                                switcherIcon(app)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                    }
                }
            }
            .background(
                LinearGradient(colors: [Color(red: 0.25, green: 0.26, blue: 0.30),
                                        Color(red: 0.10, green: 0.10, blue: 0.12)],
                               startPoint: .top, endPoint: .bottom)
                    .overlay(Rectangle().fill(Color.black.opacity(0.5)).frame(height: 1),
                             alignment: .top)
            )
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .onEnded { _ in editMode = true }
            )
            .simultaneousGesture(
                TapGesture().onEnded {
                    if editMode { editMode = false }
                }
            )
        }
        .background(Color.black.opacity(0.001)) // catch taps above tray
        .onTapGesture { sim.toggleSwitcher() }
    }

    private func switcherIcon(_ app: AppID) -> some View {
        ZStack(alignment: .topLeading) {
            Button { sim.open(app) } label: {
                VStack(spacing: 4) {
                    iOS6Icon(app: app, size: 52, themed: sim.winterboardOn, tint: sim.iconTint)
                        .rotationEffect(.degrees(editMode ? 2 : 0))
                    Text(app.title)
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { v in
                        if v.translation.height < -20 { sim.closeApp(app) }
                    }
            )
            if editMode {
                Button { sim.closeApp(app) } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .background(Circle().fill(.white))
                }
                .buttonStyle(.plain)
                .offset(x: -8, y: -8)
            }
        }
        .animation(editMode ? .easeInOut(duration: 0.12).repeatForever(autoreverses: true) : .default,
                   value: editMode)
    }

    // MARK: - SBSettings row

    @AppStorage("ios6sim.wifi") private var sbWifi = true
    @AppStorage("ios6sim.bluetooth") private var sbBluetooth = false
    @AppStorage("ios6sim.dnd") private var sbDnd = false
    @AppStorage("ios6sim.brightness") private var sbBrightness = 0.7

    private var sbSettingsRow: some View {
        VStack(spacing: 6) {
            HStack(spacing: 22) {
                sbToggle(icon: "wifi", isOn: $sbWifi)
                sbToggle(icon: "bluetooth", isOn: $sbBluetooth)
                sbToggle(icon: "moon.fill", isOn: $sbDnd)
                Button { doSBRespring() } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18))
                            .foregroundColor(.orange)
                            .frame(width: 40, height: 40)
                            .background(Circle().fill(Color.white.opacity(0.12)))
                        Text("Respring").font(.system(size: 9)).foregroundColor(.gray)
                    }
                }.buttonStyle(.plain)
            }
            HStack {
                Image(systemName: "sun.min.fill").font(.system(size: 11)).foregroundColor(.gray)
                Slider(value: $sbBrightness).tint(.orange)
                Image(systemName: "sun.max.fill").font(.system(size: 11)).foregroundColor(.gray)
            }
            .padding(.horizontal, 30)
        }
        .padding(.vertical, 10)
        .overlay(Rectangle().fill(Color.white.opacity(0.12)).frame(height: 1), alignment: .bottom)
    }

    private func sbToggle(icon: String, isOn: Binding<Bool>) -> some View {
        Button { isOn.wrappedValue.toggle() } label: {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isOn.wrappedValue ? .green : .gray)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(Color.white.opacity(0.12)))
                Text(isOn.wrappedValue ? "On" : "Off")
                    .font(.system(size: 9)).foregroundColor(.gray)
            }
        }.buttonStyle(.plain)
    }

    @State private var sbRespringing = false

    private func doSBRespring() {
        // Quick respring flash.
        sim.goHome()
    }
}
