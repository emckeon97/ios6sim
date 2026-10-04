import SwiftUI

// MARK: - Shared helpers (prefixed S3 to avoid collisions)

private enum S3BuyState {
    case price, confirm, bought
}

private struct S3PriceButton: View {
    let price: String
    @State private var state: S3BuyState = .price

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                switch state {
                case .price: state = .confirm
                case .confirm: state = .bought
                case .bought: break
                }
            }
        } label: {
            Group {
                switch state {
                case .price:
                    Text(price)
                case .confirm:
                    Text("BUY")
                case .bought:
                    Image(systemName: "checkmark")
                }
            }
            .font(.system(size: 13, weight: .bold))
            .foregroundColor(state == .bought ? Color(red: 0.15, green: 0.55, blue: 0.15) : .white)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(state == .bought
                          ? Color(white: 0.92)
                          : LinearGradient(colors: [Color(red: 0.35, green: 0.60, blue: 0.95),
                                                    Color(red: 0.15, green: 0.40, blue: 0.80)],
                                           startPoint: .top, endPoint: .bottom))
                    .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(state == .bought ? Color.gray.opacity(0.4)
                                                : Color(red: 0.10, green: 0.28, blue: 0.60), lineWidth: 1))
            )
            .shadow(color: .black.opacity(0.2), radius: 1, y: 1)
        }
        .buttonStyle(.plain)
    }
}

// ============================================================================
// MARK: - 1. Newsstand
// ============================================================================

private struct S3Magazine: Identifiable {
    let id = UUID()
    let title: String
    let tagline: String
    let colors: [Color]
    let titleColor: Color
    let accent: Color
    let articleHeadline: String
    let articleBody: String
}

private let s3Magazines: [S3Magazine] = [
    S3Magazine(title: "WIRED", tagline: "The Future Issue",
               colors: [Color(red: 0.10, green: 0.10, blue: 0.12), Color(red: 0.25, green: 0.25, blue: 0.30)],
               titleColor: .white, accent: Color(red: 0.95, green: 0.30, blue: 0.20),
               articleHeadline: "The Gadget That Thinks",
               articleBody: "Inside the lab where tomorrow's phones are born. Engineers show us the prototype that could replace the smartphone entirely — a device with no screen at all."),
    S3Magazine(title: "NATIONAL GEOGRAPHIC", tagline: "Wild Earth",
               colors: [Color(red: 0.20, green: 0.45, blue: 0.75), Color(red: 0.10, green: 0.25, blue: 0.50)],
               titleColor: .white, accent: .yellow,
               articleHeadline: "Last of the Wild",
               articleBody: "Photographers spent 400 days tracking the rarest big cats on Earth. These never-before-seen images reveal a world disappearing faster than we imagined."),
    S3Magazine(title: "TIME", tagline: "Person of the Year",
               colors: [Color(red: 0.85, green: 0.85, blue: 0.88), Color(red: 0.65, green: 0.65, blue: 0.70)],
               titleColor: Color(red: 0.80, green: 0.10, blue: 0.10), accent: Color(red: 0.80, green: 0.10, blue: 0.10),
               articleHeadline: "The Year in Review",
               articleBody: "From breakthroughs in medicine to upheaval on the world stage — the twelve months that changed everything, and the people who defined them."),
    S3Magazine(title: "ESPN", tagline: "The Magazine",
               colors: [Color(red: 0.75, green: 0.08, blue: 0.08), Color(red: 0.35, green: 0.03, blue: 0.03)],
               titleColor: .white, accent: .white,
               articleHeadline: "The Comeback Season",
               articleBody: "Written off in September. Champions in February. How one locker room's belief carried a team from worst to first in the most improbable season ever."),
    S3Magazine(title: "VOGUE", tagline: "September Issue",
               colors: [Color(red: 0.95, green: 0.93, blue: 0.90), Color(red: 0.80, green: 0.78, blue: 0.75)],
               titleColor: .black, accent: .black,
               articleHeadline: "The New Classics",
               articleBody: "Designers return to clean lines and timeless tailoring. This fall's essential pieces — and how to wear them from runway to real life."),
    S3Magazine(title: "POPULAR SCIENCE", tagline: "Best of What's New",
               colors: [Color(red: 0.10, green: 0.35, blue: 0.70), Color(red: 0.05, green: 0.18, blue: 0.45)],
               titleColor: .white, accent: Color(red: 1.0, green: 0.55, blue: 0.10),
               articleHeadline: "100 Innovations of the Year",
               articleBody: "From a car that drives itself to a printer that builds organs — the inventions that will reshape how we live, work, and play."),
]

