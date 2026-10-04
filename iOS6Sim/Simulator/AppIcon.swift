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
            if let tint {
                RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                    .fill(tint.opacity(0.30))
            }
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.35), radius: 3, y: 2)
    }

    private var themeGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.22, green: 0.24, blue: 0.28),
                     Color(red: 0.10, green: 0.11, blue: 0.14)],
            startPoint: .top, endPoint: .bottom)
    }

    private var iconGradient: LinearGradient {
        switch app {
        case .phone:
            return LinearGradient(colors: [Color(red: 0.55, green: 0.85, blue: 0.35), Color(red: 0.20, green: 0.60, blue: 0.15)], startPoint: .top, endPoint: .bottom)
        case .mail:
            return LinearGradient(colors: [Color(red: 0.35, green: 0.60, blue: 0.95), Color(red: 0.15, green: 0.35, blue: 0.75)], startPoint: .top, endPoint: .bottom)
        case .safari:
            return LinearGradient(colors: [Color(red: 0.85, green: 0.92, blue: 0.98), Color(red: 0.55, green: 0.70, blue: 0.88)], startPoint: .top, endPoint: .bottom)
        case .music:
            return LinearGradient(colors: [Color(red: 0.98, green: 0.62, blue: 0.30), Color(red: 0.85, green: 0.30, blue: 0.10)], startPoint: .top, endPoint: .bottom)
        case .messages:
            return LinearGradient(colors: [Color(red: 0.35, green: 0.75, blue: 0.25), Color(red: 0.15, green: 0.55, blue: 0.12)], startPoint: .top, endPoint: .bottom)
        case .calendar:
            return LinearGradient(colors: [Color.white, Color(red: 0.92, green: 0.92, blue: 0.94)], startPoint: .top, endPoint: .bottom)
        case .photos:
            return LinearGradient(colors: [Color(red: 0.70, green: 0.85, blue: 0.96), Color(red: 0.94, green: 0.97, blue: 1.0)], startPoint: .top, endPoint: .bottom)
        case .camera:
            return LinearGradient(colors: [Color(red: 0.78, green: 0.80, blue: 0.83), Color(red: 0.48, green: 0.50, blue: 0.53)], startPoint: .top, endPoint: .bottom)
        case .weather:
            return LinearGradient(colors: [Color(red: 0.25, green: 0.55, blue: 0.90), Color(red: 0.10, green: 0.30, blue: 0.70)], startPoint: .top, endPoint: .bottom)
        case .clock:
            return LinearGradient(colors: [Color(red: 0.12, green: 0.12, blue: 0.14), Color.black], startPoint: .top, endPoint: .bottom)
        case .maps:
            return LinearGradient(colors: [Color(red: 0.93, green: 0.89, blue: 0.78), Color(red: 0.84, green: 0.79, blue: 0.66)], startPoint: .top, endPoint: .bottom)
        case .notes:
            return LinearGradient(colors: [Color(red: 0.98, green: 0.85, blue: 0.45), Color(red: 0.95, green: 0.72, blue: 0.25)], startPoint: .top, endPoint: .bottom)
        case .reminders:
            return LinearGradient(colors: [Color.white, Color(red: 0.88, green: 0.88, blue: 0.90)], startPoint: .top, endPoint: .bottom)
        case .stocks:
            return LinearGradient(colors: [Color(red: 0.15, green: 0.15, blue: 0.18), Color.black], startPoint: .top, endPoint: .bottom)
        case .newsstand:
            return LinearGradient(colors: [Color(red: 0.74, green: 0.55, blue: 0.35), Color(red: 0.55, green: 0.37, blue: 0.20)], startPoint: .top, endPoint: .bottom)
        case .settings:
            return LinearGradient(colors: [Color(red: 0.22, green: 0.22, blue: 0.24), Color(red: 0.10, green: 0.10, blue: 0.12)], startPoint: .top, endPoint: .bottom)
        case .itunes:
            return LinearGradient(colors: [Color(red: 0.52, green: 0.40, blue: 0.80), Color(red: 0.28, green: 0.18, blue: 0.58)], startPoint: .top, endPoint: .bottom)
        case .appstore:
            return LinearGradient(colors: [Color(red: 0.30, green: 0.55, blue: 0.90), Color(red: 0.12, green: 0.32, blue: 0.68)], startPoint: .top, endPoint: .bottom)
        case .gamecenter:
            return LinearGradient(colors: [Color(red: 0.90, green: 0.92, blue: 0.95), Color(red: 0.65, green: 0.70, blue: 0.78)], startPoint: .top, endPoint: .bottom)
        case .youtube:
            return LinearGradient(colors: [Color(red: 0.28, green: 0.28, blue: 0.30), Color(red: 0.08, green: 0.08, blue: 0.10)], startPoint: .top, endPoint: .bottom)
        case .passbook:
            return LinearGradient(colors: [Color(red: 0.16, green: 0.20, blue: 0.30), Color(red: 0.06, green: 0.08, blue: 0.14)], startPoint: .top, endPoint: .bottom)
        case .compass:
            return LinearGradient(colors: [Color(red: 0.20, green: 0.20, blue: 0.22), Color.black], startPoint: .top, endPoint: .bottom)
        case .evasi0n:
            return LinearGradient(colors: [Color.white, Color(red: 0.88, green: 0.88, blue: 0.90)], startPoint: .top, endPoint: .bottom)
        case .cydia:
            return LinearGradient(colors: [Color(red: 0.62, green: 0.52, blue: 0.42), Color(red: 0.42, green: 0.33, blue: 0.24)], startPoint: .top, endPoint: .bottom)
        case .calculator:
            return LinearGradient(colors: [Color(red: 0.25, green: 0.25, blue: 0.28), Color(red: 0.08, green: 0.08, blue: 0.10)], startPoint: .top, endPoint: .bottom)
        }
    }

    private var musicNoteColor: Color { Color(red: 0.40, green: 0.10, blue: 0.07) }

    private func knightPath(size: CGFloat) -> Path {
        var p = Path()
        let s = size * 0.24
        func pt(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * s - s / 2, y: y * s - s / 2) }
        p.move(to: pt(0.28, 1.00))
        p.addLine(to: pt(0.28, 0.62))
        p.addQuadCurve(to: pt(0.40, 0.40), control: pt(0.30, 0.52))
        p.addLine(to: pt(0.24, 0.32))
        p.addQuadCurve(to: pt(0.38, 0.26), control: pt(0.28, 0.24))
        p.addLine(to: pt(0.44, 0.08))
        p.addLine(to: pt(0.52, 0.18))
        p.addLine(to: pt(0.60, 0.10))
        p.addQuadCurve(to: pt(0.68, 0.42), control: pt(0.68, 0.22))
        p.addQuadCurve(to: pt(0.76, 0.72), control: pt(0.74, 0.56))
        p.addLine(to: pt(0.80, 1.00))
        p.closeSubpath()
        return p
    }

    @ViewBuilder
    private var iconGlyph: some View {
        switch app {
        case .phone:
            ZStack {
                Path { p in p.addArc(center: CGPoint(x: size * 0.10, y: size * 0.02), radius: size * 0.23, startAngle: .degrees(225), endAngle: .degrees(45), clockwise: false) }
                    .stroke(Color.white, style: StrokeStyle(lineWidth: size * 0.155, lineCap: .round))
                    .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
                Path { p in p.addArc(center: CGPoint(x: size * 0.10, y: size * 0.02), radius: size * 0.23, startAngle: .degrees(205), endAngle: .degrees(150), clockwise: false) }
                    .stroke(Color.white.opacity(0.55), style: StrokeStyle(lineWidth: size * 0.045, lineCap: .round))
                    .offset(x: -size * 0.015, y: -size * 0.015)
            }
        case .mail:
            ZStack {
                Ellipse().fill(Color.white.opacity(0.45)).frame(width: size * 0.52, height: size * 0.20).offset(y: size * 0.24)
                RoundedRectangle(cornerRadius: size * 0.08).fill(Color.white).frame(width: size * 0.58, height: size * 0.42).shadow(color: .black.opacity(0.20), radius: 1, y: 1)
                Path { p in p.move(to: CGPoint(x: -size * 0.27, y: -size * 0.19)); p.addLine(to: CGPoint(x: 0, y: size * 0.02)); p.addLine(to: CGPoint(x: size * 0.27, y: -size * 0.19)) }.stroke(Color(red: 0.68, green: 0.74, blue: 0.83), lineWidth: 1.5)
                Path { p in p.move(to: CGPoint(x: -size * 0.27, y: size * 0.19)); p.addLine(to: CGPoint(x: -size * 0.05, y: -size * 0.02)); p.move(to: CGPoint(x: size * 0.27, y: size * 0.19)); p.addLine(to: CGPoint(x: size * 0.05, y: -size * 0.02)) }.stroke(Color(red: 0.80, green: 0.85, blue: 0.90), lineWidth: 1)
            }
        case .safari:
            ZStack {
                Circle().fill(Color.white).frame(width: size * 0.58, height: size * 0.58)
                Circle().stroke(Color(red: 0.30, green: 0.52, blue: 0.82), lineWidth: size * 0.028).frame(width: size * 0.58, height: size * 0.58)
                ForEach(0..<4, id: \.self) { i in
                    Path { p in p.move(to: CGPoint(x: 0, y: -size * 0.235)); p.addLine(to: CGPoint(x: size * 0.032, y: 0)); p.addLine(to: CGPoint(x: 0, y: size * 0.235)); p.addLine(to: CGPoint(x: -size * 0.032, y: 0)); p.closeSubpath() }
                        .fill(Color(red: 0.55, green: 0.68, blue: 0.85).opacity(0.65))
                        .rotationEffect(.degrees(Double(i) * 45))
                }
                ZStack {
                    Path { p in p.move(to: CGPoint(x: 0, y: -size * 0.26)); p.addLine(to: CGPoint(x: size * 0.055, y: 0)); p.addLine(to: CGPoint(x: -size * 0.055, y: 0)); p.closeSubpath() }
                        .fill(LinearGradient(colors: [Color(red: 0.96, green: 0.36, blue: 0.14), Color(red: 0.74, green: 0.20, blue: 0.08)], startPoint: .top, endPoint: .bottom))
                    Path { p in p.move(to: CGPoint(x: 0, y: size * 0.26)); p.addLine(to: CGPoint(x: size * 0.055, y: 0)); p.addLine(to: CGPoint(x: -size * 0.055, y: 0)); p.closeSubpath() }
                        .fill(LinearGradient(colors: [Color.white, Color(red: 0.72, green: 0.75, blue: 0.80)], startPoint: .top, endPoint: .bottom))
                }.rotationEffect(.degrees(45)).shadow(color: .black.opacity(0.25), radius: 1, y: 1)
                Circle().fill(RadialGradient(colors: [Color.white, Color(red: 0.70, green: 0.72, blue: 0.75)], center: .center, startRadius: 0, endRadius: size * 0.05)).frame(width: size * 0.10, height: size * 0.10)
            }
        case .music:
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.02).fill(musicNoteColor).frame(width: size * 0.30, height: size * 0.085).offset(x: size * 0.02, y: -size * 0.155).rotationEffect(.degrees(-4))
                RoundedRectangle(cornerRadius: size * 0.02).fill(musicNoteColor).frame(width: size * 0.055, height: size * 0.28).offset(x: -size * 0.10, y: -size * 0.03)
                RoundedRectangle(cornerRadius: size * 0.02).fill(musicNoteColor).frame(width: size * 0.055, height: size * 0.28).offset(x: size * 0.14, y: -size * 0.03)
                Ellipse().fill(musicNoteColor).frame(width: size * 0.165, height: size * 0.125).offset(x: -size * 0.135, y: size * 0.135).rotationEffect(.degrees(-18))
                Ellipse().fill(musicNoteColor).frame(width: size * 0.165, height: size * 0.125).offset(x: size * 0.105, y: size * 0.135).rotationEffect(.degrees(-18))
            }.shadow(color: .black.opacity(0.25), radius: 2, y: 1)
        case .messages:
            ZStack {
                Path { p in p.move(to: CGPoint(x: -size * 0.18, y: size * 0.14)); p.addLine(to: CGPoint(x: -size * 0.25, y: size * 0.28)); p.addLine(to: CGPoint(x: -size * 0.07, y: size * 0.16)); p.closeSubpath() }.fill(Color.white)
                RoundedRectangle(cornerRadius: size * 0.14).fill(LinearGradient(colors: [Color.white, Color(red: 0.90, green: 0.93, blue: 0.95)], startPoint: .top, endPoint: .bottom)).frame(width: size * 0.60, height: size * 0.40).offset(y: -size * 0.04).shadow(color: .black.opacity(0.25), radius: 2, y: 1)
            }
        case .calendar:
            CalendarIconGlyph(size: size)
        case .photos:
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.02).fill(Color(red: 0.25, green: 0.52, blue: 0.20)).frame(width: size * 0.05, height: size * 0.20).offset(y: size * 0.28)
                Ellipse().fill(Color(red: 0.25, green: 0.55, blue: 0.20)).frame(width: size * 0.10, height: size * 0.22).offset(x: -size * 0.17, y: size * 0.25).rotationEffect(.degrees(-35))
                Ellipse().fill(Color(red: 0.20, green: 0.48, blue: 0.18)).frame(width: size * 0.10, height: size * 0.22).offset(x: size * 0.17, y: size * 0.25).rotationEffect(.degrees(35))
                ForEach(0..<12, id: \.self) { i in Ellipse().fill(Color(red: 1.0, green: 0.82, blue: 0.12)).frame(width: size * 0.115, height: size * 0.30).offset(y: -size * 0.15).rotationEffect(.degrees(Double(i) * 30)) }
                ForEach(0..<12, id: \.self) { i in Ellipse().fill(Color(red: 1.0, green: 0.66, blue: 0.04).opacity(0.9)).frame(width: size * 0.07, height: size * 0.17).offset(y: -size * 0.095).rotationEffect(.degrees(Double(i) * 30 + 15)) }
                Circle().fill(Color(red: 0.32, green: 0.21, blue: 0.10)).frame(width: size * 0.25, height: size * 0.25)
                Circle().fill(Color(red: 0.18, green: 0.12, blue: 0.06)).frame(width: size * 0.15, height: size * 0.15)
            }
        case .camera:
            ZStack {
                Circle().fill(Color.black).frame(width: size * 0.58, height: size * 0.58)
                Circle().fill(Color(red: 0.04, green: 0.07, blue: 0.13)).frame(width: size * 0.46, height: size * 0.46)
                Circle().fill(RadialGradient(colors: [Color(red: 0.30, green: 0.50, blue: 0.75), Color(red: 0.04, green: 0.09, blue: 0.20)], center: .center, startRadius: size * 0.02, endRadius: size * 0.22)).frame(width: size * 0.40, height: size * 0.40)
                RoundedRectangle(cornerRadius: size * 0.03).fill(Color.white.opacity(0.40)).frame(width: size * 0.07, height: size * 0.24).rotationEffect(.degrees(35)).offset(x: -size * 0.07, y: -size * 0.05)
                Circle().fill(Color.white.opacity(0.65)).frame(width: size * 0.05, height: size * 0.05).offset(x: size * 0.09, y: size * 0.10)
            }
        case .weather:
            ZStack {
                Circle().fill(RadialGradient(colors: [Color(red: 1.0, green: 0.90, blue: 0.40), Color(red: 1.0, green: 0.70, blue: 0.15)], center: .center, startRadius: size * 0.02, endRadius: size * 0.20)).frame(width: size * 0.40, height: size * 0.40).offset(x: -size * 0.10, y: -size * 0.10)
                Ellipse().fill(Color.white).frame(width: size * 0.52, height: size * 0.28).offset(x: size * 0.08, y: size * 0.14).shadow(color: .black.opacity(0.15), radius: 1, y: 1)
                Circle().fill(Color.white).frame(width: size * 0.24, height: size * 0.24).offset(x: -size * 0.04, y: size * 0.06)
            }
        case .clock:
            ClockIconGlyph(size: size)
        case .maps:
            ZStack {
                Path { p in p.move(to: CGPoint(x: -size * 0.30, y: -size * 0.06)); p.addLine(to: CGPoint(x: size * 0.30, y: -size * 0.06)); p.move(to: CGPoint(x: -size * 0.02, y: -size * 0.30)); p.addLine(to: CGPoint(x: -size * 0.02, y: size * 0.30)); p.move(to: CGPoint(x: size * 0.21, y: -size * 0.30)); p.addLine(to: CGPoint(x: size * 0.17, y: size * 0.30)) }.stroke(Color.white.opacity(0.85), lineWidth: size * 0.035)
                Path { p in p.move(to: CGPoint(x: -size * 0.13, y: -size * 0.32)); p.addLine(to: CGPoint(x: -size * 0.13, y: size * 0.32)) }.stroke(Color(red: 0.96, green: 0.76, blue: 0.16), lineWidth: size * 0.07)
                ZStack {
                    Path { p in let w = size * 0.32, h = size * 0.30; p.move(to: CGPoint(x: -w / 2, y: -h / 2)); p.addLine(to: CGPoint(x: w / 2, y: -h / 2)); p.addLine(to: CGPoint(x: w / 2, y: h * 0.02)); p.addQuadCurve(to: CGPoint(x: 0, y: h / 2), control: CGPoint(x: w * 0.30, y: h * 0.30)); p.addQuadCurve(to: CGPoint(x: -w / 2, y: h * 0.02), control: CGPoint(x: -w * 0.30, y: h * 0.30)); p.closeSubpath() }.fill(Color(red: 0.16, green: 0.32, blue: 0.68))
                    RoundedRectangle(cornerRadius: size * 0.015).fill(Color(red: 0.78, green: 0.16, blue: 0.18)).frame(width: size * 0.27, height: size * 0.065).offset(y: -size * 0.105)
                    Text("280").font(.system(size: size * 0.105, weight: .bold)).foregroundColor(.white).offset(y: size * 0.015)
                }.offset(x: size * 0.10, y: -size * 0.10).shadow(color: .black.opacity(0.25), radius: 1, y: 1)
                ZStack {
                    Circle().fill(Color(red: 0.14, green: 0.44, blue: 0.92)).frame(width: size * 0.21, height: size * 0.21)
                    Circle().stroke(Color.white, lineWidth: size * 0.025).frame(width: size * 0.21, height: size * 0.21)
                    Path { p in p.move(to: CGPoint(x: 0, y: -size * 0.062)); p.addLine(to: CGPoint(x: size * 0.048, y: size * 0.052)); p.addLine(to: CGPoint(x: 0, y: size * 0.022)); p.addLine(to: CGPoint(x: -size * 0.048, y: size * 0.052)); p.closeSubpath() }.fill(Color.white)
                }.offset(x: -size * 0.16, y: size * 0.18).shadow(color: .black.opacity(0.30), radius: 2, y: 1)
            }
        case .notes:
            ZStack {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: size * 0.03).fill(LinearGradient(colors: [Color(red: 0.42, green: 0.30, blue: 0.20), Color(red: 0.30, green: 0.20, blue: 0.12)], startPoint: .top, endPoint: .bottom)).frame(width: size * 0.62, height: size * 0.16)
                    Spacer(minLength: 0)
                }.frame(width: size * 0.62, height: size * 0.62)
                VStack(spacing: size * 0.055) { ForEach(0..<4, id: \.self) { _ in RoundedRectangle(cornerRadius: 1).fill(Color(red: 0.55, green: 0.45, blue: 0.30).opacity(0.65)).frame(width: size * 0.52, height: 2) } }.offset(y: size * 0.08)
                RoundedRectangle(cornerRadius: 1).fill(Color.red.opacity(0.55)).frame(width: 1.5, height: size * 0.44).offset(x: -size * 0.18, y: size * 0.08)
            }
        case .reminders:
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.10).fill(Color.white).frame(width: size * 0.58, height: size * 0.58).shadow(color: .black.opacity(0.20), radius: 1, y: 1)
                VStack(spacing: size * 0.075) {
                    ForEach(0..<3, id: \.self) { _ in
                        HStack(spacing: size * 0.045) {
                            Image(systemName: "checkmark").font(.system(size: size * 0.105, weight: .bold)).foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.28)).frame(width: size * 0.11)
                            RoundedRectangle(cornerRadius: 1).fill(Color.red.opacity(0.55)).frame(width: 1.5, height: size * 0.13)
                            RoundedRectangle(cornerRadius: 1).fill(Color.gray.opacity(0.45)).frame(width: size * 0.28, height: size * 0.045)
                        }
                    }
                }
            }
        case .stocks:
            ZStack {
                Path { p in p.move(to: CGPoint(x: -size * 0.22, y: size * 0.12)); p.addLine(to: CGPoint(x: -size * 0.08, y: -size * 0.02)); p.addLine(to: CGPoint(x: size * 0.02, y: size * 0.06)); p.addLine(to: CGPoint(x: size * 0.14, y: -size * 0.12)); p.addLine(to: CGPoint(x: size * 0.22, y: -size * 0.06)) }.stroke(Color.white, lineWidth: 2.5)
            }
        case .newsstand:
            ZStack {
                ForEach(0..<3, id: \.self) { i in
                    ZStack {
                        RoundedRectangle(cornerRadius: size * 0.012).fill(Color(red: 0.80, green: 0.60, blue: 0.38)).frame(width: size * 0.68, height: size * 0.06)
                        RoundedRectangle(cornerRadius: size * 0.012).fill(Color.white.opacity(0.30)).frame(width: size * 0.68, height: size * 0.02).offset(y: -size * 0.02)
                        RoundedRectangle(cornerRadius: size * 0.012).fill(Color.black.opacity(0.18)).frame(width: size * 0.68, height: size * 0.02).offset(y: size * 0.02)
                    }.offset(y: CGFloat(i - 1) * size * 0.21)
                }
            }
        case .settings:
            ZStack {
                ForEach(0..<7, id: \.self) { r in
                    ForEach(0..<7, id: \.self) { c in
                        Circle().fill(Color.white.opacity(0.10)).frame(width: size * 0.035, height: size * 0.035).offset(x: CGFloat(c - 3) * size * 0.085, y: CGFloat(r - 3) * size * 0.085)
                    }
                }
                Image(systemName: "gearshape.fill").font(.system(size: size * 0.46)).foregroundColor(Color(red: 0.82, green: 0.83, blue: 0.86)).shadow(color: .black.opacity(0.50), radius: 2, y: 1).offset(x: -size * 0.08, y: -size * 0.08)
                Image(systemName: "gearshape.fill").font(.system(size: size * 0.32)).foregroundColor(Color(red: 0.70, green: 0.71, blue: 0.74)).shadow(color: .black.opacity(0.50), radius: 2, y: 1).offset(x: size * 0.15, y: size * 0.16)
            }
        case .itunes:
            ZStack {
                Circle().stroke(Color.white, lineWidth: size * 0.045).frame(width: size * 0.52, height: size * 0.52)
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.015).fill(Color.white).frame(width: size * 0.22, height: size * 0.06).offset(y: -size * 0.11)
                    RoundedRectangle(cornerRadius: size * 0.015).fill(Color.white).frame(width: size * 0.04, height: size * 0.20).offset(x: -size * 0.075, y: -size * 0.02)
                    RoundedRectangle(cornerRadius: size * 0.015).fill(Color.white).frame(width: size * 0.04, height: size * 0.20).offset(x: size * 0.115, y: -size * 0.02)
                    Ellipse().fill(Color.white).frame(width: size * 0.12, height: size * 0.09).offset(x: -size * 0.10, y: size * 0.10).rotationEffect(.degrees(-18))
                    Ellipse().fill(Color.white).frame(width: size * 0.12, height: size * 0.09).offset(x: size * 0.09, y: size * 0.10).rotationEffect(.degrees(-18))
                }
            }.shadow(color: .black.opacity(0.30), radius: 2, y: 1)
        case .appstore:
            ZStack {
                Circle().stroke(Color.white, lineWidth: size * 0.04).frame(width: size * 0.50, height: size * 0.50)
                Path { p in p.move(to: CGPoint(x: -size * 0.13, y: size * 0.16)); p.addLine(to: CGPoint(x: 0, y: -size * 0.16)); p.addLine(to: CGPoint(x: size * 0.13, y: size * 0.16)) }.stroke(Color.white, lineWidth: size * 0.075)
                Path { p in p.move(to: CGPoint(x: -size * 0.075, y: size * 0.03)); p.addLine(to: CGPoint(x: size * 0.075, y: size * 0.03)) }.stroke(Color.white, lineWidth: size * 0.055)
            }.shadow(color: .black.opacity(0.30), radius: 2, y: 1)
        case .gamecenter:
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ZStack {
                            LinearGradient(colors: [Color(red: 0.60, green: 0.42, blue: 0.24), Color(red: 0.78, green: 0.60, blue: 0.36)], startPoint: .top, endPoint: .bottom)
                            knightPath(size: size).fill(Color.white.opacity(0.95))
                        }.frame(width: size * 0.32, height: size * 0.32)
                        ZStack {
                            LinearGradient(colors: [Color(red: 0.22, green: 0.52, blue: 0.22), Color(red: 0.42, green: 0.70, blue: 0.32)], startPoint: .top, endPoint: .bottom)
                            RoundedRectangle(cornerRadius: size * 0.035).fill(Color.white).frame(width: size * 0.07, height: size * 0.24).rotationEffect(.degrees(38))
                            Circle().fill(Color.white).frame(width: size * 0.065, height: size * 0.065).offset(x: -size * 0.085, y: -size * 0.085)
                        }.frame(width: size * 0.32, height: size * 0.32)
                    }
                    HStack(spacing: 0) {
                        ZStack {
                            LinearGradient(colors: [Color(red: 0.12, green: 0.32, blue: 0.62), Color(red: 0.28, green: 0.52, blue: 0.82)], startPoint: .top, endPoint: .bottom)
                            ZStack {
                                Capsule().fill(Color.white).frame(width: size * 0.09, height: size * 0.20)
                                Circle().fill(Color(red: 0.12, green: 0.32, blue: 0.62)).frame(width: size * 0.045, height: size * 0.045).offset(y: -size * 0.035)
                                Path { p in p.move(to: CGPoint(x: -size * 0.045, y: size * 0.06)); p.addLine(to: CGPoint(x: -size * 0.10, y: size * 0.13)); p.addLine(to: CGPoint(x: -size * 0.01, y: size * 0.10)); p.closeSubpath() }.fill(Color.white)
                                Path { p in p.move(to: CGPoint(x: size * 0.045, y: size * 0.06)); p.addLine(to: CGPoint(x: size * 0.10, y: size * 0.13)); p.addLine(to: CGPoint(x: size * 0.01, y: size * 0.10)); p.closeSubpath() }.fill(Color.white)
                            }.rotationEffect(.degrees(45))
                        }.frame(width: size * 0.32, height: size * 0.32)
                        ZStack {
                            LinearGradient(colors: [Color(red: 0.82, green: 0.48, blue: 0.18), Color(red: 0.95, green: 0.64, blue: 0.28)], startPoint: .top, endPoint: .bottom)
                            Circle().stroke(Color.white, lineWidth: size * 0.028).frame(width: size * 0.19, height: size * 0.19)
                            Circle().fill(Color.white).frame(width: size * 0.05, height: size * 0.05)
                            ZStack {
                                RoundedRectangle(cornerRadius: size * 0.012).fill(Color.white).frame(width: size * 0.024, height: size * 0.24)
                                Path { p in p.move(to: CGPoint(x: 0, y: -size * 0.155)); p.addLine(to: CGPoint(x: size * 0.035, y: -size * 0.09)); p.addLine(to: CGPoint(x: -size * 0.035, y: -size * 0.09)); p.closeSubpath() }.fill(Color.white)
                            }.rotationEffect(.degrees(30))
                        }.frame(width: size * 0.32, height: size * 0.32)
                    }
                }.clipShape(RoundedRectangle(cornerRadius: size * 0.20, style: .continuous))
            }
        case .youtube:
            HStack(spacing: size * 0.025) {
                Text("You").font(.system(size: size * 0.20, weight: .bold)).foregroundColor(.white)
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.04).fill(Color(red: 0.80, green: 0.12, blue: 0.12)).frame(width: size * 0.32, height: size * 0.24)
                    Text("Tube").font(.system(size: size * 0.17, weight: .bold)).foregroundColor(.white)
                }
            }.shadow(color: .black.opacity(0.30), radius: 2, y: 1)
        case .compass:
            ZStack {
                Circle().fill(Color(red: 0.25, green: 0.25, blue: 0.28)).frame(width: size * 0.62, height: size * 0.62)
                Circle().stroke(Color.white.opacity(0.7), lineWidth: 2).frame(width: size * 0.62, height: size * 0.62)
                Path { p in p.move(to: CGPoint(x: 0, y: -size * 0.24)); p.addLine(to: CGPoint(x: size * 0.06, y: 0)); p.addLine(to: CGPoint(x: -size * 0.06, y: 0)); p.closeSubpath() }.fill(Color.red).rotationEffect(.degrees(-30))
                Path { p in p.move(to: CGPoint(x: 0, y: size * 0.24)); p.addLine(to: CGPoint(x: size * 0.06, y: 0)); p.addLine(to: CGPoint(x: -size * 0.06, y: 0)); p.closeSubpath() }.fill(Color.white).rotationEffect(.degrees(-30))
                Circle().fill(Color.black).frame(width: size * 0.08, height: size * 0.08)
                Text("N").font(.system(size: size * 0.14, weight: .bold)).foregroundColor(.red).offset(y: -size * 0.20)
            }
        case .passbook:
            ZStack {
                ForEach(0..<3, id: \.self) { i in
                    RoundedRectangle(cornerRadius: size * 0.08).fill([Color(red: 0.2, green: 0.5, blue: 0.85), Color(red: 0.85, green: 0.35, blue: 0.2), Color(red: 0.25, green: 0.65, blue: 0.35)][i]).frame(width: size * 0.56, height: size * 0.34).offset(y: CGFloat(i - 1) * size * 0.10).rotationEffect(.degrees(Double(i - 1) * -8))
                }
            }
        case .evasi0n:
            ZStack {
                Circle().fill(Color(red: 0.25, green: 0.25, blue: 0.28)).frame(width: size * 0.52, height: size * 0.52)
                Text("e").font(.system(size: size * 0.36, weight: .ultraLight)).foregroundColor(.white)
            }
        case .cydia:
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.06).fill(Color(red: 0.72, green: 0.55, blue: 0.30)).frame(width: size * 0.52, height: size * 0.52)
                RoundedRectangle(cornerRadius: size * 0.04).fill(Color(red: 0.55, green: 0.38, blue: 0.18)).frame(width: size * 0.52, height: size * 0.16).offset(y: -size * 0.18)
                RoundedRectangle(cornerRadius: size * 0.02).fill(Color(red: 0.35, green: 0.22, blue: 0.10)).frame(width: size * 0.30, height: size * 0.08).offset(y: -size * 0.18)
            }
        case .calculator:
            Text("+-×÷").font(.system(size: size * 0.32, weight: .light)).foregroundColor(.white.opacity(0.9))
        }
    }
}

