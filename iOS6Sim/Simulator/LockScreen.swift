import SwiftUI

/// iOS 6 lock screen: big thin clock, date, and the classic slide-to-unlock.
struct LockScreen: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var dragX: CGFloat = 0
    @State private var shimmer = false

    // Screen is 320 wide; slider track insets.
    private let trackWidth: CGFloat = 280
    private let knobWidth: CGFloat = 62

    var body: some View {
        ZStack {
            Wallpapers.view(index: sim.wallpaperIndex)
                .ignoresSafeArea()

            VStack {
                iOS6StatusBar()
                Spacer().frame(height: 36)

                // Big thin time.
                Text(lockTime)
                    .font(.system(size: 76, weight: .ultraLight))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 4, y: 2)
                Text(lockDate)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.4), radius: 3, y: 1)

                Spacer()

                // Slide to unlock.
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.35))
                        .frame(width: trackWidth, height: 52)
                    // Shimmering label.
                    Text("slide to unlock")
                        .font(.system(size: 21, weight: .medium))
                        .foregroundColor(.white)
                        .opacity(0.9)
                        .frame(width: trackWidth, height: 52)
                        .mask(
                            LinearGradient(
                                colors: [.clear, .black, .clear],
                                startPoint: .leading, endPoint: .trailing)
                        )
                        .offset(x: shimmer ? 60 : -60)
                        .animation(
                            .easeInOut(duration: 2.2).repeatForever(autoreverses: true),
                            value: shimmer)
                        .onAppear { shimmer = true }
                    // Knob.
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.85, green: 0.87, blue: 0.90),
                                             Color(red: 0.55, green: 0.58, blue: 0.62)],
                                    startPoint: .top, endPoint: .bottom))
                            .frame(width: knobWidth, height: 44)
                            .shadow(color: .black.opacity(0.4), radius: 3, y: 1)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.35, green: 0.37, blue: 0.40))
                    }
                    .offset(x: 4 + dragX)
                    .gesture(
                        DragGesture()
                            .onChanged { g in
                                dragX = min(max(0, g.translation.width),
                                           trackWidth - knobWidth - 8)
                            }
                            .onEnded { _ in
                                if dragX >= trackWidth - knobWidth - 24 {
                                    sim.unlock()
                                }
                                withAnimation(.spring(response: 0.3)) { dragX = 0 }
                            }
                    )
                }
                .padding(.bottom, 28)
            }
        }
    }

    private var lockTime: String {
        let f = DateFormatter()
        f.dateFormat = "h:mm"
        return f.string(from: Date())
    }

    private var lockDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d"
        return f.string(from: Date())
    }
}
