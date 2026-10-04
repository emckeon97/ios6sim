import SwiftUI
import Combine

// MARK: - Phone

struct PhoneApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var tab = 3 // Keypad, like the real thing defaults to... actually Recents; use Keypad
    @State private var number = ""
    @State private var calling: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            if tab == 0 { favoritesView }
            else if tab == 1 { recentsView }
            else if tab == 2 { contactsView }
            else if tab == 3 { keypadView }
            else { voicemailView }
            iOS6TabBar(tabs: [
                (icon: "star.fill", title: "Favorites"),
                (icon: "clock.fill", title: "Recents"),
                (icon: "person.fill", title: "Contacts"),
                (icon: "circle.grid.3x3.fill", title: "Keypad"),
                (icon: "voicemail", title: "Voicemail"),
            ], selection: $tab)
        }
        .background(Color(white: 0.96))
    }

    // MARK: Keypad
    private var keypadView: some View {
        VStack(spacing: 0) {
            iOS6NavBar(title: "")
            Text(number.isEmpty ? " " : formattedNumber)
                .font(.system(size: 34, weight: .light))
                .foregroundColor(.black)
                .frame(height: 60)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            if calling != nil {
                Text("calling \(calling!)…")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.bottom, 4)
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 18), count: 3), spacing: 14) {
                ForEach(phoneKeys, id: \.digit) { key in
                    Button { number.append(key.digit) } label: {
                        VStack(spacing: 0) {
                            Text(key.digit)
                                .font(.system(size: 30, weight: .light))
                            Text(key.letters)
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.gray)
                        }
                        .foregroundColor(.black)
                        .frame(width: 72, height: 72)
                        .background(
                            Circle()
                                .fill(LinearGradient(colors: [.white, Color(white: 0.88)],
                                                     startPoint: .top, endPoint: .bottom))
                                .shadow(color: .black.opacity(0.15), radius: 2, y: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 28)
            Button {
                if !number.isEmpty {
                    calling = formattedNumber
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        calling = nil; number = ""
                    }
                }
            } label: {
                Image(systemName: "phone.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
                    .background(
                        Circle().fill(LinearGradient(
                            colors: [Color(red: 0.45, green: 0.85, blue: 0.35),
                                     Color(red: 0.20, green: 0.60, blue: 0.15)],
                            startPoint: .top, endPoint: .bottom)))
                    .shadow(color: .black.opacity(0.2), radius: 2, y: 2)
            }
            .buttonStyle(.plain)
            .padding(.top, 14)
            Spacer()
        }
    }

    private var phoneKeys: [(digit: String, letters: String)] {
        [("1",""),("2","ABC"),("3","DEF"),("4","GHI"),("5","JKL"),
         ("6","MNO"),("7","PQRS"),("8","TUV"),("9","WXYZ"),("*",""),("0","+"),("#","")]
    }

    private var formattedNumber: String { number }

    // MARK: Recents
    @State private var recentsScope = 0
    private let recents: [(name: String, label: String, time: String, missed: Bool)] = [
        ("Mom", "mobile", "9:41 AM", false),
        ("(704) 555-0142", "unknown", "Yesterday", true),
        ("Dad", "home", "Yesterday", false),
        ("SecTek Dispatch", "work", "Tuesday", false),
        ("(980) 555-0119", "unknown", "Tuesday", true),
        ("Mowgli", "mobile", "Monday", false),
    ]

    private var recentsView: some View {
        VStack(spacing: 0) {
            iOS6NavBar(title: "Recents")
            Picker("", selection: $recentsScope) {
                Text("All").tag(0); Text("Missed").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(8)
            .background(Color(white: 0.92))
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(recents.filter { recentsScope == 0 || $0.missed }.indices, id: \.self) { i in
                        let r = recents.filter { recentsScope == 0 || $0.missed }[i]
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(r.name)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(r.missed ? .red : .black)
                                Text("\(r.label)  •  \(r.time)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "phone.fill")
                                .foregroundColor(Color(red: 0.25, green: 0.45, blue: 0.85))
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        Divider().padding(.leading, 14)
                    }
                }
                .background(Color.white)
            }
        }
    }

    // MARK: Favorites / Contacts / Voicemail
    private var favoritesView: some View {
        VStack(spacing: 0) {
            iOS6NavBar(title: "Favorites",
                right: AnyView(Text("+").font(.system(size: 24)).foregroundColor(.white).padding(8)))
            ScrollView {
                VStack(spacing: 0) {
                    ForEach([("Mom", "mobile"), ("Dad", "home"), ("Mowgli", "mobile")], id: \.0) { f in
                        HStack {
                            Image(systemName: "star.fill").foregroundColor(.gray).font(.system(size: 13))
                            VStack(alignment: .leading) {
                                Text(f.0).font(.system(size: 16, weight: .bold))
                                Text(f.1).font(.system(size: 12)).foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "phone.fill")
                                .foregroundColor(Color(red: 0.25, green: 0.45, blue: 0.85))
                        }
                        .padding(.horizontal, 14).padding(.vertical, 12)
                        Divider().padding(.leading, 14)
                    }
                }.background(Color.white)
            }
        }
    }

    private var contactsView: some View {
        VStack(spacing: 0) {
            iOS6NavBar(title: "Contacts")
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(["Dad", "Kevin", "Mom", "Mowgli", "SecTek Dispatch"], id: \.self) { name in
                        HStack {
                            Text(name).font(.system(size: 16))
                            Spacer()
                        }
                        .padding(.horizontal, 14).padding(.vertical, 12)
                        Divider().padding(.leading, 14)
                    }
                }.background(Color.white)
            }
        }
    }

    private var voicemailView: some View {
        VStack(spacing: 0) {
            iOS6NavBar(title: "Voicemail")
            ScrollView {
                VStack(spacing: 0) {
                    ForEach([("Mom", "9:41 AM", "0:42"), ("(704) 555-0142", "Yesterday", "1:07")], id: \.0) { v in
                        HStack {
                            Button {} label: {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(Color(red: 0.25, green: 0.45, blue: 0.85))
                            }.buttonStyle(.plain)
                            VStack(alignment: .leading) {
                                Text(v.0).font(.system(size: 15, weight: .bold))
                                Text("\(v.1)  •  \(v.2)").font(.system(size: 12)).foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        Divider().padding(.leading, 14)
                    }
                }.background(Color.white)
            }
            Spacer()
            Text("Visual Voicemail").font(.system(size: 12)).foregroundColor(.gray).padding(8)
        }
    }
}

// MARK: - Mail

struct MailMessage: Identifiable {
    let id = UUID()
    let from: String, subject: String, preview: String, date: String
    var unread: Bool
    let body: String
}

struct MailApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var view: Int = 0 // 0 mailboxes, 1 inbox, 2 message
    @State private var vipOnly = false
    @State private var openMessage: MailMessage? = nil
    @State private var messages: [MailMessage] = [
        MailMessage(from: "Apple", subject: "Your receipt from Apple",
                    preview: "Dear Customer, thank you for your purchase…",
                    date: "9:41 AM", unread: true,
                    body: "Dear Customer,\n\nThank you for your purchase from the iTunes Store.\n\nOrder total: $1.29\n\nThanks for shopping with Apple."),
        MailMessage(from: "SecTek Scheduling", subject: "Shift reminder — tonight 11p–7a",
                    preview: "This is a reminder of your scheduled shift…",
                    date: "8:15 AM", unread: true,
                    body: "Hi Elijah,\n\nThis is a reminder of your scheduled shift tonight, 11:00 PM – 7:00 AM.\n\nPlease arrive 15 minutes early.\n\n— SecTek Scheduling"),
        MailMessage(from: "Mom", subject: "Sunday dinner",
                    preview: "Are you coming over Sunday? Making pot roast…",
                    date: "Yesterday", unread: false,
                    body: "Hi honey,\n\nAre you coming over Sunday? I'm making pot roast.\n\nLove,\nMom"),
        MailMessage(from: "LinkedIn", subject: "You have 3 new profile views",
                    preview: "See who's viewed your profile…",
                    date: "Friday", unread: false,
                    body: "You have 3 new profile views this week.\n\nUpgrade to Premium to see all of them."),
    ]

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            if view == 0 { mailboxesView }
            else if view == 1 { inboxView }
            else if let m = openMessage { messageView(m) }
        }
        .background(Color(white: 0.96))
    }

    private var mailboxesView: some View {
        VStack(spacing: 0) {
            iOS6NavBar(title: "Mailboxes",
                right: AnyView(Text("Edit").font(.system(size: 14, weight: .bold)).foregroundColor(.white).padding(8)))
            ScrollView {
                VStack(spacing: 0) {
                    mailboxRow(icon: "tray.fill", name: "Inbox", count: messages.filter(\.unread).count) { vipOnly = false; view = 1 }
                    mailboxRow(icon: "star.fill", name: "VIP", count: 1) { vipOnly = true; view = 1 }
                    mailboxRow(icon: "doc.fill", name: "Drafts", count: 0) {}
                    mailboxRow(icon: "paperplane.fill", name: "Sent", count: 0) {}
                    mailboxRow(icon: "trash.fill", name: "Trash", count: 0) {}
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(10)
            }
        }
    }

    private func mailboxRow(icon: String, name: String, count: Int, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(red: 0.25, green: 0.45, blue: 0.85))
                    .frame(width: 28)
                Text(name).font(.system(size: 16))
                Spacer()
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8).padding(.vertical, 2)
                        .background(Capsule().fill(Color.gray))
                }
                Image(systemName: "chevron.right").font(.system(size: 13)).foregroundColor(.gray)
            }
            .padding(.horizontal, 12).padding(.vertical, 11)
        }.buttonStyle(.plain)
    }

    private var inboxView: some View {
        let shown = vipOnly ? messages.filter { $0.from == "Mom" } : messages
        return VStack(spacing: 0) {
            iOS6NavBar(title: vipOnly ? "VIP" : "Inbox",
                left: AnyView(iOS6BackButton(label: "Mailboxes") { vipOnly = false; view = 0 }),
                right: AnyView(Text("Edit").font(.system(size: 14, weight: .bold)).foregroundColor(.white).padding(8)))
            Text("Updated Just Now")
                .font(.system(size: 12)).foregroundColor(.gray)
                .frame(maxWidth: .infinity).padding(.vertical, 6)
                .background(Color(white: 0.92))
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(shown) { m in
                        Button {
                            openMessage = m; view = 2
                            if let i = messages.firstIndex(where: { $0.id == m.id }) {
                                messages[i].unread = false
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(m.unread ? Color(red: 0.25, green: 0.45, blue: 0.85) : Color.clear)
                                    .frame(width: 8, height: 8)
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text(m.from).font(.system(size: 15, weight: .bold))
                                        Spacer()
                                        Text(m.date).font(.system(size: 12)).foregroundColor(.gray)
                                    }
                                    Text(m.subject).font(.system(size: 14)).foregroundColor(.black)
                                    Text(m.preview).font(.system(size: 13)).foregroundColor(.gray).lineLimit(1)
                                }
                            }
                            .padding(.horizontal, 10).padding(.vertical, 9)
                        }.buttonStyle(.plain)
                        Divider().padding(.leading, 26)
                    }
                }.background(Color.white)
            }
        }
    }

    private func messageView(_ m: MailMessage) -> some View {
        VStack(spacing: 0) {
            iOS6NavBar(title: m.subject,
                left: AnyView(iOS6BackButton(label: "Inbox") { view = 1 }))
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    Text(m.from).font(.system(size: 15, weight: .bold))
                    Text("To: me@icloud.com").font(.system(size: 13)).foregroundColor(.gray)
                    Text(m.date).font(.system(size: 13)).foregroundColor(.gray)
                    Divider().padding(.vertical, 6)
                    Text(m.body).font(.system(size: 15)).lineSpacing(4)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
            }
        }
    }
}

