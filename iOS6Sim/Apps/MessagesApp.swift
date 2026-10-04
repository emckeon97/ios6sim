import SwiftUI

/// iOS 6 Messages — shows the Mac's real iMessage/SMS threads (read-only).
/// Nothing is sent, copied, or logged; it reads chat.db live at runtime.
struct MessagesApp: View {
    @StateObject private var store = MessageStore()
    @State private var openChatID: Int64?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                iOS6StatusBar(darkText: true)
                iOS6NavBar(title: "Messages")
                ZStack {
                    Color.white.ignoresSafeArea()
                    if store.unavailableOnDevice {
                        VStack(spacing: 8) {
                            Text("Not Available on iPhone")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                            Text("iOS apps can't access your messages. Use the Mac version to see your real threads.")
                                .font(.system(size: 13))
                                .foregroundColor(.gray.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    } else if store.needsPermission {
                        permissionView
                    } else if store.conversations.isEmpty {
                        VStack(spacing: 8) {
                            Text("No Messages")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                            Text("Your synced iMessage and SMS threads will appear here.")
                                .font(.system(size: 13))
                                .foregroundColor(.gray.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    } else {
                        List {
                            ForEach(store.conversations) { convo in
                                Button {
                                    openChatID = convo.id
                                } label: {
                                    HStack(spacing: 10) {
                                        // Avatar circle with initials.
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Color(red: 0.55, green: 0.62, blue: 0.72),
                                                                 Color(red: 0.35, green: 0.42, blue: 0.55)],
                                                        startPoint: .top, endPoint: .bottom))
                                                .frame(width: 44, height: 44)
                                            Text(initials(of: convo.displayName))
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                        VStack(alignment: .leading, spacing: 3) {
                                            HStack {
                                                Text(convo.displayName)
                                                    .font(.system(size: 15, weight: .bold))
                                                    .foregroundColor(.black)
                                                    .lineLimit(1)
                                                Spacer()
                                                Text(shortDate(convo.lastDate))
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.gray)
                                            }
                                            Text(convo.lastText)
                                                .font(.system(size: 13))
                                                .foregroundColor(.gray)
                                                .lineLimit(2)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .listStyle(.plain)
                        .refreshable { store.refresh() }
                    }
                }
            }

            // Thread detail (pushed iOS-style).
            if let chatID = openChatID,
               let convo = store.conversations.first(where: { $0.id == chatID }) {
                ThreadView(conversation: convo, store: store) {
                    withAnimation(.easeInOut(duration: 0.25)) { openChatID = nil }
                }
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: openChatID)
    }

    private var permissionView: some View {
        VStack(spacing: 12) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 44))
                .foregroundColor(.gray)
            Text("Messages needs permission")
                .font(.system(size: 17, weight: .semibold))
            Text("To show your real threads, grant this app Full Disk Access once:\n\nSystem Settings → Privacy & Security → Full Disk Access → add iOS 6 Simulator.\n\nNothing is sent or copied — messages are only read on this Mac.")
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
            Button("Try Again") { store.openDatabase() }
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.blue)
                .buttonStyle(.plain)
                .padding(.top, 4)
        }
        .padding(.vertical, 40)
    }

    private func initials(of name: String) -> String {
        let parts = name.components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }

    private func shortDate(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            let f = DateFormatter()
            f.dateFormat = "h:mm a"
            return f.string(from: date)
        }
        let f = DateFormatter()
        f.dateFormat = "M/d/yy"
        return f.string(from: date)
    }
}

/// One thread: iOS 6 blue/gray bubbles, read-only.
struct ThreadView: View {
    let conversation: SimConversation
    @ObservedObject var store: MessageStore
    var onBack: () -> Void
    @State private var messages: [SimChatMessage] = []

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            iOS6NavBar(
                title: "",
                left: AnyView(iOS6BackButton(label: "Messages", action: onBack)),
                right: AnyView(
                    Text(conversation.displayName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .frame(maxWidth: 170)
                )
            )
            ZStack {
                Color.white.ignoresSafeArea()
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 6) {
                            ForEach(messages) { msg in
                                BubbleRow(message: msg)
                                    .id(msg.id)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                    }
                    .onAppear {
                        messages = store.messages(for: conversation.id)
                        if let last = messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            // Read-only composer bar.
            HStack {
                Text("Read-only — sending isn't supported")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(red: 0.96, green: 0.96, blue: 0.97))
            .overlay(Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1),
                     alignment: .top)
        }
    }
}

struct BubbleRow: View {
    let message: SimChatMessage

    var body: some View {
        HStack {
            if message.isFromMe { Spacer(minLength: 40) }
            Text(message.text)
                .font(.system(size: 15))
                .foregroundColor(message.isFromMe ? .white : .black)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    message.isFromMe
                        ? LinearGradient(
                            colors: [Color(red: 0.25, green: 0.55, blue: 0.95),
                                     Color(red: 0.10, green: 0.38, blue: 0.85)],
                            startPoint: .top, endPoint: .bottom)
                        : LinearGradient(
                            colors: [Color(red: 0.92, green: 0.92, blue: 0.94),
                                     Color(red: 0.80, green: 0.81, blue: 0.84)],
                            startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(14)
            if !message.isFromMe { Spacer(minLength: 40) }
        }
    }
}
