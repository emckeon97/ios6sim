import SwiftUI

// MARK: - Cydia package catalog

struct CydiaPackage: Identifiable {
    let id: String
    let name: String
    let version: String
    let section: String
    let description: String
    let color: Color
    /// What installing it actually does in the sim (nil = cosmetic).
    var effect: String? = nil
}

let cydiaPackages: [CydiaPackage] = [
    CydiaPackage(id: "winterboard", name: "WinterBoard", version: "0.9.3919",
                 section: "Themes",
                 description: "The classic theming engine. Install to reskin every icon on the Home screen with the built-in Ayecon-style dark theme.",
                 color: Color(red: 0.3, green: 0.5, blue: 0.8),
                 effect: "Themed icons"),
    CydiaPackage(id: "barrel", name: "Barrel", version: "1.7.4",
                 section: "Tweaks",
                 description: "3D page transitions for the Home screen. Flips pages with a cube spin instead of sliding.",
                 color: Color(red: 0.8, green: 0.4, blue: 0.2),
                 effect: "Cube page effect"),
    CydiaPackage(id: "sbsettings", name: "SBSettings", version: "6.0.5",
                 section: "Tweaks",
                 description: "Quick system toggles (Wi-Fi, Bluetooth, Do Not Disturb, brightness) right inside the multitasking tray.",
                 color: Color(red: 0.4, green: 0.6, blue: 0.3),
                 effect: "Switcher toggles"),
    CydiaPackage(id: "activator", name: "Activator", version: "1.8.1",
                 section: "Tweaks",
                 description: "Assign gestures to system actions. (Cosmetic in this sim.)",
                 color: Color(red: 0.6, green: 0.3, blue: 0.7)),
    CydiaPackage(id: "zephyr", name: "Zephyr", version: "1.6.0",
                 section: "Tweaks",
                 description: "Multitouch gestures for the Home button. (Cosmetic in this sim.)",
                 color: Color(red: 0.2, green: 0.6, blue: 0.7)),
    CydiaPackage(id: "bitesms", name: "biteSMS", version: "8.0.13",
                 section: "Messaging",
                 description: "Quick Reply and Quick Compose for Messages. (Cosmetic in this sim.)",
                 color: Color(red: 0.3, green: 0.7, blue: 0.4)),
]

// MARK: - evasi0n jailbreak tool