private struct S3MagazineCover: View {
    let mag: S3Magazine
    var width: CGFloat = 92

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(LinearGradient(colors: mag.colors, startPoint: .top, endPoint: .bottom))
            // Spine highlight.
            HStack {
                Rectangle().fill(Color.black.opacity(0.25)).frame(width: 5)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(mag.title)
                    .font(.system(size: width * 0.13, weight: .heavy, design: .serif))
                    .foregroundColor(mag.titleColor)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                Spacer()
                // Image-ish shape.
                RoundedRectangle(cornerRadius: 2)
                    .fill(mag.accent.opacity(0.55))
                    .frame(height: width * 0.55)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: width * 0.18))
                    )
                Text(mag.tagline)
                    .font(.system(size: width * 0.09, weight: .bold))
                    .foregroundColor(mag.titleColor.opacity(0.85))
                    .lineLimit(1)
            }
            .padding(8)
            // Gloss.
            RoundedRectangle(cornerRadius: 3)
                .fill(LinearGradient(colors: [.white.opacity(0.30), .white.opacity(0.02)],
                                     startPoint: .top, endPoint: .center))
                .mask(RoundedRectangle(cornerRadius: 3)
                    .fill(LinearGradient(colors: [.black, .clear],
                                         startPoint: .top, endPoint: .center)))
        }
        .frame(width: width, height: width * 1.42)
        .shadow(color: .black.opacity(0.5), radius: 3, y: 3)
    }
}

private struct S3ShelfPlank: View {
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(LinearGradient(colors: [Color(red: 0.42, green: 0.26, blue: 0.13),
                                              Color(red: 0.30, green: 0.17, blue: 0.07)],
                                     startPoint: .top, endPoint: .bottom))
                .frame(height: 14)
            Rectangle().fill(Color.white.opacity(0.25)).frame(height: 2)
        }
        .shadow(color: .black.opacity(0.5), radius: 2, y: 2)
    }
}

private struct S3MagazineReader: View {
    let mag: S3Magazine
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            iOS6NavBar(
                title: mag.title.capitalized,
                left: AnyView(iOS6BackButton(label: "Newsstand", action: onBack))
            )
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Spacer()
                        S3MagazineCover(mag: mag, width: 150)
                        Spacer()
                    }
                    .padding(.top, 16)
                    Text(mag.articleHeadline)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .padding(.horizontal, 18)
                    Rectangle().fill(Color.gray.opacity(0.4)).frame(height: 1)
                        .padding(.horizontal, 18)
                    Text(mag.articleBody)
                        .font(.system(size: 15, design: .serif))
                        .lineSpacing(5)
                        .padding(.horizontal, 18)
                    Text("Continued on page 42. This month's issue also features our annual gear guide, a photo essay from the far north, and an exclusive interview you won't want to miss.")
                        .font(.system(size: 15, design: .serif))
                        .lineSpacing(5)
                        .padding(.horizontal, 18)
                        .padding(.bottom, 30)
                }
            }
            .background(Color(red: 0.98, green: 0.97, blue: 0.94))
        }
    }
}

struct NewsstandApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var openMagazine: S3Magazine?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                iOS6StatusBar(darkText: false)
                iOS6NavBar(
                    title: "Newsstand",
                    right: AnyView(
                        Button("Store") {}
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(LinearGradient(colors: [Color(red: 0.35, green: 0.50, blue: 0.70),
                                                                  Color(red: 0.20, green: 0.32, blue: 0.52)],
                                                         startPoint: .top, endPoint: .bottom))
                            .buttonStyle(.plain)
                    )
                ))
                ZStack {
                    // Wooden bookshelf background.
                    LinearGradient(colors: [Color(red: 0.36, green: 0.21, blue: 0.10),
                                            Color(red: 0.24, green: 0.13, blue: 0.05)],
                                   startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    VStack(spacing: 2) {
                        ForEach(0..<6, id: \.self) { _ in
                            Rectangle().fill(Color.black.opacity(0.12)).frame(height: 1)
                            Spacer().frame(height: 26)
                        }
                    }
                    ScrollView {
                        VStack(spacing: 0) {
                            shelf(mags: Array(s3Magazines[0..<3]))
                            shelf(mags: Array(s3Magazines[3..<6]))
                            Spacer(minLength: 40)
                        }
                        .padding(.top, 18)
                    }
                }
            }
            if let mag = openMagazine {
                S3MagazineReader(mag: mag) {
                    withAnimation(.easeInOut(duration: 0.25)) { openMagazine = nil }
                }
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: openMagazine?.id)
    }

    private func shelf(mags: [S3Magazine]) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ForEach(mags) { mag in
                    Button { openMagazine = mag } label: {
                        S3MagazineCover(mag: mag)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
            S3ShelfPlank()
                .padding(.top, 2)
                .padding(.bottom, 26)
        }
    }
}

