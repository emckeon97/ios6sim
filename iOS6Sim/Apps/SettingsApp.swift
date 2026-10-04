import SwiftUI

/// iOS 6 Settings: brushed aluminum, wallpaper picker, About.
struct SettingsApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var page: Page = .main

    enum Page { case main, wallpaper, about }

    var body: some View {
        ZStack {
            switch page {
            case .main:
                VStack(spacing: 0) {
                    iOS6StatusBar(darkText: true)
                    iOS6NavBar(title: "Settings")
                    ZStack {
                        brushedAluminum
                        List {
                            Section {
                                SettingsRow(title: "Wallpaper",
                                            value: Wallpapers.names[sim.wallpaperIndex]) {
                                    page = .wallpaper
                                }
                            }
                            Section {
                                SettingsRow(title: "About") {
                                    page = .about
                                }
                            }
                            Section {
                                HStack {
                                    Text("Simulator")
                                    Spacer()
                                    Text("v1.0")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                    }
                }
                .transition(.opacity)
            case .wallpaper:
                WallpaperPicker(back: { page = .main })
                    .transition(.move(edge: .trailing))
            case .about:
                AboutView(back: { page = .main })
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: page)
    }

    private var brushedAluminum: some View {
        LinearGradient(
            colors: [Color(red: 0.78, green: 0.79, blue: 0.81),
                     Color(red: 0.68, green: 0.69, blue: 0.71)],
            startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

struct SettingsRow: View {
    let title: String
    var value: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                if let value {
                    Text(value)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(.plain)
    }
}

struct WallpaperPicker: View {
    @EnvironmentObject var sim: SimulatorState
    var back: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            iOS6NavBar(
                title: "Wallpaper",
                left: AnyView(iOS6BackButton(label: "Settings", action: back))
            )
            ZStack {
                Color(red: 0.85, green: 0.86, blue: 0.88).ignoresSafeArea()
                List {
                    ForEach(0..<Wallpapers.names.count, id: \.self) { i in
                        Button {
                            sim.wallpaperIndex = i
                        } label: {
                            HStack(spacing: 12) {
                                Wallpapers.view(index: i)
                                    .frame(width: 52, height: 88)
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.black.opacity(0.2), lineWidth: 1))
                                Text(Wallpapers.names[i])
                                    .foregroundColor(.black)
                                Spacer()
                                if sim.wallpaperIndex == i {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
    }
}

struct AboutView: View {
    var back: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            iOS6NavBar(
                title: "About",
                left: AnyView(iOS6BackButton(label: "Settings", action: back))
            )
            ZStack {
                Color(red: 0.85, green: 0.86, blue: 0.88).ignoresSafeArea()
                List {
                    AboutRow(label: "Name", value: "iPhone")
                    AboutRow(label: "Software", value: "6.1.4")
                    AboutRow(label: "Model", value: "iPhone5,2")
                    AboutRow(label: "Simulator", value: "Mac")
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
        }
    }
}

struct AboutRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}