struct Evasi0nApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var stage: Stage = .idle
    @State private var progress: Double = 0
    @State private var bootLines: [String] = []
    @State private var status = ""

    enum Stage { case idle, running, reboot, verbose, done }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            switch stage {
            case .idle: idleView
            case .running: runningView
            case .reboot: rebootView
            case .verbose: verboseView
            case .done: doneView
            }
        }
    }

    private var idleView: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            Spacer()
            // evasi0n logo: gray circle with "e".
            ZStack {
                Circle().fill(Color(red: 0.25, green: 0.25, blue: 0.28))
                    .frame(width: 110, height: 110)
                Text("e").font(.system(size: 64, weight: .ultraLight)).foregroundColor(.white)
            }
            Text("evasi0n")
                .font(.system(size: 30, weight: .light))
                .padding(.top, 14)
            Text(sim.isJailbroken ? "This iPhone is jailbroken." : "iOS 6.0 – 6.1.2 untethered jailbreak")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.top, 6)
            Spacer()
            if sim.isJailbroken {
                Text("Cydia is installed. Tweak away.")
                    .font(.system(size: 14)).foregroundColor(.gray)
                    .padding(.bottom, 12)
                jailbreakButton("Remove Jailbreak (Restore)", color: .red) {
                    sim.unjailbreak()
                }
            } else {
                Text("Back up before jailbreaking.\nThis is a simulation — nothing real happens.")
                    .font(.system(size: 12)).foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)
                jailbreakButton("Jailbreak", color: Color(red: 0.3, green: 0.6, blue: 0.9)) {
                    startJailbreak()
                }
            }
            Spacer().frame(height: 60)
        }
    }

    private func jailbreakButton(_ title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 220, height: 48)
                .background(RoundedRectangle(cornerRadius: 10).fill(
                    LinearGradient(colors: [color, color.opacity(0.75)],
                                   startPoint: .top, endPoint: .bottom)))
                .shadow(color: .black.opacity(0.2), radius: 3, y: 2)
        }.buttonStyle(.plain)
    }

    private var runningView: some View {
        VStack(spacing: 16) {
            iOS6StatusBar(darkText: true)
            Spacer()
            Text("evasi0n").font(.system(size: 24, weight: .light))
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(.linear)
                .frame(width: 220)
            Text(status).font(.system(size: 14)).foregroundColor(.gray)
            Spacer()
        }
    }

    private var rebootView: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image(systemName: "applelogo")
                .font(.system(size: 90))
                .foregroundColor(.white)
        }
    }

    private var verboseView: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(bootLines.indices, id: \.self) { i in
                            Text(bootLines[i])
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(.white)
                                .id(i)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .onChange(of: bootLines.count) {
                        proxy.scrollTo(bootLines.count - 1, anchor: .bottom)
                    }
                }
            }
        }
    }

    private var doneView: some View {
        VStack(spacing: 14) {
            iOS6StatusBar(darkText: true)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.green)
            Text("Jailbreak complete!")
                .font(.system(size: 22, weight: .bold))
            Text("Cydia has been installed.\nOpen it from the Home screen to install tweaks.")
                .font(.system(size: 14)).foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Button("Done") {
                sim.isJailbroken = true
                stage = .idle
                sim.goHome()
            }
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(Color(red: 0.25, green: 0.45, blue: 0.9))
            .padding(.top, 8)
            .buttonStyle(.plain)
            Spacer()
        }
        .background(Color.white)
    }

    private func startJailbreak() {
        stage = .running
        progress = 0
        let steps: [(Double, String)] = [
            (0.15, "Connecting to device…"),
            (0.35, "Exploiting kernel…"),
            (0.55, "Patching AMFI…"),
            (0.75, "Injecting evasi0n…"),
            (0.92, "Installing Cydia…"),
            (1.0, "Rebooting…"),
        ]
        var delay = 0.0
        for (p, s) in steps {
            delay += 0.9
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation { progress = p; status = s }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.6) {
            stage = .reboot
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                stage = .verbose
                runVerboseBoot()
            }
        }
    }

    private func runVerboseBoot() {
        bootLines = []
        let lines = [
            "AppleUSBEthernet::start",
            "BSD root: md0, major 2, minor 0",
            "evasi0n: kernel exploit succeeded",
            "evasi0n: patching AMFI codesign checks… OK",
            "evasi0n: remounting / as read-write… OK",
            "evasi0n: installing Cydia bootstrap… OK",
            "evasi0n: untether payload installed",
            "launchd: starting SystemBoot",
            "SpringBoard: loaded WinterBoard dylib hook",
            "Cydia: installation complete",
            "Done. Enjoy your jailbreak.",
        ]
        for (i, line) in lines.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.35) {
                bootLines.append(line)
                if i == lines.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        stage = .done
                    }
                }
            }
        }
    }
}

// MARK: - Cydia

