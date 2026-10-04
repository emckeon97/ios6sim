import SwiftUI

/// Functional calculator in dark iOS 6 style.
struct CalculatorApp: View {
    @State private var display = "0"
    @State private var accumulator: Double?
    @State private var pendingOp: String?
    @State private var typing = false

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar()
            // Display (brushed dark).
            ZStack(alignment: .trailing) {
                LinearGradient(
                    colors: [Color(red: 0.12, green: 0.12, blue: 0.14),
                             Color(red: 0.05, green: 0.05, blue: 0.06)],
                    startPoint: .top, endPoint: .bottom)
                Text(display)
                    .font(.system(size: 52, weight: .light))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 16)
                    .padding(.top, 30)
            }
            .frame(height: 130)
            .overlay(Rectangle().fill(Color.black.opacity(0.4)).frame(height: 1),
                     alignment: .bottom)

            // Buttons.
            VStack(spacing: 1) {
                ForEach(0..<4, id: \.self) { r in
                    HStack(spacing: 1) {
                        ForEach(rows[r], id: \.self) { key in
                            CalcButton(label: key,
                                       kind: kind(of: key),
                                       action: { tap(key) })
                        }
                    }
                }
                // Bottom row: wide 0.
                HStack(spacing: 1) {
                    CalcButton(label: "0", kind: .digit, action: { tap("0") })
                        .frame(maxWidth: .infinity)
                    HStack(spacing: 1) {
                        CalcButton(label: ".", kind: .digit, action: { tap(".") })
                        CalcButton(label: "=", kind: .op, action: { tap("=") })
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color.black)
        }
        .background(Color.black)
    }

    private let rows: [[String]] = [
        ["C", "±", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "−"],
        ["1", "2", "3", "+"],
    ]

    enum Kind { case digit, op, util }

    private func kind(of key: String) -> Kind {
        if "0123456789.".contains(key) { return .digit }
        if key == "=" { return .op }
        if ["÷", "×", "−", "+"].contains(key) { return .op }
        return .util
    }

    private func tap(_ key: String) {
        switch key {
        case "0"..."9":
            if typing {
                if display == "0" { display = key }
                else if display.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "").count < 9 {
                    display += key
                }
            } else {
                display = key
                typing = true
            }
        case ".":
            if typing {
                if !display.contains(".") { display += "." }
            } else {
                display = "0."
                typing = true
            }
        case "C":
            display = "0"; accumulator = nil; pendingOp = nil; typing = false
        case "±":
            if display != "0" {
                display = display.hasPrefix("-") ? String(display.dropFirst()) : "-" + display
            }
        case "%":
            if let v = Double(display) {
                display = fmt(v / 100)
            }
        case "=":
            applyPending()
            pendingOp = nil
            accumulator = nil
            typing = false
        default: // operators
            if typing {
                applyPending()
                typing = false
            }
            accumulator = Double(display)
            pendingOp = key
        }
    }

    private func applyPending() {
        guard let op = pendingOp,
              let acc = accumulator,
              let cur = Double(display) else {
            accumulator = Double(display)
            return
        }
        let result: Double
        switch op {
        case "+": result = acc + cur
        case "−": result = acc - cur
        case "×": result = acc * cur
        case "÷": result = cur == 0 ? .nan : acc / cur
        default: result = cur
        }
        display = fmt(result)
        accumulator = result
    }

    private func fmt(_ v: Double) -> String {
        if v.isNaN || v.isInfinite { return "Error" }
        if v.truncatingRemainder(dividingBy: 1) == 0 && abs(v) < 1e9 {
            return String(Int(v))
        }
        return String(format: "%.8g", v)
    }
}

struct CalcButton: View {
    let label: String
    let kind: CalculatorApp.Kind
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: label == "0" ? 26 : 24, weight: .light))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(buttonGradient)
                .overlay(
                    Rectangle().fill(Color.white.opacity(0.06)).frame(height: 1),
                    alignment: .top)
        }
        .buttonStyle(.plain)
        .frame(height: 72)
    }

    private var buttonGradient: LinearGradient {
        switch kind {
        case .digit:
            return LinearGradient(
                colors: [Color(red: 0.32, green: 0.33, blue: 0.36),
                         Color(red: 0.18, green: 0.19, blue: 0.22)],
                startPoint: .top, endPoint: .bottom)
        case .op:
            return LinearGradient(
                colors: [Color(red: 0.95, green: 0.55, blue: 0.15),
                         Color(red: 0.85, green: 0.42, blue: 0.08)],
                startPoint: .top, endPoint: .bottom)
        case .util:
            return LinearGradient(
                colors: [Color(red: 0.22, green: 0.23, blue: 0.26),
                         Color(red: 0.10, green: 0.11, blue: 0.13)],
                startPoint: .top, endPoint: .bottom)
        }
    }
}
