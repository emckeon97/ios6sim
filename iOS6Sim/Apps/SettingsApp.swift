import SwiftUI

/// Full iOS 6 Settings: every toggle, every sub-page. Toggles persist via @AppStorage.
struct SettingsApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var path: [SettingsPage] = []

    enum SettingsPage: Hashable {
        case wifi, bluetooth, notifications, general, about, softwareUpdate,
             sounds, brightness, wallpaper, privacy, icloud, safari
    }

    // Persisted toggles.
    @AppStorage("ios6sim.airplane") private var airplane = false
    @AppStorage("ios6sim.wifi") private var wifiOn = true
    @AppStorage("ios6sim.bluetooth") private var bluetoothOn = false
    @AppStorage("ios6sim.dnd") private var dnd = false
    @AppStorage("ios6sim.cellular") private var cellular = true
    @AppStorage("ios6sim.brightness") private var brightness = 0.7
    @AppStorage("ios6sim.autobright") private var autoBrightness = true
    @AppStorage("ios6sim.vibrateRing") private var vibrateRing = true
    @AppStorage("ios6sim.vibrateSilent") private var vibrateSilent = true
    @AppStorage("ios6sim.ringVolume") private var ringVolume = 0.8
    @AppStorage("ios6sim.siri") private var siri = true
    @AppStorage("ios6sim.locationServices") private var locationServices = true

    var body: some View {
        ZStack {
            if let page = path.last {
                subPage(page)
                    .transition(.move(edge: .trailing))
            } else {
                mainPage.transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.22), value: path)
    }

    // MARK: - Main page
    private var mainPage: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            iOS6NavBar(title: "Settings")
            ScrollView {
                VStack(spacing: 0) {
                    iOS6Section {
                        toggleRow(icon: "airplane", iconColor: .orange, title: "Airplane Mode", isOn: $airplane)
                        divider
                        navRow(icon: "wifi", iconColor: Color(red: 0.25, green: 0.45, blue: 0.9),
                               title: "Wi-Fi", value: wifiOn ? "HomeNet" : "Off") { path.append(.wifi) }
                        divider
                        navRow(icon: "bluetooth", iconColor: Color(red: 0.25, green: 0.45, blue: 0.9),
                               title: "Bluetooth", value: bluetoothOn ? "On" : "Off") { path.append(.bluetooth) }
                        divider
                        toggleRow(icon: "moon.fill", iconColor: Color(red: 0.45, green: 0.4, blue: 0.8),
                                  title: "Do Not Disturb", isOn: $dnd)
                    }
                    iOS6SectionHeader(title: "")
                    iOS6Section {
                        navRow(icon: "bell.badge.fill", iconColor: .red, title: "Notifications") { path.append(.notifications) }
                        divider
                        navRow(icon: "gearshape.fill", iconColor: .gray, title: "General") { path.append(.general) }
                        divider
                        navRow(icon: "speaker.wave.2.fill", iconColor: Color(red: 0.95, green: 0.5, blue: 0.6),
                               title: "Sounds") { path.append(.sounds) }
                        divider
                        navRow(icon: "sun.max.fill", iconColor: Color(red: 0.25, green: 0.45, blue: 0.9),
                               title: "Brightness & Wallpaper") { path.append(.brightness) }
                    }
                    iOS6SectionHeader(title: "")
                    iOS6Section {
                        navRow(icon: "hand.raised.fill", iconColor: .gray, title: "Privacy") { path.append(.privacy) }
                        divider
                        navRow(icon: "cloud.fill", iconColor: Color(red: 0.4, green: 0.6, blue: 0.9),
                               title: "iCloud", value: "emckeon97") { path.append(.icloud) }
                        divider
                        navRow(icon: "envelope.fill", iconColor: Color(red: 0.25, green: 0.45, blue: 0.9),
                               title: "Mail, Contacts, Calendars") {}
                        divider
                        navRow(icon: "note.text", iconColor: Color(red: 0.95, green: 0.75, blue: 0.3),
                               title: "Notes") {}
                        divider
                        navRow(icon: "checklist", iconColor: Color(red: 0.95, green: 0.6, blue: 0.2),
                               title: "Reminders") {}
                    }
                    iOS6SectionHeader(title: "")
                    iOS6Section {
                        navRow(icon: "phone.fill", iconColor: .green, title: "Phone") {}
                        divider
                        navRow(icon: "message.fill", iconColor: .green, title: "Messages") {}
                        divider
                        navRow(icon: "video.fill", iconColor: Color(red: 0.25, green: 0.45, blue: 0.9),
                               title: "FaceTime") {}
                        divider
                        navRow(icon: "map.fill", iconColor: Color(red: 0.6, green: 0.75, blue: 0.4),
                               title: "Maps") {}
                        divider
                        navRow(icon: "safari.fill", iconColor: Color(red: 0.25, green: 0.45, blue: 0.9),
                               title: "Safari") { path.append(.safari) }
                    }
                    iOS6SectionHeader(title: "")
                    iOS6Section {
                        navRow(icon: "music.note", iconColor: Color(red: 0.6, green: 0.35, blue: 0.8),
                               title: "iTunes & App Stores") {}
                        divider
                        navRow(icon: "music.note.list", iconColor: Color(red: 0.95, green: 0.45, blue: 0.25),
                               title: "Music") {}
                        divider
                        navRow(icon: "tv.fill", iconColor: .gray, title: "Videos") {}
                        divider
                        navRow(icon: "photo.fill", iconColor: Color(red: 0.6, green: 0.7, blue: 0.4),
                               title: "Photos & Camera") {}
                        divider
                        navRow(icon: "gamecontroller.fill", iconColor: Color(red: 0.45, green: 0.55, blue: 0.65),
                               title: "Game Center") {}
                    }
                    iOS6SectionHeader(title: "")
                    iOS6Section {
                        navRow(icon: "at", iconColor: Color(red: 0.3, green: 0.65, blue: 0.95),
                               title: "Twitter") {}
                        divider
                        navRow(icon: "f.circle.fill", iconColor: Color(red: 0.25, green: 0.4, blue: 0.8),
                               title: "Facebook") {}
                    }
                    Spacer().frame(height: 30)
                }
                .padding(.top, 10)
            }
            .background(brushedAluminum)
        }
    }

    // MARK: - Sub-pages
    @ViewBuilder
    private func subPage(_ page: SettingsPage) -> some View {
        switch page {
        case .wifi: wifiPage
        case .bluetooth: bluetoothPage
        case .notifications: notificationsPage
        case .general: generalPage
        case .about: aboutPage
        case .softwareUpdate: softwareUpdatePage
        case .sounds: soundsPage
        case .brightness: brightnessPage
        case .wallpaper: wallpaperPage
        case .privacy: privacyPage
        case .icloud: icloudPage
        case .safari: safariPage
        }
    }

    private func pageShell(title: String, back: String = "Settings", @ViewBuilder content: () -> some View) -> some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            iOS6NavBar(title: title,
                left: AnyView(iOS6BackButton(label: back) { _ = path.popLast() }))
            ScrollView {
                VStack(spacing: 0) { content() }
                    .padding(.top, 10)
                    .padding(.bottom, 30)
            }
            .background(brushedAluminum)
        }
    }

    private var wifiPage: some View {
        pageShell(title: "Wi-Fi") {
            iOS6Section {
                toggleRow(icon: "wifi", iconColor: Color(red: 0.25, green: 0.45, blue: 0.9),
                          title: "Wi-Fi", isOn: $wifiOn)
            }
            if wifiOn {
                iOS6SectionHeader(title: "Choose a Network…")
                iOS6Section {
                    ForEach(wifiNetworks, id: \.0) { net in
                        HStack {
                            Text(net.0).font(.system(size: 15))
                            Spacer()
                            if net.2 { Image(systemName: "lock.fill").font(.system(size: 12)).foregroundColor(.gray) }
                            wifiBars(net.1)
                            if net.0 == "HomeNet" {
                                Image(systemName: "checkmark").font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(red: 0.25, green: 0.45, blue: 0.9))
                            }
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(Color.white)
                    }
                }
                iOS6Section {
                    navRowPlain(title: "Ask to Join Networks", value: "Notify") {}
                    divider
                    navRowPlain(title: "Auto-Join", value: "On") {}
                }
            } else {
                Text("Wi-Fi is off. Turn it on to see available networks.")
                    .font(.system(size: 14)).foregroundColor(.gray)
                    .multilineTextAlignment(.center).padding(30)
            }
        }
    }

    private var wifiNetworks: [(String, Int, Bool)] {
        [("HomeNet", 3, true), ("HomeNet_5G", 3, true), ("xfinitywifi", 2, false),
         ("Neighbor's WiFi", 1, true), ("CoffeeShop", 2, false)]
    }

    private func wifiBars(_ strength: Int) -> some View {
        HStack(spacing: 1.5) {
            ForEach(0..<3, id: \.self) { i in
                RoundedRectangle(cornerRadius: 1)
                    .fill(i < strength ? Color.black : Color.black.opacity(0.2))
                    .frame(width: 3, height: CGFloat(5 + i * 3))
            }
        }
    }

    private var bluetoothPage: some View {
        pageShell(title: "Bluetooth") {
            iOS6Section {
                toggleRow(icon: "bluetooth", iconColor: Color(red: 0.25, green: 0.45, blue: 0.9),
                          title: "Bluetooth", isOn: $bluetoothOn)
            }
            if bluetoothOn {
                iOS6SectionHeader(title: "Devices")
                iOS6Section {
                    HStack {
                        Text("AirPods").font(.system(size: 15))
                        Spacer()
                        Text("Not Connected").font(.system(size: 13)).foregroundColor(.gray)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(Color.white)
                }
                Text("Now discoverable as \"iPhone\".")
                    .font(.system(size: 12)).foregroundColor(.gray).padding(.top, 8)
            }
        }
    }

    private var notificationsPage: some View {
        pageShell(title: "Notifications") {
            iOS6SectionHeader(title: "In Notification Center")
            iOS6Section {
                ForEach(["Phone", "Messages", "Mail", "Calendar", "Reminders"], id: \.self) { app in
                    HStack {
                        Text(app).font(.system(size: 15))
                        Spacer()
                        Text("Banners").font(.system(size: 13)).foregroundColor(.gray)
                        Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(.gray)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(Color.white)
                }
            }
            iOS6SectionHeader(title: "Not In Notification Center")
            iOS6Section {
                ForEach(["Photos", "Camera", "Stocks", "YouTube"], id: \.self) { app in
                    HStack {
                        Text(app).font(.system(size: 15))
                        Spacer()
                        Text("Off").font(.system(size: 13)).foregroundColor(.gray)
                        Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(.gray)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(Color.white)
                }
            }
        }
    }

    private var generalPage: some View {
        pageShell(title: "General") {
            iOS6Section {
                navRowPlain(title: "About") { path.append(.about) }
                divider
                navRowPlain(title: "Software Update") { path.append(.softwareUpdate) }
                divider
                toggleRowPlain(title: "Siri", isOn: $siri)
                divider
                toggleRowPlain(title: "Cellular Data", isOn: $cellular)
            }
            iOS6Section {
                navRowPlain(title: "Spotlight Search") {}
                divider
                navRowPlain(title: "Accessibility") {}
                divider
                navRowPlain(title: "Date & Time") {}
                divider
                navRowPlain(title: "Keyboard") {}
                divider
                navRowPlain(title: "Reset") {}
            }
        }
    }

    private var aboutPage: some View {
        pageShell(title: "About", back: "General") {
            iOS6Section {
                aboutRow("Name", "iPhone")
                divider; aboutRow("Network", "AT&T")
                divider; aboutRow("Songs", "\(demoSongs.count)")
                divider; aboutRow("Videos", "12")
                divider; aboutRow("Photos", "248")
                divider; aboutRow("Applications", "25")
                divider; aboutRow("Capacity", "13.5 GB")
                divider; aboutRow("Available", "9.1 GB")
                divider; aboutRow("Software", "6.1.4")
                divider; aboutRow("Model", "iPhone5,2")
                divider; aboutRow("Serial", "F2LX91ABFFG8")
            }
        }
    }

    private var softwareUpdatePage: some View {
        pageShell(title: "Software Update", back: "General") {
            VStack(spacing: 12) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 60)).foregroundColor(.gray).padding(.top, 40)
                Text("iOS 6.1.4")
                    .font(.system(size: 20, weight: .bold))
                Text("Your software is up to date.")
                    .font(.system(size: 15)).foregroundColor(.gray)
                    .multilineTextAlignment(.center).padding(.horizontal, 30)
            }
        }
    }

    private var soundsPage: some View {
        pageShell(title: "Sounds") {
            iOS6Section {
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "speaker.fill").foregroundColor(.gray)
                        Slider(value: $ringVolume).tint(Color(red: 0.25, green: 0.45, blue: 0.85))
                        Image(systemName: "speaker.wave.3.fill").foregroundColor(.gray)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(Color.white)
                }
            }
            iOS6SectionHeader(title: "Vibrate")
            iOS6Section {
                toggleRowPlain(title: "Vibrate on Ring", isOn: $vibrateRing)
                divider
                toggleRowPlain(title: "Vibrate on Silent", isOn: $vibrateSilent)
            }
            iOS6SectionHeader(title: "Sounds and Vibration Patterns")
            iOS6Section {
                ForEach([("Ringtone", "Marimba"), ("Text Tone", "Tri-tone"),
                         ("New Voicemail", "Voicemail"), ("New Mail", "Ding")], id: \.0) { s in
                    HStack {
                        Text(s.0).font(.system(size: 15))
                        Spacer()
                        Text(s.1).font(.system(size: 14)).foregroundColor(.gray)
                        Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(.gray)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(Color.white)
                }
            }
        }
    }

    private var brightnessPage: some View {
        pageShell(title: "Brightness & Wallpaper") {
            iOS6Section {
                VStack(spacing: 6) {
                    HStack {
                        Image(systemName: "sun.min.fill").foregroundColor(.gray)
                        Slider(value: $brightness).tint(Color(red: 0.25, green: 0.45, blue: 0.85))
                        Image(systemName: "sun.max.fill").foregroundColor(.gray)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(Color.white)
                    toggleRowPlain(title: "Auto-Brightness", isOn: $autoBrightness)
                        .padding(.horizontal, 0)
                }
            }
            iOS6SectionHeader(title: "Wallpaper")
            iOS6Section {
                navRowPlain(title: "Choose Wallpaper", value: Wallpapers.names[sim.wallpaperIndex]) {
                    path.append(.wallpaper)
                }
            }
        }
    }

    private var wallpaperPage: some View {
        pageShell(title: "Wallpaper", back: "Brightness & Wallpaper") {
            iOS6Section {
                ForEach(0..<Wallpapers.names.count, id: \.self) { i in
                    Button {
                        sim.wallpaperIndex = i
                    } label: {
                        HStack(spacing: 12) {
                            Wallpapers.view(index: i)
                                .frame(width: 46, height: 80)
                                .cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 1))
                            Text(Wallpapers.names[i]).font(.system(size: 15)).foregroundColor(.black)
                            Spacer()
                            if sim.wallpaperIndex == i {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(red: 0.25, green: 0.45, blue: 0.9))
                            }
                        }
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Color.white)
                    }.buttonStyle(.plain)
                }
            }
        }
    }

    private var privacyPage: some View {
        pageShell(title: "Privacy") {
            iOS6Section {
                toggleRowPlain(title: "Location Services", isOn: $locationServices)
            }
            Text("Location Services uses GPS, Bluetooth, and crowd-sourced Wi-Fi hotspot locations to determine your approximate location.")
                .font(.system(size: 12)).foregroundColor(.gray)
                .padding(.horizontal, 20).padding(.top, 8)
            iOS6Section {
                navRowPlain(title: "Contacts") {}
                divider
                navRowPlain(title: "Calendars") {}
                divider
                navRowPlain(title: "Photos") {}
            }
        }
    }

    private var icloudPage: some View {
        pageShell(title: "iCloud") {
            iOS6Section {
                HStack {
                    Circle().fill(Color.gray.opacity(0.3)).frame(width: 44, height: 44)
                        .overlay(Image(systemName: "person.fill").foregroundColor(.white))
                    VStack(alignment: .leading) {
                        Text("emckeon97").font(.system(size: 16, weight: .bold))
                        Text("Apple ID").font(.system(size: 13)).foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Color.white)
            }
            iOS6Section {
                ForEach([("Mail", true), ("Contacts", true), ("Calendars", true),
                         ("Reminders", true), ("Notes", false), ("Photos", false)], id: \.0) { item in
                    HStack {
                        Text(item.0).font(.system(size: 15))
                        Spacer()
                        iOS6Toggle(isOn: .constant(item.1))
                    }
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(Color.white)
                }
            }
            iOS6Section {
                navRowPlain(title: "Storage & Backup", value: "5.0 GB") {}
            }
        }
    }

    private var safariPage: some View {
        pageShell(title: "Safari") {
            iOS6SectionHeader(title: "General")
            iOS6Section {
                navRowPlain(title: "Search Engine", value: "Google") {}
                divider
                toggleRowPlain(title: "AutoFill", isOn: .constant(true))
            }
            iOS6SectionHeader(title: "Privacy")
            iOS6Section {
                toggleRowPlain(title: "Private Browsing", isOn: .constant(false))
                divider
                navRowPlain(title: "Clear History") {}
                divider
                navRowPlain(title: "Clear Cookies and Data") {}
            }
        }
    }

    // MARK: - Row helpers

    private var divider: some View {
        Divider().padding(.leading, 52)
    }

    private var brushedAluminum: some View {
        LinearGradient(
            colors: [Color(red: 0.78, green: 0.79, blue: 0.81),
                     Color(red: 0.68, green: 0.69, blue: 0.71)],
            startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }

    private func toggleRow(icon: String, iconColor: Color, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(iconColor)
                .frame(width: 30, height: 30)
                .overlay(Image(systemName: icon).font(.system(size: 16)).foregroundColor(.white))
            Text(title).font(.system(size: 15)).foregroundColor(.black)
            Spacer()
            iOS6Toggle(isOn: isOn)
        }
        .padding(.horizontal, 12).padding(.vertical, 7)
        .background(Color.white)
    }

    private func toggleRowPlain(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title).font(.system(size: 15)).foregroundColor(.black)
            Spacer()
            iOS6Toggle(isOn: isOn)
        }
        .padding(.horizontal, 14).padding(.vertical, 8)
        .background(Color.white)
    }

    private func navRow(icon: String, iconColor: Color, title: String, value: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(iconColor)
                    .frame(width: 30, height: 30)
                    .overlay(Image(systemName: icon).font(.system(size: 16)).foregroundColor(.white))
                Text(title).font(.system(size: 15)).foregroundColor(.black)
                Spacer()
                if let value {
                    Text(value).font(.system(size: 14)).foregroundColor(.gray)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold)).foregroundColor(.gray)
            }
            .padding(.horizontal, 12).padding(.vertical, 7)
            .background(Color.white)
        }.buttonStyle(.plain)
    }

    private func navRowPlain(title: String, value: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title).font(.system(size: 15)).foregroundColor(.black)
                Spacer()
                if let value {
                    Text(value).font(.system(size: 14)).foregroundColor(.gray)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold)).foregroundColor(.gray)
            }
            .padding(.horizontal, 14).padding(.vertical, 10)
            .background(Color.white)
        }.buttonStyle(.plain)
    }

    private func aboutRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 15))
            Spacer()
            Text(value).font(.system(size: 14)).foregroundColor(.gray)
        }
        .padding(.horizontal, 14).padding(.vertical, 9)
        .background(Color.white)
    }
}