struct CydiaApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var tab = 0
    @State private var searchText = ""
    @State private var installing: CydiaPackage? = nil
    @State private var showingBuilder = false
    @State private var installProgress: Double = 0
    @State private var respringing = false
    @State private var detail: CydiaPackage? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                iOS6StatusBar(darkText: false)
                cydiaNavBar
                Group {
                    switch tab {
                    case 0: homeTab
                    case 1: sectionsTab
                    case 2: changesTab
                    case 3: manageTab
                    default: searchTab
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                cydiaTabBar
            }
            .background(Color(red: 0.93, green: 0.90, blue: 0.85))
            if let pkg = installing { installSheet(pkg) }
            if respringing {
                ZStack {
                    Color.black.ignoresSafeArea()
                    VStack(spacing: 14) {
                        ProgressView().progressViewStyle(.circular).tint(.white).scaleEffect(1.4)
                        Text("Respringing…").foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ios6sim.respring"))) { _ in
            doRespring()
        }
    }

    private var cydiaNavBar: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.25, green: 0.18, blue: 0.12),
                                    Color(red: 0.12, green: 0.08, blue: 0.05)],
                           startPoint: .top, endPoint: .bottom)
            HStack {
                Text(["Cydia", "Sections", "Changes", "Manage", "Search"][tab])
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.95, green: 0.88, blue: 0.75))
                Spacer()
                if tab == 3 {
                    Button { showingBuilder = true } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.95, green: 0.85, blue: 0.65))
                    }.buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 44)
        .sheet(isPresented: $showingBuilder) { TweakBuilderView() }
    }

    private var cydiaTabBar: some View {
        HStack(spacing: 0) {
            ForEach([("house.fill", "Cydia"), ("square.grid.2x2.fill", "Sections"),
                     ("arrow.down.circle.fill", "Changes"), ("wrench.fill", "Manage"),
                     ("magnifyingglass", "Search")].indices, id: \.self) { i in
                let t = [("house.fill", "Cydia"), ("square.grid.2x2.fill", "Sections"),
                         ("arrow.down.circle.fill", "Changes"), ("wrench.fill", "Manage"),
                         ("magnifyingglass", "Search")][i]
                Button { tab = i } label: {
                    VStack(spacing: 2) {
                        Image(systemName: t.0).font(.system(size: 19))
                        Text(t.1).font(.system(size: 10))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 7)
                    .foregroundColor(tab == i ? Color(red: 0.95, green: 0.85, blue: 0.65)
                                              : Color(white: 0.55))
                }.buttonStyle(.plain)
            }
        }
        .background(LinearGradient(colors: [Color(red: 0.22, green: 0.16, blue: 0.10),
                                            Color(red: 0.10, green: 0.07, blue: 0.04)],
                                   startPoint: .top, endPoint: .bottom))
    }

    // MARK: Tabs
    private var homeTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Welcome to Cydia™")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                    .padding(.top, 12)
                Text("by Jay Freeman (saurik)")
                    .font(.system(size: 13)).foregroundColor(.gray)
                Text("Featured Tweaks")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                    .padding(.top, 8)
                ForEach(cydiaPackages.prefix(3)) { pkg in
                    packageRow(pkg)
                }
                Text("Your device is jailbroken with evasi0n.\nTweaks marked as cosmetic install without system effects in this sim.")
                    .font(.system(size: 12)).foregroundColor(.gray)
                    .padding(.top, 8)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 20)
        }
    }

    private var sectionsTab: some View {
        List {
            ForEach(["Themes", "Tweaks", "Messaging"], id: \.self) { section in
                Section(section) {
                    ForEach(cydiaPackages.filter { $0.section == section }) { pkg in
                        Button { detail = pkg } label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 6).fill(pkg.color)
                                    .frame(width: 34, height: 34)
                                    .overlay(Text(String(pkg.name.prefix(1)))
                                        .font(.system(size: 16, weight: .bold)).foregroundColor(.white))
                                VStack(alignment: .leading) {
                                    Text(pkg.name).font(.system(size: 15, weight: .bold)).foregroundColor(.black)
                                    Text(pkg.version).font(.system(size: 12)).foregroundColor(.gray)
                                }
                                Spacer()
                                if sim.installedTweaks.contains(pkg.id) {
                                    Text("Installed").font(.system(size: 12)).foregroundColor(.green)
                                }
                            }
                        }.buttonStyle(.plain)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .sheet(item: $detail) { pkg in packageDetail(pkg) }
    }

    private var changesTab: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(cydiaPackages) { pkg in packageRow(pkg) }
            }
            .padding(.vertical, 8)
        }
    }

    private var manageTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Installed Packages")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                    .padding(12)
                if sim.installedTweaks.isEmpty {
                    Text("No tweaks installed yet.\nHead to Changes to install some.")
                        .font(.system(size: 14)).foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 30)
                } else {
                    ForEach(cydiaPackages.filter { sim.installedTweaks.contains($0.id) }) { pkg in
                        HStack {
                            Text(pkg.name).font(.system(size: 15, weight: .bold))
                            Spacer()
                            Button("Remove") {
                                sim.removeTweak(pkg.id)
                                doRespring()
                            }
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.red)
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 12).padding(.vertical, 10)
                        .background(Color.white)
                        Divider()
                    }
                }
                if !sim.customTweaks.isEmpty {
                    Text("My Tweaks")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                        .padding(12)
                    ForEach(sim.customTweaks) { tweak in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(tweak.name).font(.system(size: 15, weight: .bold))
                                Text(tweakKindName(tweak.kind))
                                    .font(.system(size: 12)).foregroundColor(.gray)
                            }
                            Spacer()
                            Button("Remove") {
                                sim.removeCustomTweak(tweak)
                                doRespring()
                            }
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.red)
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 12).padding(.vertical, 10)
                        .background(Color.white)
                        Divider()
                    }
                }
                Button("Build a Tweak") { showingBuilder = true }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 0.25, green: 0.45, blue: 0.9))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)
                    .buttonStyle(.plain)
                Button("Remove Jailbreak (Restore)") { sim.unjailbreak() }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                    .buttonStyle(.plain)
            }
        }
    }

    private var searchTab: some View {
        VStack(spacing: 0) {
            TextField("Search", text: $searchText)
                .font(.system(size: 15))
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                .padding(10)
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(cydiaPackages.filter {
                        searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
                    }) { pkg in packageRow(pkg) }
                }
            }
        }
    }

    // MARK: Package rows / detail / install
    private func packageRow(_ pkg: CydiaPackage) -> some View {
        Button { detail = pkg } label: {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 6).fill(pkg.color)
                    .frame(width: 38, height: 38)
                    .overlay(Text(String(pkg.name.prefix(1)))
                        .font(.system(size: 18, weight: .bold)).foregroundColor(.white))
                VStack(alignment: .leading, spacing: 2) {
                    Text(pkg.name).font(.system(size: 15, weight: .bold)).foregroundColor(.black)
                    Text(pkg.section).font(.system(size: 12)).foregroundColor(.gray)
                }
                Spacer()
                if sim.installedTweaks.contains(pkg.id) {
                    Text("Installed").font(.system(size: 12, weight: .bold)).foregroundColor(.green)
                } else {
                    Text("Install")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 0.35, green: 0.55, blue: 0.85)))
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(Color.white)
        }
        .buttonStyle(.plain)
        .sheet(item: $detail) { pkg in packageDetail(pkg) }
    }

    private func packageDetail(_ pkg: CydiaPackage) -> some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: false)
            ZStack {
                LinearGradient(colors: [Color(red: 0.25, green: 0.18, blue: 0.12),
                                        Color(red: 0.12, green: 0.08, blue: 0.05)],
                               startPoint: .top, endPoint: .bottom)
                HStack {
                    Button("Close") { detail = nil }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0.95, green: 0.85, blue: 0.65))
                        .buttonStyle(.plain)
                    Spacer()
                    Text(pkg.name).font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(red: 0.95, green: 0.88, blue: 0.75))
                    Spacer()
                    Color.clear.frame(width: 44)
                }
                .padding(.horizontal, 10)
            }
            .frame(height: 44)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 10).fill(pkg.color)
                            .frame(width: 60, height: 60)
                            .overlay(Text(String(pkg.name.prefix(1)))
                                .font(.system(size: 28, weight: .bold)).foregroundColor(.white))
                        VStack(alignment: .leading) {
                            Text(pkg.name).font(.system(size: 18, weight: .bold))
                            Text("Version \(pkg.version)").font(.system(size: 13)).foregroundColor(.gray)
                            Text(pkg.section).font(.system(size: 13)).foregroundColor(.gray)
                        }
                    }
                    Text(pkg.description).font(.system(size: 14)).lineSpacing(3)
                    if let effect = pkg.effect {
                        HStack {
                            Image(systemName: "sparkles").foregroundColor(.orange)
                            Text("System effect: \(effect)")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.orange.opacity(0.15)))
                    }
                    Spacer().frame(height: 20)
                    Button {
                        detail = nil
                        installing = pkg
                        installProgress = 0
                    } label: {
                        Text(sim.installedTweaks.contains(pkg.id) ? "Reinstall" : "Install")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 46)
                            .background(RoundedRectangle(cornerRadius: 10).fill(
                                LinearGradient(colors: [Color(red: 0.35, green: 0.55, blue: 0.9),
                                                        Color(red: 0.22, green: 0.4, blue: 0.72)],
                                               startPoint: .top, endPoint: .bottom)))
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 30)
                }
                .padding(14)
            }
            .background(Color(red: 0.93, green: 0.90, blue: 0.85))
        }
    }

    private func installSheet(_ pkg: CydiaPackage) -> some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 14) {
                Text("Installing \(pkg.name)")
                    .font(.system(size: 17, weight: .bold))
                ProgressView(value: installProgress, total: 1.0)
                    .progressViewStyle(.linear)
                    .frame(width: 220)
                Text(installStatus)
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(.gray)
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
            .padding(.horizontal, 40)
        }
        .onAppear { runInstall(pkg) }
    }

    @State private var installStatus = ""

    private func runInstall(_ pkg: CydiaPackage) {
        let steps: [(Double, String)] = [
            (0.2, "Downloading \(pkg.id)_\(pkg.version)_iphoneos-arm.deb"),
            (0.5, "Unpacking…"),
            (0.75, "Configuring…"),
            (1.0, "Done."),
        ]
        for (i, (p, s)) in steps.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i + 1) * 0.7) {
                installProgress = p
                installStatus = s
                if i == steps.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        sim.installTweak(pkg.id)
                        installing = nil
                        doRespring()
                    }
                }
            }
        }
    }

    private func doRespring() {
        respringing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            respringing = false
            sim.goHome()
        }
    }

    private func tweakKindName(_ kind: String) -> String {
        switch kind {
        case "carrier": return "Fake Carrier"
        case "tint": return "Icon Tint"
        case "hidelabels": return "Hide Icon Labels"
        case "pageeffect": return "Page Effect"
        default: return kind
        }
    }
}

