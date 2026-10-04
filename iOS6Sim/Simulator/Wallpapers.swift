import SwiftUI

/// Procedural iOS 6-era wallpapers — no image assets needed.
enum Wallpapers {
    static let names = ["Deep Blue", "Sunset", "Midnight", "Ocean"]

    static func view(index: Int) -> some View {
        switch index % names.count {
        case 1: return AnyView(sunset)
        case 2: return AnyView(midnight)
        case 3: return AnyView(ocean)
        default: return AnyView(deepBlue)
        }
    }

    // The classic iOS 6 default: deep blue with soft light streaks.
    private static var deepBlue: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.12, blue: 0.28),
                         Color(red: 0.10, green: 0.25, blue: 0.48),
                         Color(red: 0.05, green: 0.14, blue: 0.30)],
                startPoint: .top, endPoint: .bottom)
            Ellipse()
                .fill(Color.white.opacity(0.14))
                .frame(width: 260, height: 90)
                .blur(radius: 30)
                .offset(x: -40, y: -160)
            Ellipse()
                .fill(Color.cyan.opacity(0.10))
                .frame(width: 200, height: 320)
                .blur(radius: 40)
                .offset(x: 90, y: 60)
            Ellipse()
                .fill(Color.white.opacity(0.08))
                .frame(width: 140, height: 140)
                .blur(radius: 25)
                .offset(x: -70, y: 180)
        }
    }

    private static var sunset: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.16, green: 0.10, blue: 0.28),
                         Color(red: 0.55, green: 0.22, blue: 0.32),
                         Color(red: 0.95, green: 0.55, blue: 0.25)],
                startPoint: .top, endPoint: .bottom)
            Circle()
                .fill(Color.yellow.opacity(0.5))
                .frame(width: 120, height: 120)
                .blur(radius: 18)
                .offset(y: 60)
        }
    }

    private static var midnight: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.08, green: 0.08, blue: 0.16)],
                startPoint: .top, endPoint: .bottom)
            ForEach(0..<40, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 2, height: 2)
                    .offset(x: CGFloat((i * 53) % 300) - 150,
                            y: CGFloat((i * 91) % 520) - 260)
            }
            Circle()
                .fill(Color(red: 0.95, green: 0.93, blue: 0.82))
                .frame(width: 70, height: 70)
                .blur(radius: 2)
                .offset(x: 70, y: -170)
        }
    }

    private static var ocean: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.35, blue: 0.45),
                         Color(red: 0.02, green: 0.18, blue: 0.30)],
                startPoint: .top, endPoint: .bottom)
            ForEach(0..<7, id: \.self) { i in
                Ellipse()
                    .fill(Color.white.opacity(0.07))
                    .frame(width: 220, height: 26)
                    .blur(radius: 8)
                    .offset(y: CGFloat(i * 70) - 200)
            }
        }
    }
}
