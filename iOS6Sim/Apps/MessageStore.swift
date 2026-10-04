import Foundation
import SQLite3

/// A single chat message from the Mac's Messages database.
struct SimChatMessage: Identifiable {
    let id: Int64
    let text: String
    let isFromMe: Bool
    let date: Date
}

/// A conversation thread from the Mac's Messages database.
struct SimConversation: Identifiable {
    let id: Int64
    let identifier: String
    let displayName: String
    let lastText: String
    let lastDate: Date
}

/// Reads the Mac's iMessage/SMS database (~/Library/Messages/chat.db).
/// Everything happens on-device at runtime — messages are never copied,
/// uploaded, or logged anywhere. Requires Full Disk Access.
final class MessageStore: ObservableObject {
    @Published var conversations: [SimConversation] = []
    @Published var hasAccess = false
    @Published var needsPermission = false

    private var db: OpaquePointer?

    private var dbPath: String {
        (NSHomeDirectory() as NSString).appendingPathComponent("Library/Messages/chat.db")
    }

    init() {
        openDatabase()
    }

    deinit {
        if let db { sqlite3_close(db) }
    }

    /// Try to open the database. Sets hasAccess / needsPermission.
    func openDatabase() {
        closeDatabase()
        // Quick readability check — fails without Full Disk Access.
        guard FileManager.default.isReadableFile(atPath: dbPath) else {
            hasAccess = false
            needsPermission = true
            return
        }
        var handle: OpaquePointer?
        if sqlite3_open_v2(dbPath, &handle, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
            db = handle
            hasAccess = true
            needsPermission = false
            loadConversations()
        } else {
            if let handle { sqlite3_close(handle) }
            hasAccess = false
            needsPermission = true
        }
    }

    func refresh() {
        if hasAccess { loadConversations() } else { openDatabase() }
    }

    private func closeDatabase() {
        if let db { sqlite3_close(db) }
        db = nil
    }

    // MARK: - Queries

    private func loadConversations() {
        guard let db else { return }
        // Latest message per chat, newest chats first.
        let sql = """
            SELECT c.ROWID, c.chat_identifier,
                   (SELECT m.text FROM message m
                    JOIN chat_message_join j ON m.ROWID = j.message_id
                    WHERE j.chat_id = c.ROWID
                    ORDER BY m.date DESC LIMIT 1),
                   (SELECT m.date FROM message m
                    JOIN chat_message_join j ON m.ROWID = j.message_id
                    WHERE j.chat_id = c.ROWID
                    ORDER BY m.date DESC LIMIT 1)
            FROM chat c
            ORDER BY 4 DESC
            LIMIT 30;
            """
        var stmt: OpaquePointer?
        var result: [SimConversation] = []
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let rowID = sqlite3_column_int64(stmt, 0)
                let identifier = stringColumn(stmt, 1) ?? "Unknown"
                let lastText = stringColumn(stmt, 2) ?? ""
                let rawDate = sqlite3_column_int64(stmt, 3)
                result.append(SimConversation(
                    id: rowID,
                    identifier: identifier,
                    displayName: Self.prettyName(for: identifier),
                    lastText: Self.previewText(lastText),
                    lastDate: Self.appleDate(rawDate)
                ))
            }
        }
        sqlite3_finalize(stmt)
        DispatchQueue.main.async {
            self.conversations = result
        }
    }

    /// Newest-first messages for one chat.
    func messages(for chatID: Int64, limit: Int = 120) -> [SimChatMessage] {
        guard let db else { return [] }
        let sql = """
            SELECT m.ROWID, m.text, m.is_from_me, m.date
            FROM message m
            JOIN chat_message_join j ON m.ROWID = j.message_id
            WHERE j.chat_id = ?
            ORDER BY m.date DESC
            LIMIT ?;
            """
        var stmt: OpaquePointer?
        var result: [SimChatMessage] = []
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int64(stmt, 1, chatID)
            sqlite3_bind_int(stmt, 2, Int32(limit))
            while sqlite3_step(stmt) == SQLITE_ROW {
                let text = stringColumn(stmt, 1) ?? ""
                // Skip empty / non-text payloads (attachments, reactions).
                guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
                result.append(SimChatMessage(
                    id: sqlite3_column_int64(stmt, 0),
                    text: text,
                    isFromMe: sqlite3_column_int(stmt, 2) == 1,
                    date: Self.appleDate(sqlite3_column_int64(stmt, 3))
                ))
            }
        }
        sqlite3_finalize(stmt)
        return result.reversed() // chronological
    }

    // MARK: - Helpers

    private func stringColumn(_ stmt: OpaquePointer?, _ index: Int32) -> String? {
        guard let cStr = sqlite3_column_text(stmt, index) else { return nil }
        return String(cString: cStr)
    }

    /// chat.db dates are nanoseconds since 2001-01-01 (Apple reference date).
    private static func appleDate(_ raw: Int64) -> Date {
        Date(timeIntervalSinceReferenceDate: Double(raw) / 1_000_000_000.0)
    }

    /// Make chat identifiers readable: "+15551234567" stays, group IDs shorten.
    private static func prettyName(for identifier: String) -> String {
        if identifier.hasPrefix("chat") && identifier.count > 20 {
            return "Group Chat"
        }
        return identifier
    }

    /// One-line preview; strips newlines.
    private static func previewText(_ text: String) -> String {
        let oneLine = text.components(separatedBy: .newlines).first ?? ""
        return oneLine.count > 60 ? String(oneLine.prefix(60)) + "…" : oneLine
    }
}
