import SwiftUI

// MARK: - Passbook

struct PassbookPass: Identifiable {
    let id = UUID()
    let title: String, subtitle: String, detail: String
    let color: Color
    let backInfo: String
}

struct PassbookApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var selected: UUID? = nil
    @State private var flipped: UUID? = nil

    private let passes = [
        PassbookPass(title: "Starbucks", subtitle: "Gold Card", detail: "$12.50",
                     color: Color(red: 0.05, green: 0.35, blue: 0.20),
                     backInfo: "Card Number\n6100 1234 5678 9012\n\nBalance updates automatically when you pay."),
        PassbookPass(title: "Delta", subtitle: "Boarding Pass", detail: "CLT → ATL",
                     color: Color(red: 0.55, green: 0.10, blue: 0.15),
                     backInfo: "Flight DL 1847\nDeparts 9:30 AM, Oct 7\nSeat 14A • Group 3\n\nGate B4"),
        PassbookPass(title: "AMC Theatres", subtitle: "Stubs Premiere", detail: "2 Tickets",
                     color: Color(red: 0.75, green: 0.15, blue: 0.15),
                     backInfo: "AMC Carolina Pavilion 22\nTonight 7:30 PM\n\nTheater 8 • Rows F 5-6"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: false)
            ZStack {
                Color(red: 0.12, green: 0.12, blue: 0.14).ignoresSafeArea()
                VStack(spacing: 0) {
                    Text("Passbook")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 14).padding(.bottom, 4)
                    Text("Sunday, October 4")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .padding(.bottom, 12)
                    // Stacked passes.
                    ZStack {
                        ForEach(passes) { pass in
                            passCard(pass)
                                .offset(y: stackOffset(for: pass))
                                .scaleEffect(selected == pass.id ? 1.0 : 0.92)
                                .onTapGesture { select(pass) }
                        }
                    }
                    .frame(height: 300)
                    Spacer()
                    Button {
                        sim.open(.appstore)
                    } label: {
                        Text("App Store")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 26).padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(colors: [Color(red: 0.35, green: 0.55, blue: 0.9),
                                                              Color(red: 0.2, green: 0.38, blue: 0.72)],
                                                     startPoint: .top, endPoint: .bottom)))
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 8)
                    Text("Find apps for Passbook")
                        .font(.system(size: 12)).foregroundColor(.gray)
                        .padding(.bottom, 20)
                }
            }
        }
    }

    private func stackOffset(for pass: PassbookPass) -> CGFloat {
        guard let sel = selected else {
            let i = passes.firstIndex(where: { $0.id == pass.id }) ?? 0
            return CGFloat(i - 1) * 44
        }
        return sel == pass.id ? -40 : 120
    }

    private func select(_ pass: PassbookPass) {
        if selected == pass.id {
            // Second tap flips the card.
            flipped = (flipped == pass.id) ? nil : pass.id
        } else {
            selected = pass.id
            flipped = nil
        }
    }

    private func passCard(_ pass: PassbookPass) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(pass.color)
                .frame(width: 260, height: 150)
                .shadow(color: .black.opacity(0.5), radius: 8, y: 4)
            if flipped == pass.id {
                // Back: barcode + info.
                VStack(spacing: 6) {
                    barcode
                    Text(pass.backInfo)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(pass.title)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "qrcode")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Text(pass.subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.85))
                    Spacer()
                    Text(pass.detail)
                        .font(.system(size: 22, weight: .light))
                        .foregroundColor(.white)
                }
                .padding(14)
                .frame(width: 260, height: 150, alignment: .topLeading)
            }
        }
        .rotation3DEffect(.degrees(flipped == pass.id ? 180 : 0), axis: (0, 1, 0))
        .animation(.easeInOut(duration: 0.4), value: flipped)
        .animation(.spring(response: 0.35), value: selected)
    }

    private var barcode: some View {
        HStack(spacing: 2) {
            ForEach(0..<30, id: \.self) { i in
                Rectangle()
                    .fill(Color.white)
                    .frame(width: CGFloat([2, 1, 3, 1, 2, 4][i % 6]), height: 36)
            }
        }
        .padding(6)
        .background(Color.black.opacity(0.35))
        .cornerRadius(4)
    }
}

// MARK: - Compass

struct CompassApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var heading: Double = 32

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: false)
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Spacer()
                    // Dial.
                    ZStack {
                        Circle()
                            .fill(RadialGradient(colors: [Color(white: 0.16), Color(white: 0.05)],
                                                 center: .center, startRadius: 10, endRadius: 130))
                            .frame(width: 250, height: 250)
                        // Ticks.
                        ForEach(0..<72, id: \.self) { i in
                            Rectangle()
                                .fill(Color.white.opacity(i % 18 == 0 ? 0.9 : 0.35))
                                .frame(width: i % 18 == 0 ? 3 : 1.5, height: i % 18 == 0 ? 18 : 10)
                                .offset(y: -112)
                                .rotationEffect(.degrees(Double(i) * 5))
                        }
                        // Cardinal labels.
                        ForEach([("N", 0, Color.red), ("E", 90, Color.white),
                                 ("S", 180, Color.white), ("W", 270, Color.white)], id: \.0) { c in
                            Text(c.0)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(c.2)
                                .offset(y: -88)
                                .rotationEffect(.degrees(Double(c.1) + heading))
                        }
                        // Needle.
                        Path { p in
                            p.move(to: CGPoint(x: 0, y: -95)); p.addLine(to: CGPoint(x: 10, y: 0))
                            p.addLine(to: CGPoint(x: -10, y: 0)); p.closeSubpath()
                        }.fill(Color.red)
                        Path { p in
                            p.move(to: CGPoint(x: 0, y: 95)); p.addLine(to: CGPoint(x: 10, y: 0))
                            p.addLine(to: CGPoint(x: -10, y: 0)); p.closeSubpath()
                        }.fill(Color.white.opacity(0.85))
                        Circle().fill(Color(white: 0.2)).frame(width: 16, height: 16)
                        Circle().fill(Color.black).frame(width: 8, height: 8)
                    }
                    .rotationEffect(.degrees(-heading))
                    .gesture(
                        DragGesture()
                            .onChanged { v in
                                heading = (heading - v.translation.width * 0.4)
                                    .truncatingRemainder(dividingBy: 360)
                            }
                    )
                    Text("\(Int((360 - heading).truncatingRemainder(dividingBy: 360)))°")
                        .font(.system(size: 44, weight: .light))
                        .foregroundColor(.white)
                        .padding(.top, 18)
                    Text(directionName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text("35°13′37″ N   80°50′35″ W")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                    Text("Charlotte, NC")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Drag the dial to rotate")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .padding(.bottom, 24)
                }
            }
        }
    }

    private var directionName: String {
        let h = (360 - heading).truncatingRemainder(dividingBy: 360)
        let names = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        return names[Int((h + 22.5) / 45) % 8]
    }
}