// MARK: - Tweak Builder (build your own tweaks)

struct TweakBuilderView: View {
    @EnvironmentObject var sim: SimulatorState
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var kind = "carrier"
    @State private var carrierText = ""
    @State private var tintHex = "0A84FF"
    @State private var effect = "cube"

    private let kinds = [("carrier", "Fake Carrier", "Custom text in the status bar (MakeItMine-style)"),
                         ("tint", "Icon Tint", "Tint every Home screen icon a color"),
                         ("hidelabels", "Hide Icon Labels", "Remove app names under icons"),
                         ("pageeffect", "Page Effect", "Animate Home screen page flips")]
    private let tints = [("Blue", "0A84FF"), ("Red", "FF3B30"), ("Green", "34C759"),
                         ("Orange", "FF9500"), ("Purple", "AF52DE"), ("Pink", "FF2D55")]
    private let effects = ["cube", "flip", "fade"]

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: false)
            ZStack {
                LinearGradient(colors: [Color(red: 0.25, green: 0.18, blue: 0.12),
                                        Color(red: 0.12, green: 0.08, blue: 0.05)],
                               startPoint: .top, endPoint: .bottom)
                HStack {
                    Button("Cancel") { dismiss() }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0.95, green: 0.85, blue: 0.65))
                        .buttonStyle(.plain)
                    Spacer()
                    Text("Build a Tweak")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(red: 0.95, green: 0.88, blue: 0.75))
                    Spacer()
                    Color.clear.frame(width: 52)
                }
                .padding(.horizontal, 10)
            }
            .frame(height: 44)
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Name your tweak")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                    TextField("e.g. MyCarrier", text: $name)
                        .font(.system(size: 15))
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                    Text("What should it do?")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                    ForEach(kinds, id: \.0) { k in
                        Button { kind = k.0 } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(k.1).font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.black)
                                    Text(k.2).font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                if kind == k.0 {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(red: 0.35, green: 0.55, blue: 0.85))
                                }
                            }
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                        }.buttonStyle(.plain)
                    }
                    // Value input per kind.
                    if kind == "carrier" {
                        Text("Carrier text")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                        TextField("e.g. JARVIS", text: $carrierText)
                            .font(.system(size: 15))
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                    } else if kind == "tint" {
                        Text("Tint color")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                        HStack(spacing: 12) {
                            ForEach(tints, id: \.1) { t in
                                Button { tintHex = t.1 } label: {
                                    Circle()
                                        .fill(Color(hex: t.1) ?? .blue)
                                        .frame(width: 34, height: 34)
                                        .overlay(Circle().stroke(Color.white, lineWidth: tintHex == t.1 ? 3 : 0))
                                        .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
                                }.buttonStyle(.plain)
                            }
                        }
                    } else if kind == "pageeffect" {
                        Text("Effect style")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                        HStack(spacing: 10) {
                            ForEach(effects, id: \.self) { e in
                                Button { effect = e } label: {
                                    Text(e.capitalized)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(effect == e ? .white : .black)
                                        .padding(.horizontal, 16).padding(.vertical, 8)
                                        .background(RoundedRectangle(cornerRadius: 8)
                                            .fill(effect == e ? Color(red: 0.35, green: 0.55, blue: 0.85)
                                                              : Color.white))
                                }.buttonStyle(.plain)
                            }
                        }
                    }
                    Button {
                        build()
                    } label: {
                        Text("Build & Install")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 46)
                            .background(RoundedRectangle(cornerRadius: 10).fill(
                                LinearGradient(colors: [Color(red: 0.35, green: 0.55, blue: 0.9),
                                                        Color(red: 0.22, green: 0.4, blue: 0.72)],
                                               startPoint: .top, endPoint: .bottom)))
                            .opacity(canBuild ? 1 : 0.4)
                    }
                    .buttonStyle(.plain)
                    .disabled(!canBuild)
                    .padding(.top, 6)
                    .padding(.bottom, 30)
                }
                .padding(14)
            }
            .background(Color(red: 0.93, green: 0.90, blue: 0.85))
        }
    }

    private var canBuild: Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        if kind == "carrier" { return !carrierText.trimmingCharacters(in: .whitespaces).isEmpty }
        return true
    }

    private func build() {
        let value: String
        switch kind {
        case "carrier": value = carrierText.trimmingCharacters(in: .whitespaces)
        case "tint": value = tintHex
        case "pageeffect": value = effect
        default: value = ""
        }
        sim.addCustomTweak(name: name.trimmingCharacters(in: .whitespaces), kind: kind, value: value)
        dismiss()
        // Respring to apply — Cydia handles it via the sheet dismissal.
        NotificationCenter.default.post(name: Notification.Name("ios6sim.respring"), object: nil)
    }
}