// ============================================================================
// MARK: - 2. iTunes Store
// ============================================================================

private struct S3Song: Identifiable {
    let id = UUID()
    let rank: Int
    let title: String
    let artist: String
}

private let s3TopSongs: [S3Song] = [
    S3Song(rank: 1, title: "Call Me Maybe", artist: "Carly Rae Jepsen"),
    S3Song(rank: 2, title: "Somebody That I Used to Know", artist: "Gotye"),
    S3Song(rank: 3, title: "We Are Young", artist: "fun."),
    S3Song(rank: 4, title: "Whistle", artist: "Flo Rida"),
    S3Song(rank: 5, title: "Lights", artist: "Ellie Goulding"),
    S3Song(rank: 6, title: "Wild Ones", artist: "Flo Rida"),
    S3Song(rank: 7, title: "Stronger (What Doesn't Kill You)", artist: "Kelly Clarkson"),
    S3Song(rank: 8, title: "Payphone", artist: "Maroon 5"),
]

private struct S3Movie: Identifiable {
    let id = UUID()
    let title: String
    let year: String
    let colors: [Color]
}

private let s3Movies: [S3Movie] = [
    S3Movie(title: "The Avengers", year: "2012",
            colors: [Color(red: 0.15, green: 0.25, blue: 0.55), Color(red: 0.05, green: 0.08, blue: 0.25)]),
    S3Movie(title: "The Dark Knight Rises", year: "2012",
            colors: [Color(red: 0.10, green: 0.10, blue: 0.12), Color(red: 0.30, green: 0.28, blue: 0.25)]),
    S3Movie(title: "The Hunger Games", year: "2012",
            colors: [Color(red: 0.55, green: 0.15, blue: 0.05), Color(red: 0.20, green: 0.05, blue: 0.02)]),
    S3Movie(title: "Brave", year: "2012",
            colors: [Color(red: 0.10, green: 0.40, blue: 0.35), Color(red: 0.03, green: 0.15, blue: 0.12)]),
]

private struct S3Show: Identifiable {
    let id = UUID()
    let title: String
    let network: String
}

private let s3Shows: [S3Show] = [
    S3Show(title: "Breaking Bad", network: "AMC"),
    S3Show(title: "Game of Thrones", network: "HBO"),
    S3Show(title: "The Walking Dead", network: "AMC"),
    S3Show(title: "Modern Family", network: "ABC"),
]

struct iTunesApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var tab = 0
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            iOS6NavBar(title: tabTitle)
            ZStack {
                Color.white.ignoresSafeArea()
                switch tab {
                case 0: musicTab
                case 1: moviesTab
                case 2: tvTab
                case 3: searchTab
                default: moreTab
                }
            }
            iOS6TabBar(tabs: [("music.note", "Music"), ("film", "Movies"),
                              ("tv", "TV Shows"), ("magnifyingglass", "Search"),
                              ("ellipsis", "More")],
                       selection: $tab)
        }
    }

    private var tabTitle: String {
        ["iTunes", "Movies", "TV Shows", "Search", "More"][tab]
    }

    // -- Music: Top Songs chart --
    private var musicTab: some View {
        ScrollView {
            VStack(spacing: 0) {
                iOS6SectionHeader(title: "Top Songs")
                iOS6Section {
                    ForEach(s3TopSongs) { song in
                        VStack(spacing: 0) {
                            HStack(spacing: 10) {
                                Text("\(song.rank)")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.gray)
                                    .frame(width: 22)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(song.title)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.black)
                                    Text(song.artist)
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                S3PriceButton(price: "$1.29")
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            if song.id != s3TopSongs.last?.id {
                                Divider().padding(.leading, 46)
                            }
                        }
                    }
                }
                Spacer(minLength: 30)
            }
        }
        .background(Color(red: 0.93, green: 0.93, blue: 0.96))
    }

    // -- Movies --
    private var moviesTab: some View {
        ScrollView {
            VStack(spacing: 0) {
                iOS6SectionHeader(title: "Top Movies")
                iOS6Section {
                    ForEach(s3Movies) { movie in
                        VStack(spacing: 0) {
                            HStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(LinearGradient(colors: movie.colors,
                                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .frame(width: 52, height: 76)
                                    Text(String(movie.title.prefix(1)))
                                        .font(.system(size: 24, weight: .heavy))
                                        .foregroundColor(.white.opacity(0.85))
                                }
                                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(movie.title)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.black)
                                    Text(movie.year)
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                S3PriceButton(price: "$14.99")
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            if movie.id != s3Movies.last?.id {
                                Divider().padding(.leading, 78)
                            }
                        }
                    }
                }
                Spacer(minLength: 30)
            }
        }
        .background(Color(red: 0.93, green: 0.93, blue: 0.96))
    }

    // -- TV Shows --
    private var tvTab: some View {
        ScrollView {
            VStack(spacing: 0) {
                iOS6SectionHeader(title: "Top TV Episodes")
                iOS6Section {
                    ForEach(s3Shows) { show in
                        VStack(spacing: 0) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(show.title)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.black)
                                    Text(show.network)
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                S3PriceButton(price: "$1.99")
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            if show.id != s3Shows.last?.id {
                                Divider().padding(.leading, 14)
                            }
                        }
                    }
                }
                Spacer(minLength: 30)
            }
        }
        .background(Color(red: 0.93, green: 0.93, blue: 0.96))
    }

    // -- Search --
    private var searchTab: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search Store", text: $searchText)
                    .font(.system(size: 15))
            }
            .padding(8)
            .background(Color(white: 0.94))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(12)
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .foregroundColor(Color.gray.opacity(0.35))
            Text("No Results")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.gray)
                .padding(.top, 8)
            Spacer()
        }
    }

    // -- More --
    private var moreTab: some View {
        ScrollView {
            VStack(spacing: 0) {
                iOS6SectionHeader(title: "Browse")
                iOS6Section {
                    ForEach(["Ringtones", "Audiobooks", "iTunes U", "Podcasts"], id: \.self) { item in
                        VStack(spacing: 0) {
                            HStack {
                                Text(item)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(red: 0.20, green: 0.35, blue: 0.70))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 11)
                            if item != "Podcasts" { Divider().padding(.leading, 14) }
                        }
                    }
                }
                Spacer(minLength: 30)
            }
        }
        .background(Color(red: 0.93, green: 0.93, blue: 0.96))
    }
}

