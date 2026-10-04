import SwiftUI

/// Classic iOS 6 status bar: carrier, signal, time, battery.
struct iOS6StatusBar: View {
    var darkText = false

    var body: some View {
        HStack(spacing: 4) {
            // Signal bars.
            HStack(alignment: .bottom, spacing: 1.5) {
                ForEach(0..<5, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 0.5)
                        .fill(barColor)
                        .frame(width: 3, height: 4 + CGFloat(i) * 2.5)
                }
            }
            Text("Carrier")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(barColor)

            Spacer()

            Text(currentTime)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(barColor)

            Spacer()

            // Battery.
            HStack(spacing: 1.5) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(barColor, lineWidth: 1)
                        .frame(width: 22, height: 10)
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.green)
                        .frame(width: 16, height: 6)
                        .padding(.leading, 2)
                }
                RoundedRectangle(cornerRadius: 1)
                    .fill(barColor)
                    .frame(width: 2, height: 5)
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 20)
        .background(
            darkText
                ? Color.clear
                : LinearGradient(
                    colors: [Color.black.opacity(0.25), Color.clear],
                    startPoint: .top, endPoint: .bottom)
        )
    }

    private var barColor: Color { darkText ? .black : .white }

    private var currentTime: String {
        let f = DateFormatter()
        f.dateFormat = "h:mm"
        return f.string(from: Date())
    }
}