private struct CalendarIconGlyph: View {
    var size: CGFloat
    var body: some View {
        let cal = Calendar.current
        let now = Date()
        let weekday = cal.weekdaySymbols[cal.component(.weekday, from: now) - 1]
        let day = cal.component(.day, from: now)
        return VStack(spacing: 0) {
            Text(weekday).font(.system(size: size * 0.115, weight: .medium)).foregroundColor(.red)
            Text("\(day)").font(.system(size: size * 0.40, weight: .light)).foregroundColor(.black)
        }
    }
}

private struct ClockIconGlyph: View {
    var size: CGFloat
    var body: some View {
        let comps = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        let hour = CGFloat((comps.hour ?? 0) % 12) + CGFloat(comps.minute ?? 0) / 60
        let minute = CGFloat(comps.minute ?? 0)
        let second = CGFloat(comps.second ?? 0)
        return ZStack {
            Circle().fill(Color.white).frame(width: size * 0.62, height: size * 0.62)
            ForEach(1...12, id: \.self) { h in
                Text("\(h)").font(.system(size: size * 0.085, weight: .medium)).foregroundColor(.black)
                    .offset(x: sin(Double(h) * .pi / 6) * size * 0.235, y: -cos(Double(h) * .pi / 6) * size * 0.235)
            }
            Rectangle().fill(Color.black).frame(width: size * 0.035, height: size * 0.17).offset(y: -size * 0.085).rotationEffect(.degrees(Double(hour) * 30))
            Rectangle().fill(Color.black).frame(width: size * 0.025, height: size * 0.24).offset(y: -size * 0.12).rotationEffect(.degrees(Double(minute) * 6))
            Rectangle().fill(Color.red).frame(width: size * 0.015, height: size * 0.26).offset(y: -size * 0.10).rotationEffect(.degrees(Double(second) * 6))
            Circle().fill(Color.black).frame(width: size * 0.05, height: size * 0.05)
        }
    }
}