// ============================================================================
// MARK: - 3. App Store
// ============================================================================

private struct S3StoreApp: Identifiable {
    let id = UUID()
    let rank: Int?
    let name: String
    let category: String
    let price: String
    let colors: [Color]
    let letter: String
}

private let s3FeaturedApps: [S3StoreApp] = [
    S3StoreApp(rank: nil, name: "Temple Run", category: "Games", price: "FREE",
               colors: [Color(red: 0.95, green: 0.55, blue: 0.10), Color(red: 0.70, green: 0.30, blue: 0.05)], letter: "TR"),
    S3StoreApp(rank: nil, name: "Instagram", category: "Social Networking", price: "FREE",
               colors: [Color(red: 0.55, green: 0.40, blue: 0.30), Color(red: 0.35, green: 0.22, blue: 0.15)], letter: "IG"),
    S3StoreApp(rank: nil, name: "Angry Birds Space", category: "Games", price: "$0.99",
               colors: [Color(red: 0.85, green: 0.20, blue: 0.15), Color(red: 0.55, green: 0.08, blue: 0.08)], letter: "AB"),
    S3StoreApp(rank: nil, name: "Evernote", category: "Productivity", price: "FREE",
               colors: [Color(red: 0.30, green: 0.65, blue: 0.25), Color(red: 0.15, green: 0.40, blue: 0.12)], letter: "Ev"),
]

private let s3Top25: [S3StoreApp] = [
    S3StoreApp(rank: 1, name: "Temple Run", category: "Games", price: "FREE",
               colors: [Color(red: 0.95, green: 0.55, blue: 0.10), Color(red: 0.70, green: 0.30, blue: 0.05)], letter: "TR"),
    S3StoreApp(rank: 2, name: "Facebook", category: "Social Networking", price: "FREE",
               colors: [Color(red: 0.25, green: 0.40, blue: 0.75), Color(red: 0.12, green: 0.22, blue: 0.55)], letter: "f"),
    S3StoreApp(rank: 3, name: "Angry Birds Space", category: "Games", price: "$0.99",
               colors: [Color(red: 0.85, green: 0.20, blue: 0.15), Color(red: 0.55, green: 0.08, blue: 0.08)], letter: "AB"),
    S3StoreApp(rank: 4, name: "Draw Something", category: "Games", price: "FREE",
               colors: [Color(red: 0.95, green: 0.75, blue: 0.20), Color(red: 0.75, green: 0.50, blue: 0.05)], letter: "DS"),
    S3StoreApp(rank: 5, name: "Pandora Radio", category: "Music", price: "FREE",
               colors: [Color(red: 0.20, green: 0.35, blue: 0.65), Color(red: 0.08, green: 0.15, blue: 0.40)], letter: "P"),
    S3StoreApp(rank: 6, name: "Instagram", category: "Social Networking", price: "FREE",
               colors: [Color(red: 0.55, green: 0.40, blue: 0.30), Color(red: 0.35, green: 0.22, blue: 0.15)], letter: "IG"),
    S3StoreApp(rank: 7, name: "Fruit Ninja", category: "Games", price: "$0.99",
               colors: [Color(red: 0.30, green: 0.60, blue: 0.20), Color(red: 0.12, green: 0.35, blue: 0.08)], letter: "FN"),
    S3StoreApp(rank: 8, name: "The Weather Channel", category: "Weather", price: "FREE",
               colors: [Color(red: 0.15, green: 0.45, blue: 0.85), Color(red: 0.05, green: 0.25, blue: 0.60)], letter: "W"),
    S3StoreApp(rank: 9, name: "Tiny Wings", category: "Games", price: "$0.99",
               colors: [Color(red: 0.95, green: 0.80, blue: 0.30), Color(red: 0.80, green: 0.55, blue: 0.10)], letter: "TW"),
    S3StoreApp(rank: 10, name: "Words With Friends", category: "Games", price: "FREE",
               colors: [Color(red: 0.85, green: 0.30, blue: 0.45), Color(red: 0.60, green: 0.12, blue: 0.25)], letter: "WW"),
]

