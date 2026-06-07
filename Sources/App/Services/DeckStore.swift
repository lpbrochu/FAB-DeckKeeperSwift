import Foundation

class DeckStore {
    private static let fileName = "decks.json"

    private static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private static var fileURL: URL {
        documentsDirectory.appendingPathComponent(fileName)
    }

    // JS-equivalent hashCode implementation to guarantee identical color hues
    static func hashCode(_ string: String) -> Int {
        var hash = 0
        for char in string.utf16 {
            hash = ((hash << 5) - hash) + Int(char)
            hash = Int(Int32(truncatingIfNeeded: hash))
        }
        return hash
    }

    static func colorForSeed(_ seed: String) -> String {
        let hash = hashCode(seed)
        let hue = abs(hash) % 360
        return "linear-gradient(135deg, hsl(\(hue) 20% 42%), hsl(\(hue) 24% 30%))"
    }

    private static func defaultDeckNote(format: String) -> String {
        if format == "Silver Age" { return "Legal young hero shell" }
        return "Legal CC hero shell"
    }

    // Generate starter decks matching the web app's initial state
    static func generateStarterDecks() -> [Deck] {
        var decks: [Deck] = []
        let now = Date().timeIntervalSince1970 * 1000 // Millisecond timestamp

        for (index, entry) in HeroCatalog.seededHeroCatalog.enumerated() {
            for (formatIndex, variant) in entry.variants.enumerated() {
                let note = variant.notes.isEmpty ? defaultDeckNote(format: variant.format) : variant.notes
                let isFavorite = index < 4 && formatIndex == 0
                let deckColor = colorForSeed(entry.hero + entry.className)
                let updatedAt = now - Double(index * 60 * 1000)

                let deck = Deck(
                    id: UUID(),
                    name: variant.fullName,
                    hero: entry.hero,
                    className: entry.className,
                    talents: entry.talents,
                    format: variant.format,
                    imageUrl: variant.imageUrl,
                    notes: note,
                    favorite: isFavorite,
                    updatedAt: updatedAt,
                    color: deckColor
                )
                decks.append(deck)
            }
        }
        return decks
    }

    // Load decks from disk or seed default ones if none exist
    static func load() -> [Deck] {
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            let starters = generateStarterDecks()
            save(starters)
            return starters
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let decodedDecks = try decoder.decode([Deck].self, from: data)
            
            // Normalize decks to fix empty, legacy, or broken links
            let normalizedDecks = decodedDecks.map { normalize($0) }
            save(normalizedDecks) // Write back normalized list
            return normalizedDecks
        } catch {
            print("Error loading decks: \(error). Falling back to starter decks.")
            let starters = generateStarterDecks()
            save(starters)
            return starters
        }
    }

    // Save decks to disk
    static func save(_ decks: [Deck]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(decks)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error saving decks: \(error)")
        }
    }

    // Helper to extract a normalized form of strings for matching keys
    static func normalizeKeyPart(_ value: String) -> String {
        value.folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: "ð", with: "d")
            .replacingOccurrences(of: "Ð", with: "d")
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Normalizes loaded deck data to resolve broken links (equivalent to normalizeDeck in app.js)
    static func normalize(_ deck: Deck) -> Deck {
        var imageUrl = deck.imageUrl

        // Gather all starter decks currently available
        let starterDecks = generateStarterDecks()

        // Find exact match in catalog
        let exactStarter = starterDecks.first { s in
            normalizeKeyPart(s.name) == normalizeKeyPart(deck.name)
                && normalizeKeyPart(s.hero) == normalizeKeyPart(deck.hero)
                && normalizeKeyPart(s.className) == normalizeKeyPart(deck.className)
                && s.format == deck.format
        }

        // Check if the current URL is empty, broken, or contains a placeholder/invalid pattern
        let isUrlBrokenOrEmpty = imageUrl.isEmpty
            || imageUrl.contains("undefined")
            || imageUrl.hasSuffix("/")
            || (imageUrl.contains("legendstory-production-s3-public") && !imageUrl.hasSuffix(".webp"))
            || imageUrl.contains("HER148.webp")
            || imageUrl.contains("HER147.webp")
            || imageUrl.contains("HER117.webp")
            || imageUrl.contains("HER097.webp")
            || imageUrl.contains("HER123.webp")
            || imageUrl.contains("HER139.webp")

        if let exact = exactStarter {
            imageUrl = exact.imageUrl
        } else if isUrlBrokenOrEmpty {
            // If renamed but URL is broken, try a fallback match by hero class and format
            let fallbackStarter = starterDecks.first { s in
                normalizeKeyPart(s.hero) == normalizeKeyPart(deck.hero)
                    && normalizeKeyPart(s.className) == normalizeKeyPart(deck.className)
                    && s.format == deck.format
            }
            if let fallback = fallbackStarter {
                imageUrl = fallback.imageUrl
            }
        }

        // Convert large S3 URLs to small thumbnails if needed
        if imageUrl.contains("/media/cards/large/") {
            imageUrl = imageUrl.replacingOccurrences(of: "/media/cards/large/", with: "/media/cards/small/")
        }

        let validatedFormat = HeroCatalog.deckFormats.contains(deck.format) ? deck.format : "CC"
        let fallbackColor = colorForSeed(deck.hero + deck.className)

        return Deck(
            id: deck.id,
            name: deck.name.isEmpty ? "\(deck.hero) Deck" : deck.name,
            hero: deck.hero.isEmpty ? "Unknown" : deck.hero,
            className: deck.className.isEmpty ? "Unknown" : deck.className,
            talents: deck.talents,
            format: validatedFormat,
            imageUrl: imageUrl,
            notes: deck.notes,
            favorite: deck.favorite,
            updatedAt: deck.updatedAt == 0 ? Date().timeIntervalSince1970 * 1000 : deck.updatedAt,
            color: deck.color ?? fallbackColor
        )
    }
}
