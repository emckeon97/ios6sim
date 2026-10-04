import SwiftUI

struct SimReminder: Identifiable, Codable {
    var id = UUID()
    var text: String
    var done: Bool
    var created: Date
}

/// iOS 6 Reminders: simple checklist, persisted.
struct RemindersApp: View {
    @State private var items: [SimReminder] = []
    @State private var draft = ""
    @FocusState private var typing: Bool

    private let storeKey = "ios6sim.reminders"

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar(darkText: true)
            iOS6NavBar(title: "Reminders")
            ZStack {
                Color(red: 0.94, green: 0.94, blue: 0.96).ignoresSafeArea()
                VStack(spacing: 0) {
                    List {
                        ForEach($items) { $item in
                            HStack(spacing: 10) {
                                Button {
                                    item.done.toggle()
                                    save()
                                } label: {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 1.5)
                                            .frame(width: 22, height: 22)
                                        if item.done {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.orange)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                                TextField("New reminder", text: $item.text)
                                    .font(.system(size: 15))
                                    .strikethrough(item.done)
                                    .foregroundColor(item.done ? .gray : .black)
                                    .onSubmit { save() }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete { idx in
                            items.remove(atOffsets: idx)
                            save()
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)

                    // Add row.
                    HStack {
                        TextField("Add a reminder…", text: $draft)
                            .font(.system(size: 15))
                            .textFieldStyle(.roundedBorder)
                            .focused($typing)
                            .onSubmit(add)
                        Button("Add", action: add)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.blue)
                            .buttonStyle(.plain)
                            .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding(10)
                    .background(Color.white)
                    .overlay(Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1),
                             alignment: .top)
                }
            }
        }
        .onAppear(perform: load)
    }

    private func add() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        items.append(SimReminder(text: text, done: false, created: Date()))
        draft = ""
        typing = false
        save()
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: storeKey),
           let decoded = try? JSONDecoder().decode([SimReminder].self, from: data) {
            items = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: storeKey)
        }
    }
}