private struct S3AppIcon: View {
    let app: S3StoreApp
    var size: CGFloat = 52

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .fill(LinearGradient(colors: app.colors, startPoint: .top, endPoint: .bottom))
            Text(app.letter)
                .font(.system(size: size * 0.38, weight: .heavy))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .fill(LinearGradient(colors: [.white.opacity(0.35), .white.opacity(0.03)],
                                     startPoint: .top, endPoint: .center))
                .mask(RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                    .fill(LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .center)))
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .stroke(Color.black.opacity(0.25), lineWidth: 1)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.25), radius: 2, y: 1)
    }
}

private struct S3AppRow: View {
    let app: S3StoreApp
    var showRank: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            if showRank, let rank = app.rank {
                Text("\(rank)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.gray)
                    .frame(width: 22)
            }
            S3AppIcon(app: app)
            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                Text(app.category)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            Spacer()
            S3PriceButton(price: app.price == "FREE" ? "FREE" : app.price)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }
}

struct AppStoreApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var tab = 0
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            iOS6NavBar(title: tabTitle)
            ZStack {
                Color.white.ignoresSafeArea()
                switch tab {
                case 0: featuredTab
                case 1: geniusTab
                case 2: top25Tab
                case 3: searchTab
                default: updatesTab
                }
            }
            iOS6TabBar(tabs: [("star", "Featured"), ("sparkles", "Genius"),
                              ("list.number", "Top 25"), ("magnifyingglass", "Search"),
                              ("arrow.down.circle", "Updates")],
                       selection: $tab)
        }
    }

    private var tabTitle: String {
        ["App Store", "Genius", "Top 25", "Search", "Updates"][tab]
    }

    // -- Featured --
    private var featuredTab: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Banner cards.
                VStack(spacing: 10) {
                    banner(title: "App of the Week", subtitle: "Editor's Choice",
                           colors: [Color(red: 0.35, green: 0.30, blue: 0.75), Color(red: 0.15, green: 0.12, blue: 0.45)])
                    banner(title: "New Games We Love", subtitle: "Handpicked by our editors",
                           colors: [Color(red: 0.95, green: 0.45, blue: 0.10), Color(red: 0.70, green: 0.20, blue: 0.05)])
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
                iOS6SectionHeader(title: "New and Noteworthy")
                iOS6Section {
                    ForEach(s3FeaturedApps) { app in
                        VStack(spacing: 0) {
                            S3AppRow(app: app)
                            if app.id != s3FeaturedApps.last?.id {
                                Divider().padding(.leading, 76)
                            }
                        }
                    }
                }
                Spacer(minLength: 30)
            }
        }
        .background(Color(red: 0.93, green: 0.93, blue: 0.96))
    }

    private func banner(title: String, subtitle: String, colors: [Color]) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 92)
            VStack(alignment: .leading, spacing: 3) {
                Text(subtitle.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
                Text(title)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
            }
            .padding(.leading, 14)
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(colors: [.white.opacity(0.25), .clear],
                                     startPoint: .top, endPoint: .center))
        }
        .shadow(color: .black.opacity(0.25), radius: 3, y: 2)
    }

    // -- Genius --
    private var geniusTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.system(size: 44))
                    .foregroundColor(Color(red: 0.30, green: 0.45, blue: 0.80).opacity(0.6))
                    .padding(.top, 60)
                Text("Genius Recommendations")
                    .font(.system(size: 17, weight: .bold))
                Text("Based on apps you own, here are a few we think you'll love.")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                iOS6Section {
                    ForEach(Array(s3FeaturedApps.prefix(2))) { app in
                        VStack(spacing: 0) {
                            S3AppRow(app: app)
                            if app.id != s3FeaturedApps[1].id {
                                Divider().padding(.leading, 76)
                            }
                        }
                    }
                }
            }
        }
        .background(Color(red: 0.93, green: 0.93, blue: 0.96))
    }

    // -- Top 25 --
    private var top25Tab: some View {
        ScrollView {
            VStack(spacing: 0) {
                iOS6SectionHeader(title: "Top Paid & Free")
                iOS6Section {
                    ForEach(s3Top25) { app in
                        VStack(spacing: 0) {
                            S3AppRow(app: app, showRank: true)
                            if app.id != s3Top25.last?.id {
                                Divider().padding(.leading, 76)
                            }
                        }
                    }
                }
                Spacer(minLength: 30)
            }
        }
        .background(Color(red: 0.93, green: 0.93, blue: 0.96))
    }

    // -- Search --
    private var searchTab: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search App Store", text: $searchText)
                    .font(.system(size: 15))
            }
            .padding(8)
            .background(Color(white: 0.94))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(12)
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .foregroundColor(Color.gray.opacity(0.35))
            Text("No Results")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.gray)
                .padding(.top, 8)
            Spacer()
        }
    }

    // -- Updates --
    private var updatesTab: some View {
        VStack(spacing: 12) {
            Spacer()
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color(red: 0.35, green: 0.70, blue: 0.35),
                                                  Color(red: 0.15, green: 0.50, blue: 0.15)],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: 64, height: 64)
                Image(systemName: "checkmark")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            .shadow(color: .black.opacity(0.25), radius: 3, y: 2)
            Text("All apps are up to date.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.93, green: 0.93, blue: 0.96))
    }
}

