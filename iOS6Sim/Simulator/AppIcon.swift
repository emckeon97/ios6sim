import SwiftUI

/// A glossy iOS 6-style app icon: rounded rect, gradient, glyph, glass shine.
struct iOS6Icon: View {
    let app: AppID
    var size: CGFloat = 60

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .fill(iconGradient)
            iconGlyph
            // Glass shine: bright at the top, fading by mid-icon.
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), Color.white.opacity(0.05)],
                        startPoint: .top, endPoint: .center)
                )
                .mask(
                    RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.black, .clear],
                                startPoint: .top, endPoint: .center))
                )
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .stroke(Color.black.opacity(0.25), lineWidth: 1)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.35), radius: 3, y: 2)
    }

    private var iconGradient: LinearGradient {
        switch app {
        case .notes:
            return LinearGradient(
                colors: [Color(red: 0.98, green: 0.85, blue: 0.45),
                         Color(red: 0.95, green: 0.72, blue: 0.25)],
                startPoint: .top, endPoint: .bottom)
        case .calculator:
            return LinearGradient(
                colors: [Color(red: 0.25, green: 0.25, blue: 0.28),
                         Color(red: 0.08, green: 0.08, blue: 0.10)],
                startPoint: .top, endPoint: .bottom)
        case .clock:
            return LinearGradient(
                colors: [Color(red: 0.12, green: 0.12, blue: 0.14),
                         Color.black],
                startPoint: .top, endPoint: .bottom)
        case .weather:
            return LinearGradient(
                colors: [Color(red: 0.25, green: 0.55, blue: 0.90),
                         Color(red: 0.10, green: 0.30, blue: 0.70)],
                startPoint: .top, endPoint: .bottom)
        case .settings:
            return LinearGradient(
                colors: [Color(red: 0.55, green: 0.58, blue: 0.62),
                         Color(red: 0.30, green: 0.32, blue: 0.36)],
                startPoint: .top, endPoint: .bottom)
        case .photos:
            return LinearGradient(
                colors: [Color.white, Color(red: 0.85, green: 0.87, blue: 0.90)],
                startPoint: .top, endPoint: .bottom)
        case .messages:
            return LinearGradient(
                colors: [Color(red: 0.35, green: 0.75, blue: 0.25),
                         Color(red: 0.15, green: 0.55, blue: 0.12)],
                startPoint: .top, endPoint: .bottom)
        case .reminders:
            return LinearGradient(
                colors: [Color.white, Color(red: 0.88, green: 0.88, blue: 0.90)],
                startPoint: .top, endPoint: .bottom)
        }
    }

    @ViewBuilder
    private var iconGlyph: some View {
        switch app {
        case .notes:
            // Yellow pad with ruled lines.
            VStack(spacing: 3) {
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color(red: 0.55, green: 0.45, blue: 0.30).opacity(0.7))
                        .frame(width: size * 0.55, height: 2)
                }
            }
        case .calculator:
            Text("+-×÷")
                .font(.system(size: size * 0.32, weight: .light))
                .foregroundColor(.white.opacity(0.9))
        case .clock:
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: size * 0.62, height: size * 0.62)
                Rectangle().fill(Color.black).frame(width: 2, height: size * 0.22)
                    .offset(y: -size * 0.08)
                Rectangle().fill(Color.black).frame(width: 2, height: size * 0.15)
                    .rotationEffect(.degrees(90)).offset(x: size * 0.05)
                Circle().fill(Color.black).frame(width: 4, height: 4)
            }
        case .weather:
            ZStack {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: size * 0.38, height: size * 0.38)
                    .offset(x: -size * 0.10, y: -size * 0.08)
                Ellipse()
                    .fill(Color.white)
                    .frame(width: size * 0.52, height: size * 0.30)
                    .offset(x: size * 0.08, y: size * 0.12)
            }
        case .settings:
            Image(systemName: "gearshape.fill")
                .font(.system(size: size * 0.52))
                .foregroundColor(Color(red: 0.92, green: 0.93, blue: 0.95))
                .shadow(color: .black.opacity(0.4), radius: 2, y: 1)
        case .photos:
            // Sunflower-ish: orange petals around a brown center.
            ZStack {
                ForEach(0..<8, id: \.self) { i in
                    Ellipse()
                        .fill(Color.orange)
                        .frame(width: size * 0.16, height: size * 0.34)
                        .offset(y: -size * 0.17)
                        .rotationEffect(.degrees(Double(i) * 45))
                }
                Circle()
                    .fill(Color(red: 0.45, green: 0.28, blue: 0.12))
                    .frame(width: size * 0.26, height: size * 0.26)
            }
        case .messages:
            // Green speech bubble.
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.18)
                    .fill(Color.white)
                    .frame(width: size * 0.62, height: size * 0.44)
                    .offset(y: -size * 0.04)
                Text("...")
                    .font(.system(size: size * 0.22, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.2))
                    .offset(y: -size * 0.08)
            }
        case .reminders:
            // Checklist.
            VStack(spacing: size * 0.07) {
                ForEach(0..<3, id: \.self) { i in
                    HStack(spacing: size * 0.06) {
                        Circle()
                            .stroke(Color.gray, lineWidth: 1.5)
                            .frame(width: size * 0.10, height: size * 0.10)
                            .overlay(
                                i == 0
                                    ? Text("✓").font(.system(size: size * 0.09))
                                        .foregroundColor(.orange)
                                    : nil
                            )
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: size * 0.32, height: size * 0.05)
                    }
                }
            }
        }
    }
}
