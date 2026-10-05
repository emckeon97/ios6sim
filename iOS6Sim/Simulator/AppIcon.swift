import SwiftUI

/// iOS 6 app icon: real artwork from iOS6Icons.xcassets, clipped to the
/// iOS 6 squircle. The exports already carry Apple's gloss, so no extra
/// shine is drawn. evasi0n/cydia keep hand-drawn glyphs (custom icons).
/// WinterBoard washes the artwork dark and flat; Icon Tint overlays a color.
struct iOS6Icon: View {
    let app: AppID
    var size: CGFloat = 60
    var themed: Bool = false
    var tint: Color? = nil

    /// Asset catalog name, or nil for the hand-drawn custom icons.
    private var assetName: String? {
        switch app {
        case .evasi0n, .cydia: return nil
        default: return "icon-\(app.rawValue)"
        }
    }

    var body: some View {
        ZStack {
            if let name = assetName {
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .saturation(1.08)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: size * 0.22, style: .continuous))
                RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.18), Color.white.opacity(0.02)], startPoint: .top, endPoint: .center))
                    .mask(RoundedRectangle(cornerRadius: size * 0.22, style: .continuous).fill(LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .center)))
                if themed {
                    RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                        .fill(Color(red: 0.10, green: 0.11, blue: 0.14).opacity(0.55))
                }
            } else {
                RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                    .fill(drawnGradient)
                drawnGlyph
                RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.35), Color.white.opacity(0.05)], startPoint: .top, endPoint: .center))
                    .mask(RoundedRectangle(cornerRadius: size * 0.22, style: .continuous).fill(LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .center)))
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

    private var drawnGradient: LinearGradient {
        switch app {
        case .evasi0n:
            return LinearGradient(colors: [Color.white, Color(red: 0.88, green: 0.88, blue: 0.90)], startPoint: .top, endPoint: .bottom)
        case .cydia:
            return LinearGradient(colors: [Color(red: 0.62, green: 0.52, blue: 0.42), Color(red: 0.42, green: 0.33, blue: 0.24)], startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(colors: [Color.gray], startPoint: .top, endPoint: .bottom)
        }
    }

    @ViewBuilder
    private var drawnGlyph: some View {
        switch app {
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
        default:
            EmptyView()
        }
    }
}
