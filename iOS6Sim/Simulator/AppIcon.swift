import SwiftUI

/// A glossy iOS 6-style app icon: rounded rect, gradient, glyph, glass shine.
/// WinterBoard themes it flat and dark when `themed` is true.
struct iOS6Icon: View {
    let app: AppID
    var size: CGFloat = 60
    var themed: Bool = false
    var tint: Color? = nil

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .fill(themed ? themeGradient : iconGradient)
            iconGlyph
            // Glass shine: bright at the top, fading by mid-icon (stock only).
            if !themed {
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
            }
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .stroke(themed ? Color.white.opacity(0.15) : Color.black.opacity(0.25), lineWidth: 1)
            // Custom tweak tint ("IconTint"-style).
            if let tint {
                RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                    .fill(tint.opacity(0.30))
            }
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.35), radius: 3, y: 2)
    }

    /// WinterBoard "Ayecon"-style: flat dark slate, no gloss.
    private var themeGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.22, green: 0.24, blue: 0.28),
                     Color(red: 0.10, green: 0.11, blue: 0.14)],
            startPoint: .top, endPoint: .bottom)
    }

    private var iconGradient: LinearGradient {
        switch app {
        case .phone:
            return LinearGradient(
                colors: [Color(red: 0.55, green: 0.85, blue: 0.35),
                         Color(red: 0.20, green: 0.60, blue: 0.15)],
                startPoint: .top, endPoint: .bottom)
        case .mail:
            return LinearGradient(
                colors: [Color(red: 0.35, green: 0.60, blue: 0.95),
                         Color(red: 0.15, green: 0.35, blue: 0.75)],
                startPoint: .top, endPoint: .bottom)
        case .safari:
            return LinearGradient(
                colors: [Color(red: 0.85, green: 0.92, blue: 0.98),
                         Color(red: 0.55, green: 0.70, blue: 0.88)],
                startPoint: .top, endPoint: .bottom)
        case .music:
            return LinearGradient(
                colors: [Color(red: 0.95, green: 0.45, blue: 0.25),
                         Color(red: 0.75, green: 0.20, blue: 0.10)],
                startPoint: .top, endPoint: .bottom)
        case .messages:
            return LinearGradient(
                colors: [Color(red: 0.35, green: 0.75, blue: 0.25),
                         Color(red: 0.15, green: 0.55, blue: 0.12)],
                startPoint: .top, endPoint: .bottom)
        case .calendar:
            return LinearGradient(
                colors: [Color.white, Color(red: 0.92, green: 0.92, blue: 0.94)],
                startPoint: .top, endPoint: .bottom)
        case .photos:
            return LinearGradient(
                colors: [Color.white, Color(red: 0.85, green: 0.87, blue: 0.90)],
                startPoint: .top, endPoint: .bottom)
        case .camera:
            return LinearGradient(
                colors: [Color(red: 0.70, green: 0.72, blue: 0.75),
                         Color(red: 0.40, green: 0.42, blue: 0.45)],
                startPoint: .top, endPoint: .bottom)
        case .weather:
            return LinearGradient(
                colors: [Color(red: 0.25, green: 0.55, blue: 0.90),
                         Color(red: 0.10, green: 0.30, blue: 0.70)],
                startPoint: .top, endPoint: .bottom)
        case .clock:
            return LinearGradient(
                colors: [Color(red: 0.12, green: 0.12, blue: 0.14),
                         Color.black],
                startPoint: .top, endPoint: .bottom)
        case .maps:
            return LinearGradient(
                colors: [Color(red: 0.85, green: 0.88, blue: 0.80),
                         Color(red: 0.65, green: 0.75, blue: 0.60)],
                startPoint: .top, endPoint: .bottom)
        case .notes:
            return LinearGradient(
                colors: [Color(red: 0.98, green: 0.85, blue: 0.45),
                         Color(red: 0.95, green: 0.72, blue: 0.25)],
                startPoint: .top, endPoint: .bottom)
        case .reminders:
            return LinearGradient(
                colors: [Color.white, Color(red: 0.88, green: 0.88, blue: 0.90)],
                startPoint: .top, endPoint: .bottom)
        case .stocks:
            return LinearGradient(
                colors: [Color(red: 0.15, green: 0.15, blue: 0.18),
                         Color.black],
                startPoint: .top, endPoint: .bottom)
        case .newsstand:
            return LinearGradient(
                colors: [Color(red: 0.55, green: 0.38, blue: 0.22),
                         Color(red: 0.35, green: 0.22, blue: 0.12)],
                startPoint: .top, endPoint: .bottom)
        case .settings:
            return LinearGradient(
                colors: [Color(red: 0.55, green: 0.58, blue: 0.62),
                         Color(red: 0.30, green: 0.32, blue: 0.36)],
                startPoint: .top, endPoint: .bottom)
        case .itunes:
            return LinearGradient(
                colors: [Color(red: 0.45, green: 0.35, blue: 0.75),
                         Color(red: 0.25, green: 0.18, blue: 0.55)],
                startPoint: .top, endPoint: .bottom)
        case .appstore:
            return LinearGradient(
                colors: [Color(red: 0.30, green: 0.55, blue: 0.90),
                         Color(red: 0.12, green: 0.32, blue: 0.68)],
                startPoint: .top, endPoint: .bottom)
        case .gamecenter:
            return LinearGradient(
                colors: [Color(red: 0.90, green: 0.92, blue: 0.95),
                         Color(red: 0.65, green: 0.70, blue: 0.78)],
                startPoint: .top, endPoint: .bottom)
        case .youtube:
            return LinearGradient(
                colors: [Color.white, Color(red: 0.88, green: 0.88, blue: 0.90)],
                startPoint: .top, endPoint: .bottom)
        case .passbook:
            return LinearGradient(
                colors: [Color(red: 0.16, green: 0.20, blue: 0.30),
                         Color(red: 0.06, green: 0.08, blue: 0.14)],
                startPoint: .top, endPoint: .bottom)
        case .compass:
            return LinearGradient(
                colors: [Color(red: 0.20, green: 0.20, blue: 0.22),
                         Color.black],
                startPoint: .top, endPoint: .bottom)
        case .evasi0n:
            return LinearGradient(
                colors: [Color.white, Color(red: 0.88, green: 0.88, blue: 0.90)],
                startPoint: .top, endPoint: .bottom)
        case .cydia:
            return LinearGradient(
                colors: [Color(red: 0.62, green: 0.52, blue: 0.42),
                         Color(red: 0.42, green: 0.33, blue: 0.24)],
                startPoint: .top, endPoint: .bottom)
        case .calculator:
            return LinearGradient(
                colors: [Color(red: 0.25, green: 0.25, blue: 0.28),
                         Color(red: 0.08, green: 0.08, blue: 0.10)],
                startPoint: .top, endPoint: .bottom)
        }
    }

    @ViewBuilder
    private var iconGlyph: some View {
        switch app {
        case .phone:
            Image(systemName: "phone.fill")
                .font(.system(size: size * 0.48))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
        case .mail:
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.08)
                    .fill(Color.white)
                    .frame(width: size * 0.58, height: size * 0.42)
                Path { p in
                    p.move(to: CGPoint(x: -size*0.29, y: -size*0.12))
                    p.addLine(to: CGPoint(x: 0, y: size*0.06))
                    p.addLine(to: CGPoint(x: size*0.29, y: -size*0.12))
                    p.addLine(to: CGPoint(x: size*0.29, y: -size*0.18))
                    p.addLine(to: CGPoint(x: -size*0.29, y: -size*0.18))
                    p.closeSubpath()
                }
                .fill(Color(red: 0.75, green: 0.82, blue: 0.90))
            }
        case .safari:
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: size * 0.58, height: size * 0.58)
                Circle()
                    .stroke(Color(red: 0.3, green: 0.5, blue: 0.8), lineWidth: 2)
                    .frame(width: size * 0.58, height: size * 0.58)
                // Compass needle
                Path { p in
                    p.move(to: CGPoint(x: 0, y: -size*0.20))
                    p.addLine(to: CGPoint(x: size*0.07, y: 0))
                    p.addLine(to: CGPoint(x: 0, y: size*0.20))
                    p.addLine(to: CGPoint(x: -size*0.07, y: 0))
                    p.closeSubpath()
                }
                .fill(Color.red)
                .rotationEffect(.degrees(45))
            }
        case .music:
            Image(systemName: "music.note")
                .font(.system(size: size * 0.48, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
        case .messages:
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
        case .calendar:
            VStack(spacing: 0) {
                Text("Friday")
                    .font(.system(size: size * 0.12, weight: .medium))
                    .foregroundColor(.red)
                Text("4")
                    .font(.system(size: size * 0.42, weight: .light))
                    .foregroundColor(.black)
            }
        case .photos:
            ZStack {
                ForEach(0..<8, id: \.self) { i in
                    Ellipse()
                        .fill([Color.red, Color.orange, Color.yellow, Color.green,
                               Color.blue, Color.purple, Color.pink, Color.orange][i])
                        .frame(width: size * 0.16, height: size * 0.34)
                        .offset(y: -size * 0.17)
                        .rotationEffect(.degrees(Double(i) * 45))
                }
                Circle()
                    .fill(Color(red: 0.45, green: 0.28, blue: 0.12))
                    .frame(width: size * 0.26, height: size * 0.26)
            }
        case .camera:
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.12)
                    .fill(Color(red: 0.25, green: 0.25, blue: 0.28))
                    .frame(width: size * 0.62, height: size * 0.44)
                Circle()
                    .fill(Color(red: 0.15, green: 0.35, blue: 0.55))
                    .frame(width: size * 0.30, height: size * 0.30)
                Circle()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: size * 0.14, height: size * 0.14)
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
        case .maps:
            ZStack {
                // Simplified map with roads and pin
                RoundedRectangle(cornerRadius: size * 0.08)
                    .fill(Color(red: 0.90, green: 0.95, blue: 0.75))
                    .frame(width: size * 0.58, height: size * 0.58)
                Path { p in
                    p.move(to: CGPoint(x: -size*0.25, y: 0))
                    p.addLine(to: CGPoint(x: size*0.25, y: 0))
                    p.move(to: CGPoint(x: 0, y: -size*0.25))
                    p.addLine(to: CGPoint(x: 0, y: size*0.25))
                }
                .stroke(Color.white, lineWidth: 3)
                Image(systemName: "mappin")
                    .font(.system(size: size * 0.30))
                    .foregroundColor(.red)
                    .offset(y: -size * 0.05)
            }
        case .notes:
            VStack(spacing: 3) {
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color(red: 0.55, green: 0.45, blue: 0.30).opacity(0.7))
                        .frame(width: size * 0.55, height: 2)
                }
            }
        case .reminders:
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
        case .stocks:
            ZStack {
                Path { p in
                    p.move(to: CGPoint(x: -size*0.22, y: size*0.12))
                    p.addLine(to: CGPoint(x: -size*0.08, y: -size*0.02))
                    p.addLine(to: CGPoint(x: size*0.02, y: size*0.06))
                    p.addLine(to: CGPoint(x: size*0.14, y: -size*0.12))
                    p.addLine(to: CGPoint(x: size*0.22, y: -size*0.06))
                }
                .stroke(Color.white, lineWidth: 2.5)
            }
        case .newsstand:
            HStack(spacing: size * 0.06) {
                ForEach(0..<3, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill([Color.red, Color.blue, Color.green][i])
                        .frame(width: size * 0.16, height: size * 0.42)
                }
            }
        case .settings:
            Image(systemName: "gearshape.fill")
                .font(.system(size: size * 0.52))
                .foregroundColor(Color(red: 0.92, green: 0.93, blue: 0.95))
                .shadow(color: .black.opacity(0.4), radius: 2, y: 1)
        case .itunes:
            Image(systemName: "music.note")
                .font(.system(size: size * 0.48, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
        case .appstore:
            ZStack {
                // "A" made of popsicle sticks
                Path { p in
                    p.move(to: CGPoint(x: -size*0.14, y: size*0.18))
                    p.addLine(to: CGPoint(x: 0, y: -size*0.18))
                    p.addLine(to: CGPoint(x: size*0.14, y: size*0.18))
                }
                .stroke(Color.white, lineWidth: size * 0.08)
                Path { p in
                    p.move(to: CGPoint(x: -size*0.08, y: size*0.04))
                    p.addLine(to: CGPoint(x: size*0.08, y: size*0.04))
                }
                .stroke(Color.white, lineWidth: size * 0.06)
            }
        case .gamecenter:
            ZStack {
                ForEach(0..<5, id: \.self) { i in
                    Circle()
                        .fill([Color.red, Color.blue, Color.green, Color.yellow, Color.purple][i].opacity(0.7))
                        .frame(width: size * 0.22, height: size * 0.22)
                        .offset(x: cos(Double(i) * 1.26) * size * 0.16,
                                y: sin(Double(i) * 1.26) * size * 0.16)
                }
            }
        case .youtube:
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.12)
                    .fill(Color(red: 0.85, green: 0.15, blue: 0.15))
                    .frame(width: size * 0.58, height: size * 0.42)
                Path { p in
                    p.move(to: CGPoint(x: -size*0.08, y: -size*0.10))
                    p.addLine(to: CGPoint(x: size*0.12, y: 0))
                    p.addLine(to: CGPoint(x: -size*0.08, y: size*0.10))
                    p.closeSubpath()
                }
                .fill(Color.white)
            }
        case .compass:
            ZStack {
                Circle()
                    .fill(Color(red: 0.25, green: 0.25, blue: 0.28))
                    .frame(width: size * 0.62, height: size * 0.62)
                Circle()
                    .stroke(Color.white.opacity(0.7), lineWidth: 2)
                    .frame(width: size * 0.62, height: size * 0.62)
                Path { p in
                    p.move(to: CGPoint(x: 0, y: -size*0.24))
                    p.addLine(to: CGPoint(x: size*0.06, y: 0))
                    p.addLine(to: CGPoint(x: -size*0.06, y: 0))
                    p.closeSubpath()
                }
                .fill(Color.red)
                .rotationEffect(.degrees(-30))
                Path { p in
                    p.move(to: CGPoint(x: 0, y: size*0.24))
                    p.addLine(to: CGPoint(x: size*0.06, y: 0))
                    p.addLine(to: CGPoint(x: -size*0.06, y: 0))
                    p.closeSubpath()
                }
                .fill(Color.white)
                .rotationEffect(.degrees(-30))
                Circle().fill(Color.black).frame(width: size*0.08, height: size*0.08)
                Text("N").font(.system(size: size*0.14, weight: .bold)).foregroundColor(.red)
                    .offset(y: -size*0.20)
            }
        case .passbook:
            ZStack {
                ForEach(0..<3, id: \.self) { i in
                    RoundedRectangle(cornerRadius: size * 0.08)
                        .fill([Color(red: 0.2, green: 0.5, blue: 0.85),
                               Color(red: 0.85, green: 0.35, blue: 0.2),
                               Color(red: 0.25, green: 0.65, blue: 0.35)][i])
                        .frame(width: size * 0.56, height: size * 0.34)
                        .offset(y: CGFloat(i - 1) * size * 0.10)
                        .rotationEffect(.degrees(Double(i - 1) * -8))
                }
            }
        case .evasi0n:
            ZStack {
                Circle()
                    .fill(Color(red: 0.25, green: 0.25, blue: 0.28))
                    .frame(width: size * 0.52, height: size * 0.52)
                Text("e")
                    .font(.system(size: size * 0.36, weight: .ultraLight))
                    .foregroundColor(.white)
            }
        case .cydia:
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.06)
                    .fill(Color(red: 0.72, green: 0.55, blue: 0.30))
                    .frame(width: size * 0.52, height: size * 0.52)
                RoundedRectangle(cornerRadius: size * 0.04)
                    .fill(Color(red: 0.55, green: 0.38, blue: 0.18))
                    .frame(width: size * 0.52, height: size * 0.16)
                    .offset(y: -size * 0.18)
                RoundedRectangle(cornerRadius: size * 0.02)
                    .fill(Color(red: 0.35, green: 0.22, blue: 0.10))
                    .frame(width: size * 0.30, height: size * 0.08)
                    .offset(y: -size * 0.18)
            }
        case .calculator:
            Text("+-×÷")
                .font(.system(size: size * 0.32, weight: .light))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}