// ============================================================================
// MARK: - 4. Game Center
// ============================================================================

private struct S3GCFriend: Identifiable {
    let id = UUID()
    let name: String
    let online: Bool
    let status: String
}

private let s3GCFriends: [S3GCFriend] = [
    S3GCFriend(name: "Alex", online: true, status: "Playing Fruit Ninja"),
    S3GCFriend(name: "Sam", online: true, status: "In Game Center"),
    S3GCFriend(name: "Jordan", online: false, status: "Last played 2 days ago"),
]

private struct S3GCGame: Identifiable {
    let id = UUID()
    let name: String
    let achievements: Int
    let colors: [Color]
}

private let s3GCGames: [S3GCGame] = [
    S3GCGame(name: "Angry Birds", achievements: 45,
             colors: [Color(red: 0.85, green: 0.20, blue: 0.15), Color(red: 0.55, green: 0.08, blue: 0.08)]),
    S3GCGame(name: "Fruit Ninja", achievements: 28,
             colors: [Color(red: 0.30, green: 0.60, blue: 0.20), Color(red: 0.12, green: 0.35, blue: 0.08)]),
    S3GCGame(name: "Tiny Wings", achievements: 12,
             colors: [Color(red: 0.95, green: 0.80, blue: 0.30), Color(red: 0.80, green: 0.55, blue: 0.10)]),
    S3GCGame(name: "Real Racing 2", achievements: 60,
             colors: [Color(red: 0.20, green: 0.30, blue: 0.60), Color(red: 0.08, green: 0.12, blue: 0.35)]),
]