// MARK: - Safari

struct SafariApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var urlText = ""
    @State private var showingBookmarks = false
    @State private var page: SafariPage = .start
    @State private var history: [String] = []

    enum SafariPage: Equatable {
        case start, bookmarks, page(title: String, url: String)
    }

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            // iOS 6: separate address bar + Google search field.
            HStack(spacing: 6) {
                HStack {
                    Image(systemName: "lock.fill").font(.system(size: 10)).foregroundColor(.gray)
                    TextField("Search or enter website", text: $urlText)
                        .font(.system(size: 13))
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit { go() }
                }
                .padding(.horizontal, 8).padding(.vertical, 7)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.2))))
                Button("Go") { go() }
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(red: 0.25, green: 0.45, blue: 0.85))
            }
            .padding(.horizontal, 8).padding(.vertical, 6)
            .background(LinearGradient(colors: [Color(red: 0.55, green: 0.62, blue: 0.72),
                                                Color(red: 0.42, green: 0.50, blue: 0.62)],
                                       startPoint: .top, endPoint: .bottom))
            // Page content.
            Group {
                switch page {
                case .start: startPage
                case .bookmarks: bookmarksList
                case .page(let title, let url): webPage(title: title, url: url)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Bottom toolbar.
            HStack {
                toolbarButton("chevron.left") {}
                toolbarButton("chevron.right") {}
                Spacer()
                toolbarButton("book.fill") { page = .bookmarks }
                toolbarButton("square.on.square") {}
                toolbarButton("square.and.arrow.up") {}
            }
            .padding(.horizontal, 20).padding(.vertical, 8)
            .background(LinearGradient(colors: [Color(red: 0.55, green: 0.62, blue: 0.72),
                                                Color(red: 0.35, green: 0.42, blue: 0.54)],
                                       startPoint: .top, endPoint: .bottom))
        }
        .background(Color.white)
    }

    private func toolbarButton(_ icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon).font(.system(size: 20)).foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
        }.buttonStyle(.plain)
    }

    private func go() {
        let raw = urlText.trimmingCharacters(in: .whitespaces)
        guard !raw.isEmpty else { return }
        var host = raw.lowercased()
        if host.hasPrefix("http://") { host = String(host.dropFirst(7)) }
        if host.hasPrefix("https://") { host = String(host.dropFirst(8)) }
        if host.hasPrefix("www.") { host = String(host.dropFirst(4)) }
        host = host.components(separatedBy: "/").first ?? host
        let title = bookmarkTitle(for: host) ?? host.capitalized
        history.append(host)
        page = .page(title: title, url: host)
    }

    private func bookmarkTitle(for host: String) -> String? {
        if host.contains("apple") { return "Apple" }
        if host.contains("google") { return "Google" }
        if host.contains("wikipedia") { return "Wikipedia" }
        if host.contains("youtube") { return "YouTube" }
        return nil
    }

    private var startPage: some View {
        ScrollView {
            Text("Favorites")
                .font(.system(size: 17, weight: .bold))
                .padding(.top, 18)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 18) {
                ForEach([("Apple", "apple.com", "applelogo"),
                         ("Google", "google.com", "magnifyingglass"),
                         ("Wikipedia", "wikipedia.org", "book.fill"),
                         ("YouTube", "youtube.com", "play.rectangle.fill")], id: \.1) { b in
                    Button {
                        urlText = b.1
                        page = .page(title: b.0, url: b.1)
                        history.append(b.1)
                    } label: {
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(colors: [.white, Color(white: 0.9)],
                                                     startPoint: .top, endPoint: .bottom))
                                .frame(width: 52, height: 52)
                                .overlay(Image(systemName: b.2).font(.system(size: 22))
                                    .foregroundColor(Color(red: 0.3, green: 0.45, blue: 0.7)))
                                .shadow(color: .black.opacity(0.15), radius: 2, y: 2)
                            Text(b.0).font(.system(size: 11)).foregroundColor(.black)
                        }
                    }.buttonStyle(.plain)
                }
            }
            .padding(18)
        }
        .background(Color(white: 0.96))
    }

    private var bookmarksList: some View {
        VStack(spacing: 0) {
            Text("Bookmarks").font(.system(size: 17, weight: .bold)).padding(.vertical, 10)
            ForEach([("Apple", "apple.com"), ("Google", "google.com"),
                     ("Wikipedia", "wikipedia.org"), ("YouTube", "youtube.com")], id: \.1) { b in
                Button {
                    urlText = b.1; page = .page(title: b.0, url: b.1); history.append(b.1)
                } label: {
                    HStack {
                        Image(systemName: "book.fill").foregroundColor(.gray)
                        Text(b.0).font(.system(size: 15)).foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal, 14).padding(.vertical, 11)
                }.buttonStyle(.plain)
                Divider().padding(.leading, 14)
            }
            if !history.isEmpty {
                Text("History").font(.system(size: 13, weight: .bold)).foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading).padding(10)
                ForEach(history.reversed(), id: \.self) { h in
                    Text(h).font(.system(size: 14)).foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 14).padding(.vertical, 8)
                }
            }
            Text("Reading List").font(.system(size: 13, weight: .bold)).foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading).padding(10)
            ForEach([("The iOS 6 Review", "AnandTech"), ("Panorama Tips", "Macworld")], id: \.0) { a in
                Button {
                    page = .page(title: a.0, url: "readinglist")
                } label: {
                    HStack {
                        Image(systemName: "book.closed.fill").foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text(a.0).font(.system(size: 14)).foregroundColor(.black)
                            Text(a.1).font(.system(size: 12)).foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 14).padding(.vertical, 9)
                }.buttonStyle(.plain)
                Divider().padding(.leading, 14)
            }
            Spacer()
        }
        .background(Color.white)
    }

    private func webPage(title: String, url: String) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                Text(url).font(.system(size: 13)).foregroundColor(.green)
                Divider()
                Text("Welcome to \(title).")
                    .font(.system(size: 15))
                ForEach(0..<3, id: \.self) { i in
                    Text(["About", "Products", "Contact"][i])
                        .font(.system(size: 15))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.9))
                        .padding(.vertical, 4)
                }
                RoundedRectangle(cornerRadius: 6)
                    .fill(LinearGradient(colors: [Color(red: 0.7, green: 0.8, blue: 0.95),
                                                  Color(red: 0.5, green: 0.65, blue: 0.9)],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(height: 120)
                    .overlay(Text("Advertisement").font(.system(size: 11)).foregroundColor(.gray))
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. This is a simulated page rendered inside the iOS 6 simulator.")
                    .font(.system(size: 14)).foregroundColor(Color(white: 0.3))
                    .lineSpacing(4)
            }
            .padding(14)
        }
        .background(Color.white)
    }
}

