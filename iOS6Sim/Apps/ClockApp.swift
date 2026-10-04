import SwiftUI

/// Live clock: big analog face + digital readout, iOS 6 style.
struct ClockApp: View {
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar()
            iOS6NavBar(title: "Clock")
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 18) {
                    // Analog face.
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.white, Color(red: 0.92, green: 0.92, blue: 0.94)],
                                    center: .center, startRadius: 10, endRadius: 110))
                            .frame(width: 220, height: 220)
                            .shadow(color: .black.opacity(0.5), radius: 8)
                        // Ticks.
                        ForEach(0..<60, id: \.self) { i in
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: i % 5 == 0 ? 3 : 1,
                                       height: i % 5 == 0 ? 12 : 6)
                                .offset(y: -100)
                                .rotationEffect(.degrees(Double(i) * 6))
                        }
                        // Numbers.
                        ForEach([12, 3, 6, 9], id: \.self) { n in
                            Text("\(n)")
                                .font(.system(size: 22, weight: .bold))
                                .offset(y: -78)
                                .rotationEffect(.degrees(n == 12 ? 0 : n == 3 ? 90 : n == 6 ? 180 : 270))
                        }
                        // Hands.
                        hand(length: 62, width: 5, angle: hourAngle)
                        hand(length: 88, width: 4, angle: minuteAngle)
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 2, height: 96)
                            .offset(y: -40)
                            .rotationEffect(.degrees(secondAngle))
                        Circle().fill(Color.black).frame(width: 10, height: 10)
                    }
                    Text(digitalTime)
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                    Text(digitalDate)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
            }
        }
        .onReceive(timer) { now = $0 }
    }

    private func hand(length: CGFloat, width: CGFloat, angle: Double) -> some View {
        Rectangle()
            .fill(Color.black)
            .frame(width: width, height: length)
            .offset(y: -length / 2 + 6)
            .rotationEffect(.degrees(angle))
    }

    private var comps: DateComponents {
        Calendar.current.dateComponents([.hour, .minute, .second], from: now)
    }

    private var secondAngle: Double { Double(comps.second ?? 0) * 6 }
    private var minuteAngle: Double {
        Double(comps.minute ?? 0) * 6 + Double(comps.second ?? 0) * 0.1
    }
    private var hourAngle: Double {
        Double((comps.hour ?? 0) % 12) * 30 + Double(comps.minute ?? 0) * 0.5
    }

    private var digitalTime: String {
        let f = DateFormatter()
        f.dateFormat = "h:mm:ss"
        return f.string(from: now)
    }

    private var digitalDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d"
        return f.string(from: now)
    }
}
