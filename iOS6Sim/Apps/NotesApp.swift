import SwiftUI

struct SimNote: Identifiable, Codable {
    var id = UUID()
    var text: String
    var modified: Date
}

/// iOS 6 Notes: yellow legal pad, persisted to UserDefaults.
struct NotesApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var notes: [SimNote] = []
    @State private var openNoteID: UUID?

    private let storeKey = "ios6sim.notes"

    var body: some View {
        ZStack {
            // List.
            VStack(spacing: 0) {
                iOS6StatusBar(darkText: true)
                iOS6NavBar(
                    title: "Notes",
                    right: AnyView(
                        Button {
                            let n = SimNote(text: "", modified: Date())
                            notes.insert(n, at: 0)
                            save()
                            openNoteID = n.id
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(8)
                        }
                        .buttonStyle(.plain)
                    )
                )
                ZStack {
                    legalPadBackground
                    if notes.isEmpty {
                        Text("No Notes")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.35))
                            .padding(.top, 60)
                    } else {
                        List {
                            ForEach(notes) { note in
                                Button {
                                    openNoteID = note.id
                                } label: {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(firstLine(of: note.text))
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                        Text(note.modified, style: .date)
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 4)
                                }
                                .buttonStyle(.plain)
                                .listRowBackground(Color.clear)
                            }
                            .onDelete { idx in
                                notes.remove(atOffsets: idx)
                                save()
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .onAppear(perform: load)

            // Editor (pushed over the list, iOS-style).
            if let id = openNoteID,
               let idx = notes.firstIndex(where: { $0.id == id }) {
                NoteEditor(note: $notes[idx], onDone: {
                    notes[idx].modified = Date()
                    if notes[idx].text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        notes.remove(at: idx)
                    }
                    notes.sort { $0.modified > $1.modified }
                    save()
                    withAnimation(.easeInOut(duration: 0.25)) { openNoteID = nil }
                })
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: openNoteID)
    }

    private func firstLine(of text: String) -> String {
        let line = text.components(separatedBy: .newlines).first ?? ""
        return line.isEmpty ? "New Note" : line
    }

    private var legalPadBackground: some View {
        ZStack(alignment: .top) {
            Color(red: 0.99, green: 0.95, blue: 0.78)
            // Red margin line.
            Rectangle()
                .fill(Color.red.opacity(0.4))
                .frame(width: 1)
                .padding(.leading, 44)
                .frame(maxWidth: .infinity, alignment: .leading)
            // Blue rules.
            VStack(spacing: 27) {
                ForEach(0..<20, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.blue.opacity(0.18))
                        .frame(height: 1)
                }
            }
            .padding(.top, 8)
        }
        .ignoresSafeArea()
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: storeKey),
           let decoded = try? JSONDecoder().decode([SimNote].self, from: data) {
            notes = decoded.sorted { $0.modified > $1.modified }
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: storeKey)
        }
    }
}

struct NoteEditor: View {
    @Binding var note: SimNote
    var onDone: () -> Void
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 0) {
            iOS6NavBar(
                title: "",
                left: AnyView(iOS6BackButton(label: "Notes", action: onDone)),
                right: AnyView(
                    Button("Done", action: onDone)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .buttonStyle(.plain)
                )
            )
            ZStack(alignment: .topLeading) {
                Color(red: 0.99, green: 0.95, blue: 0.78)
                    .ignoresSafeArea()
                TextEditor(text: $note.text)
                    .font(.custom("Chalkboard SE", size: 17))
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.leading, 36)
                    .padding(.top, 8)
                    .focused($focused)
                    .onAppear { focused = true }
                // Red margin line.
                Rectangle()
                    .fill(Color.red.opacity(0.4))
                    .frame(width: 1)
                    .padding(.leading, 44)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
}
