import SwiftUI

// MARK: - Shared iOS 6 UI kit

extension Color {
    /// Init from "RRGGBB" hex (used by custom tweak tints).
    init?(hex: String) {
        let h = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        guard h.count == 6, let v = UInt64(h, radix: 16) else { return nil }
        self.init(red: Double((v >> 16) & 0xFF) / 255,
                  green: Double((v >> 8) & 0xFF) / 255,
                  blue: Double(v & 0xFF) / 255)
    }
}

/// The classic iOS 6 blue ON/OFF toggle switch.
struct iOS6Toggle: View {
    @Binding var isOn: Bool

    var body: some View {
        Button(action: { withAnimation(.easeInOut(duration: 0.2)) { isOn.toggle() } }) {
            ZStack(alignment: isOn ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isOn
                        ? LinearGradient(colors: [Color(red: 0.15, green: 0.45, blue: 0.90),
                                                  Color(red: 0.30, green: 0.60, blue: 1.0)],
                                         startPoint: .top, endPoint: .bottom)
                        : LinearGradient(colors: [Color(white: 0.75), Color(white: 0.90)],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: 52, height: 28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.black.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 1, y: 1)
                // Knob
                Circle()
                    .fill(LinearGradient(colors: [.white, Color(white: 0.85)],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: 24, height: 24)
                    .shadow(color: .black.opacity(0.3), radius: 1.5, y: 1)
                    .padding(2)
            }
        }
        .buttonStyle(.plain)
    }
}

/// The iOS 6 blue gradient bottom tab bar.
struct iOS6TabBar: View {
    let tabs: [(icon: String, title: String)]
    @Binding var selection: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { i in
                Button(action: { selection = i }) {
                    VStack(spacing: 2) {
                        Image(systemName: tabs[i].icon)
                            .font(.system(size: 20))
                        Text(tabs[i].title)
                            .font(.system(size: 10))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .foregroundColor(selection == i ? .white : Color.white.opacity(0.55))
                    .background(
                        selection == i
                            ? LinearGradient(colors: [Color(red: 0.25, green: 0.45, blue: 0.75),
                                                      Color(red: 0.15, green: 0.30, blue: 0.60)],
                                             startPoint: .top, endPoint: .bottom)
                            : nil
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .background(
            LinearGradient(colors: [Color(red: 0.45, green: 0.52, blue: 0.62),
                                    Color(red: 0.25, green: 0.30, blue: 0.40)],
                           startPoint: .top, endPoint: .bottom)
        )
        .overlay(Rectangle().fill(Color.black.opacity(0.4)).frame(height: 1), alignment: .top)
    }
}

/// iOS 6 blue segmented control.
struct iOS6Segmented<Value: Hashable>: View {
    let options: [(Value, String)]
    @Binding var selection: Value

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { i in
                let (value, title) = options[i]
                Button(action: { selection = value }) {
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(selection == value ? .white : Color(red: 0.25, green: 0.45, blue: 0.85))
                        .padding(.vertical, 7)
                        .padding(.horizontal, 14)
                        .background(
                            selection == value
                                ? LinearGradient(colors: [Color(red: 0.25, green: 0.50, blue: 0.90),
                                                          Color(red: 0.15, green: 0.35, blue: 0.75)],
                                                 startPoint: .top, endPoint: .bottom)
                                : LinearGradient(colors: [Color.clear],
                                                 startPoint: .top, endPoint: .bottom)
                        )
                }
                .buttonStyle(.plain)
                if i < options.count - 1 {
                    Rectangle().fill(Color(red: 0.25, green: 0.45, blue: 0.85).opacity(0.5)).frame(width: 1)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(red: 0.25, green: 0.45, blue: 0.85), lineWidth: 1.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

/// iOS 6 blue "‹ Back" button lives in DeviceFrame.swift; use that one.

/// A grouped-table section header in iOS 6 style.
struct iOS6SectionHeader: View {
    let title: String
    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(Color(red: 0.45, green: 0.50, blue: 0.60))
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 4)
    }
}

/// One row in a grouped iOS 6 table.
struct iOS6Row<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
    }
}

/// A full grouped section with rounded corners.
struct iOS6Section<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.12), lineWidth: 1))
        .padding(.horizontal, 10)
    }
}