struct GameCenterApp: View {
    @EnvironmentObject var sim: SimulatorState

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: false)
            // Wood-framed header.
            ZStack {
                LinearGradient(colors: [Color(red: 0.42, green: 0.27, blue: 0.14),
                                        Color(red: 0.30, green: 0.18, blue: 0.08)],
                               startPoint: .top, endPoint: .bottom)
                Text("Game Center")
                    .font(.system(size: 20, weight: .heavy, design: .serif))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 2, y: 2)
            }
            .frame(height: 52)
            .overlay(Rectangle().fill(Color.black.opacity(0.4)).frame(height: 1), alignment: .bottom)
            ZStack {
                feltBackground
                ScrollView {
                    VStack(spacing: 14) {
                        // Me card.
                        gcCard {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(RadialGradient(colors: [.white, Color(white: 0.75)],
                                                             center: .center, startRadius: 5, endRadius: 30))
                                        .frame(width: 52, height: 52)
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 26))
                                        .foregroundColor(Color(red: 0.25, green: 0.45, blue: 0.25))
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Player1")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("0 Points  •  0 Achievements")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                Spacer()
                                Circle()
                                    .fill(Color(red: 0.25, green: 0.80, blue: 0.25))
                                    .frame(width: 10, height: 10)
                                    .shadow(color: .green, radius: 3)
                            }
                            .padding(12)
                        }
                        gcSectionTitle("Friends")
                        gcCard {
                            VStack(spacing: 0) {
                                ForEach(s3GCFriends) { friend in
                                    VStack(spacing: 0) {
                                        HStack(spacing: 10) {
                                            Circle()
                                                .fill(friend.online ? Color(red: 0.25, green: 0.80, blue: 0.25)
                                                                    : Color.gray.opacity(0.6))
                                                .frame(width: 10, height: 10)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(friend.name)
                                                    .font(.system(size: 15, weight: .bold))
                                                    .foregroundColor(.white)
                                                Text(friend.status)
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.white.opacity(0.65))
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 10)
                                        if friend.id != s3GCFriends.last?.id {
                                            Divider().background(Color.white.opacity(0.15))
                                        }
                                    }
                                }
                            }
                        }
                        gcSectionTitle("Games")
                        gcCard {
                            VStack(spacing: 0) {
                                ForEach(s3GCGames) { game in
                                    VStack(spacing: 0) {
                                        HStack(spacing: 12) {
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(LinearGradient(colors: game.colors,
                                                                     startPoint: .top, endPoint: .bottom))
                                                .frame(width: 44, height: 44)
                                                .overlay(
                                                    Text(String(game.name.prefix(1)))
                                                        .font(.system(size: 20, weight: .heavy))
                                                        .foregroundColor(.white.opacity(0.9))
                                                )
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(game.name)
                                                    .font(.system(size: 15, weight: .bold))
                                                    .foregroundColor(.white)
                                                Text("\(game.achievements) Achievements")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.white.opacity(0.65))
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 9)
                                        if game.id != s3GCGames.last?.id {
                                            Divider().background(Color.white.opacity(0.15))
                                        }
                                    }
                                }
                            }
                        }
                        Spacer(minLength: 30)
                    }
                    .padding(.top, 14)
                    .padding(.horizontal, 12)
                }
            }
        }
    }

    private var feltBackground: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.06, green: 0.36, blue: 0.16),
                                    Color(red: 0.02, green: 0.20, blue: 0.08)],
                           startPoint: .top, endPoint: .bottom)
            // Subtle noise via scattered translucent specks.
            VStack(spacing: 14) {
                ForEach(0..<24, id: \.self) { row in
                    HStack(spacing: 18) {
                        ForEach(0..<14, id: \.self) { col in
                            Circle()
                                .fill(Color.white.opacity(((row * 7 + col * 13) % 5 == 0) ? 0.05 : 0.015))
                                .frame(width: 2, height: 2)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }

    private func gcCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.10))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1))
            )
            .shadow(color: .black.opacity(0.3), radius: 3, y: 2)
    }

    private func gcSectionTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.white.opacity(0.75))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 4)
            .padding(.top, 4)
    }
}

// ============================================================================
// MARK: - 5. YouTube
// ============================================================================

private struct S3Video: Identifiable {
    let id = UUID()
    let title: String
    let views: String
    let age: String
    let duration: Int // seconds
    let colors: [Color]
}

private let s3Videos: [S3Video] = [
    S3Video(title: "iPhone 5 Official Trailer — Apple", views: "12,438,902", age: "2 weeks ago", duration: 134,
            colors: [Color(red: 0.10, green: 0.12, blue: 0.16), Color(red: 0.25, green: 0.28, blue: 0.34)]),
    S3Video(title: "PSY — GANGNAM STYLE (Official M/V)", views: "800,123,456", age: "3 months ago", duration: 253,
            colors: [Color(red: 0.50, green: 0.20, blue: 0.55), Color(red: 0.25, green: 0.08, blue: 0.30)]),
    S3Video(title: "Funny Cats Compilation 2012", views: "45,231,009", age: "1 month ago", duration: 602,
            colors: [Color(red: 0.55, green: 0.40, blue: 0.20), Color(red: 0.30, green: 0.20, blue: 0.08)]),
    S3Video(title: "NASA Curiosity Rover Landing — Full Video", views: "8,112,334", age: "1 month ago", duration: 227,
            colors: [Color(red: 0.08, green: 0.15, blue: 0.35), Color(red: 0.02, green: 0.05, blue: 0.18)]),
    S3Video(title: "Minecraft: How to Build a Castle (Tutorial)", views: "3,908,112", age: "5 days ago", duration: 920,
            colors: [Color(red: 0.15, green: 0.45, blue: 0.20), Color(red: 0.05, green: 0.22, blue: 0.08)]),
    S3Video(title: "Epic Fails of 2012 — Best Fails", views: "22,540,781", age: "2 months ago", duration: 511,
            colors: [Color(red: 0.60, green: 0.25, blue: 0.10), Color(red: 0.30, green: 0.10, blue: 0.03)]),
]

private func s3FormatDuration(_ seconds: Int) -> String {
    String(format: "%d:%02d", seconds / 60, seconds % 60)
}