// MARK: - Music

struct Song: Identifiable {
    let id = UUID()
    let title: String, artist: String, album: String
    let duration: Double
    let hue: Double
}

let demoSongs: [Song] = [
    Song(title: "The Entertainer", artist: "Kevin MacLeod", album: "Ragtime", duration: 184, hue: 0.08),
    Song(title: "Blue Skies", artist: "Ella Fitzgerald", album: "Jazz Classics", duration: 212, hue: 0.58),
    Song(title: "Take Five", artist: "Dave Brubeck", album: "Time Out", duration: 324, hue: 0.35),
    Song(title: "Respect", artist: "Aretha Franklin", album: "Soul Gold", duration: 147, hue: 0.0),
    Song(title: "Bohemian Rhapsody", artist: "Queen", album: "A Night at the Opera", duration: 355, hue: 0.75),
    Song(title: "Superstition", artist: "Stevie Wonder", album: "Talking Book", duration: 268, hue: 0.13),
]

struct MusicApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var tab = 2
    @State private var nowPlaying: Song? = nil
    @State private var isPlaying = false
    @State private var progress: Double = 0
    @State private var volume: Double = 0.7

    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            if let song = nowPlaying {
                nowPlayingView(song)
            } else {
                songListView
            }
            iOS6TabBar(tabs: [
                (icon: "music.note.list", title: "Playlists"),
                (icon: "person.2.fill", title: "Artists"),
                (icon: "music.note", title: "Songs"),
                (icon: "square.stack.fill", title: "Albums"),
                (icon: "ellipsis", title: "More"),
            ], selection: $tab)
        }
        .background(Color.white)
        .onReceive(timer) { _ in
            if isPlaying, let song = nowPlaying {
                progress += 0.5
                if progress >= song.duration { playNext() }
            }
        }
    }

    private var songListView: some View {
        VStack(spacing: 0) {
            iOS6NavBar(title: tabTitle)
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(demoSongs) { song in
                        Button {
                            nowPlaying = song; progress = 0; isPlaying = true
                        } label: {
                            HStack {
                                albumThumb(song, size: 40)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(song.title).font(.system(size: 15, weight: .bold)).foregroundColor(.black)
                                    Text("\(song.artist) — \(song.album)")
                                        .font(.system(size: 13)).foregroundColor(.gray).lineLimit(1)
                                }
                                Spacer()
                                Text(timeString(song.duration)).font(.system(size: 13)).foregroundColor(.gray)
                            }
                            .padding(.horizontal, 10).padding(.vertical, 8)
                        }.buttonStyle(.plain)
                        Divider().padding(.leading, 60)
                    }
                }
            }
        }
    }

    private var tabTitle: String {
        ["Playlists", "Artists", "Songs", "Albums", "More"][tab]
    }

    private func nowPlayingView(_ song: Song) -> some View {
        VStack(spacing: 0) {
            iOS6NavBar(title: "Now Playing",
                left: AnyView(iOS6BackButton(label: "Songs") { nowPlaying = nil; isPlaying = false }),
                right: AnyView(Text("").frame(width: 60)))
            Spacer()
            albumThumb(song, size: 170)
                .shadow(color: .black.opacity(0.4), radius: 8, y: 4)
            Text(song.title).font(.system(size: 17, weight: .bold)).padding(.top, 16)
            Text("\(song.artist) — \(song.album)").font(.system(size: 14)).foregroundColor(.gray)
            // Scrubber.
            VStack(spacing: 2) {
                Slider(value: $progress, in: 0...song.duration)
                    .tint(Color(red: 0.25, green: 0.45, blue: 0.85))
                HStack {
                    Text(timeString(progress)).font(.system(size: 11)).foregroundColor(.gray)
                    Spacer()
                    Text(timeString(song.duration)).font(.system(size: 11)).foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20).padding(.top, 14)
            // Controls.
            HStack(spacing: 44) {
                Button { playPrev() } label: {
                    Image(systemName: "backward.fill").font(.system(size: 30))
                }.buttonStyle(.plain)
                Button { isPlaying.toggle() } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 40))
                }.buttonStyle(.plain)
                Button { playNext() } label: {
                    Image(systemName: "forward.fill").font(.system(size: 30))
                }.buttonStyle(.plain)
            }
            .foregroundColor(.black)
            .padding(.top, 18)
            // Volume.
            HStack {
                Image(systemName: "speaker.fill").font(.system(size: 12)).foregroundColor(.gray)
                Slider(value: $volume).tint(Color(red: 0.25, green: 0.45, blue: 0.85))
                Image(systemName: "speaker.wave.3.fill").font(.system(size: 12)).foregroundColor(.gray)
            }
            .padding(.horizontal, 20).padding(.top, 16)
            Spacer()
        }
        .background(
            LinearGradient(colors: [.white, Color(white: 0.93)], startPoint: .top, endPoint: .bottom))
    }

    private func albumThumb(_ song: Song, size: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: size * 0.08)
            .fill(LinearGradient(colors: [Color(hue: song.hue, saturation: 0.6, brightness: 0.85),
                                          Color(hue: song.hue, saturation: 0.7, brightness: 0.55)],
                                 startPoint: .top, endPoint: .bottom))
            .frame(width: size, height: size)
            .overlay(Image(systemName: "music.note").font(.system(size: size * 0.4)).foregroundColor(.white.opacity(0.85)))
    }

    private func playNext() {
        guard let song = nowPlaying,
              let i = demoSongs.firstIndex(where: { $0.id == song.id }) else { return }
        let next = demoSongs[(i + 1) % demoSongs.count]
        nowPlaying = next; progress = 0
    }

    private func playPrev() {
        guard let song = nowPlaying,
              let i = demoSongs.firstIndex(where: { $0.id == song.id }) else { return }
        let prev = demoSongs[(i - 1 + demoSongs.count) % demoSongs.count]
        nowPlaying = prev; progress = 0
    }

    private func timeString(_ t: Double) -> String {
        let m = Int(t) / 60, s = Int(t) % 60
        return String(format: "%d:%02d", m, s)
    }
}
