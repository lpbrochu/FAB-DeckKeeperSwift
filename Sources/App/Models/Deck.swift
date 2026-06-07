import Foundation

struct Deck: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var hero: String
    var className: String
    var talents: [String]
    var format: String
    var imageUrl: String
    var notes: String
    var favorite: Bool
    var updatedAt: Double // Milliseconds since epoch to match JavaScript Date.now()
    var color: String?    // Stores the CSS linear gradient string

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Deck, rhs: Deck) -> Bool {
        lhs.id == rhs.id
    }
}