private struct S3Thumbnail: View {
    let video: S3Video
    var width: CGFloat = 104

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(LinearGradient(colors: video.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: width, height: width * 0.66)
            // Red YouTube-ish bar.
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(red: 0.80, green: 0.10, blue: 0.10))
                .frame(width: width * 0.44, height: width * 0.30)
            Path { p in
                let w = width * 0.44, h = width * 0.30
                p.move(to: CGPoint(x: -w * 0.18, y: -h * 0.28))
                p.addLine(to: CGPoint(x: w * 0.28, y: 0))
                p.addLine(to: CGPoint(x: -w * 0.18, y: h * 0.28))
                p.closeSubpath()
            }
            .fill(Color.white)
            // Duration badge.
            Text(s3FormatDuration(video.duration))
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 4).padding(.vertical, 2)
                .background(Color.black.opacity(0.75))
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .frame(width: width, height: width * 0.66, alignment: .bottomTrailing)
                .padding(3)
        }
    }
}

private struct S3VideoPlayer: View {
    let video: S3Video
    var onBack: () -> Void
    @State private var isPlaying = false
    @State private var progress: Double = 0 // seconds
    private let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            iOS6NavBar(
                title: "YouTube",
                left: AnyView(iOS6BackButton(label: "Back", action: onBack))
            )
            // Player area.
            ZStack {
                Color.black
                S3Thumbnail(video: video, width: 200)
                    .opacity(0.85)
                if !isPlaying {
                    ZStack {
                        Circle().fill(Color.black.opacity(0.55)).frame(width: 64, height: 64)
                        Image(systemName: "play.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                            .offset(x: 2)
                    }
                }
            }
            .frame(height: 200)
            .onTapGesture { isPlaying.toggle() }
            VStack(alignment: .leading, spacing: 8) {
                Text(video.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                Text("\(video.views) views")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                // Progress bar.
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Color(white: 0.85)).frame(height: 6)
                        Rectangle()
                            .fill(Color(red: 0.85, green: 0.10, blue: 0.10))
                            .frame(width: geo.size.width * CGFloat(min(progress / Double(video.duration), 1.0)),
                                   height: 6)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                }
                .frame(height: 6)
                HStack {
                    Text(s3FormatDuration(Int(progress)))
                    Spacer()
                    Text(s3FormatDuration(video.duration))
                }
                .font(.system(size: 11))
                .foregroundColor(.gray)
                // Controls.
                HStack {
                    Spacer()
                    Button { isPlaying.toggle() } label: {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color(red: 0.45, green: 0.60, blue: 0.78),
                                                              Color(red: 0.28, green: 0.42, blue: 0.62)],
                                                     startPoint: .top, endPoint: .bottom))
                                .frame(width: 52, height: 52)
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .offset(x: isPlaying ? 0 : 2)
                        }
                        .shadow(color: .black.opacity(0.3), radius: 3, y: 2)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                .padding(.top, 6)
                Spacer()
            }
            .padding(14)
            .background(Color.white)
        }
        .onReceive(timer) { _ in
            guard isPlaying else { return }
            progress += 0.25
            if progress >= Double(video.duration) {
                progress = Double(video.duration)
                isPlaying = false
            }
        }
    }
}

struct YouTubeApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var tab = 0
    @State private var playingVideo: S3Video?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                iOS6StatusBar(darkText: true)
                iOS6NavBar(title: "YouTube")
                ZStack {
                    Color.white.ignoresSafeArea()
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(videoList) { video in
                                Button { playingVideo = video } label: {
                                    HStack(spacing: 10) {
                                        S3Thumbnail(video: video)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(video.title)
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(.black)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                            Text("\(video.views) views • \(video.age)")
                                                .font(.system(size: 11))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                }
                                .buttonStyle(.plain)
                                if video.id != videoList.last?.id {
                                    Divider().padding(.leading, 124)
                                }
                            }
                            Spacer(minLength: 20)
                        }
                        .padding(.top, 6)
                    }
                }
                iOS6TabBar(tabs: [("play.rectangle", "Featured"), ("star", "Top Rated"),
                                  ("eye", "Most Viewed"), ("heart", "Favorites"),
                                  ("person.2", "Subscriptions")],
                           selection: $tab)
            }
            if let video = playingVideo {
                S3VideoPlayer(video: video) {
                    withAnimation(.easeInOut(duration: 0.25)) { playingVideo = nil }
                }
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: playingVideo?.id)
    }

    private var videoList: [S3Video] {
        switch tab {
        case 1: return s3Videos.sorted { $0.views > $1.views }
        case 2: return Array(s3Videos.reversed())
        default: return s3Videos
        }
    }
}
