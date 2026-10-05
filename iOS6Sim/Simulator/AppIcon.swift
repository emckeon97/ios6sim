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
        default: return app.rawValue
        }
    }

    var body: some View {
        ZStack {
            if let name = assetName {
                iconArtImage(named: name)
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

    /// Loads icon artwork from the IconArt folder reference, stripping the
    /// embedded Display P3 color profile (the exports were tagged P3, which
    /// iOS honors — crushing the colors; the pixel values are sRGB).
    private func iconArtImage(named name: String) -> Image {
        if let url = Bundle.main.url(forResource: "icon-\(name)", withExtension: "png", subdirectory: "IconArt/icon-\(name).imageset"),
           let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: stripICCP(from: data)) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "app")
    }

    /// Removes the iCCP chunk from PNG data so iOS treats it as sRGB.
    private func stripICCP(from data: Data) -> Data {
        guard data.count > 8,
              data[0] == 0x89, data[1] == 0x50, data[2] == 0x4E, data[3] == 0x47,
              data[4] == 0x0D, data[5] == 0x0A, data[6] == 0x1A, data[7] == 0x0A else {
            return data
        }
        var out = Data(data.prefix(8))
        var i = 8
        while i + 12 <= data.count {
            let len = (Int(data[i]) << 24) | (Int(data[i+1]) << 16) | (Int(data[i+2]) << 8) | Int(data[i+3])
            guard len >= 0, i + 12 + len <= data.count else { break }
            let t0 = data[i+4], t1 = data[i+5], t2 = data[i+6], t3 = data[i+7]
            let isICCP = t0 == 0x69 && t1 == 0x43 && t2 == 0x43 && t3 == 0x50
            let isIEND = t0 == 0x49 && t1 == 0x45 && t2 == 0x4E && t3 == 0x44
            if !isICCP {
                out.append(contentsOf: data[i..<(i+12+len)])
            }
            i += 12 + len
            if isIEND { break }
        }
        return out.count > 8 ? out : data
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
