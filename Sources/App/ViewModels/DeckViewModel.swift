import SwiftUI
import Combine

class DeckViewModel: ObservableObject {
    @Published var decks: [Deck] = []

    // Filtering State
    @Published var searchText: String = ""
    @Published var selectedHeroFilter: String = "All"
    @Published var selectedTalentFilter: String = "All"
    @Published var selectedClassFilter: String = "All"
    @Published var selectedFormatFilter: String = "All"
    @Published var sortOption: SortOption = .updated

    // Matchup State
    @Published var matchupIds: [UUID?] = [nil, nil]
    @Published var matchupLocks: [Bool] = [false, false]
    @Published var matchupFormat: String = ""

    enum SortOption: String, CaseIterable, Identifiable {
        case updated = "Recently Updated"
        case name = "Name"
        case hero = "Hero"
        case className = "Class"

        var id: String { self.rawValue }
    }

    init() {
        self.decks = DeckStore.load()
        self.randomizeMatchup()
    }

    // MARK: - Filtered Decks
    var filteredDecks: [Deck] {
        decks.filter { deck in
            let search = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let matchesSearch = search.isEmpty 
                || deck.name.lowercased().contains(search)
                || deck.hero.lowercased().contains(search)
                || deck.className.lowercased().contains(search)
                || deck.format.lowercased().contains(search)
                || deck.notes.lowercased().contains(search)
                || deck.talents.contains(where: { $0.lowercased().contains(search) })

            let matchesHero = selectedHeroFilter == "All" || deck.hero == selectedHeroFilter
            let matchesTalent = selectedTalentFilter == "All" || deck.talents.contains(selectedTalentFilter)
            let matchesClass = selectedClassFilter == "All" || deck.className == selectedClassFilter
            let matchesFormat = selectedFormatFilter == "All" || deck.format == selectedFormatFilter

            return matchesSearch && matchesHero && matchesTalent && matchesClass && matchesFormat
        }.sorted { a, b in
            switch sortOption {
            case .updated:
                return a.updatedAt > b.updatedAt
            case .name:
                return a.name.localizedCompare(b.name) == .orderedAscending
            case .hero:
                return a.hero.localizedCompare(b.hero) == .orderedAscending
            case .className:
                return a.className.localizedCompare(b.className) == .orderedAscending
            }
        }
    }

    // MARK: - Dynamic Filter Option Lists
    var heroOptions: [String] {
        ["All"] + Array(Set(decks.map { $0.hero })).sorted()
    }

    var talentOptions: [String] {
        ["All"] + Array(Set(decks.flatMap { $0.talents })).sorted()
    }

    var classOptions: [String] {
        ["All"] + Array(Set(decks.map { $0.className })).sorted()
    }

    var formatOptions: [String] {
        ["All"] + HeroCatalog.deckFormats
    }

    func clearFilters() {
        searchText = ""
        selectedHeroFilter = "All"
        selectedTalentFilter = "All"
        selectedClassFilter = "All"
        selectedFormatFilter = "All"
    }

    // MARK: - Deck CRUD Operations
    func saveDeck(id: UUID?, name: String, hero: String, className: String, talents: [String], format: String, notes: String) {
        let now = Date().timeIntervalSince1970 * 1000
        let deckColor = DeckStore.colorForSeed(hero + className)

        if let existingId = id, let index = decks.firstIndex(where: { $0.id == existingId }) {
            // Edit existing
            var updatedDeck = decks[index]
            updatedDeck.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedDeck.hero = hero.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedDeck.className = className.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedDeck.talents = talents
            updatedDeck.format = format
            updatedDeck.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedDeck.updatedAt = now
            updatedDeck.color = deckColor

            decks[index] = DeckStore.normalize(updatedDeck)
        } else {
            // Add new
            let newDeck = Deck(
                id: UUID(),
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                hero: hero.trimmingCharacters(in: .whitespacesAndNewlines),
                className: className.trimmingCharacters(in: .whitespacesAndNewlines),
                talents: talents,
                format: format,
                imageUrl: "", // Will be populated by normalize
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
                favorite: false,
                updatedAt: now,
                color: deckColor
            )
            decks.insert(DeckStore.normalize(newDeck), at: 0)
        }
        
        DeckStore.save(decks)
        randomizeMatchup() // Verify if matchup is still valid after save
    }

    func deleteDeck(id: UUID) {
        decks.removeAll { $0.id == id }
        DeckStore.save(decks)
        
        // Clean matchup selections if they were deleted
        for i in 0..<matchupIds.count {
            if matchupIds[i] == id {
                matchupIds[i] = nil
                matchupLocks[i] = false
            }
        }
        randomizeMatchup()
    }

    func toggleFavorite(id: UUID) {
        if let index = decks.firstIndex(where: { $0.id == id }) {
            decks[index].favorite.toggle()
            decks[index].updatedAt = Date().timeIntervalSince1970 * 1000
            DeckStore.save(decks)
        }
    }

    func resetToDefaults() {
        let starters = DeckStore.generateStarterDecks()
        decks = starters
        matchupLocks = [false, false]
        DeckStore.save(decks)
        randomizeMatchup()
    }

    // MARK: - Matchup Randomization
    func randomizeMatchup() {
        let validMatchupDecks = decks.filter { deck in
            // Must have a format
            !deck.format.isEmpty
        }

        let lockedDecks = matchupIds.enumerated().compactMap { index, id -> (deck: Deck, index: Int)? in
            guard matchupLocks[index], let id = id, let deck = decks.first(where: { $0.id == id }) else { return nil }
            return (deck, index)
        }

        // Case 1: Both locked and formats match
        if lockedDecks.count == 2 {
            if lockedDecks[0].deck.format == lockedDecks[1].deck.format {
                matchupFormat = lockedDecks[0].deck.format
                return
            } else {
                // Formats mismatched, release locks
                matchupLocks = [false, false]
            }
        }

        // Case 2: One locked, find matching format candidate
        if lockedDecks.count == 1 {
            let locked = lockedDecks[0]
            let format = locked.deck.format
            let candidates = validMatchupDecks.filter { $0.format == format && $0.id != locked.deck.id }

            if candidates.isEmpty {
                matchupIds[locked.index == 0 ? 1 : 0] = nil
                matchupLocks[locked.index == 0 ? 1 : 0] = false
                matchupFormat = format
                return
            }

            let opponent = candidates.randomElement()
            matchupIds[locked.index == 0 ? 1 : 0] = opponent?.id
            matchupFormat = format
            return
        }

        // Case 3: None locked (or mismatched released), pick a format with at least 2 decks
        let formatGroups = Dictionary(grouping: validMatchupDecks, by: { $0.format })
        let eligibleFormats = formatGroups.filter { $0.value.count >= 2 }.map { $0.key }

        guard let selectedFormat = eligibleFormats.randomElement(),
              let pool = formatGroups[selectedFormat], pool.count >= 2 else {
            matchupIds = [nil, nil]
            matchupLocks = [false, false]
            matchupFormat = ""
            return
        }

        var samplePool = pool
        let first = samplePool.remove(at: Int.random(in: 0..<samplePool.count))
        let second = samplePool.randomElement()!

        matchupIds = [first.id, second.id]
        matchupFormat = selectedFormat
    }

    func selectMatchupDeck(index: Int, deckId: UUID) {
        guard let deck = decks.first(where: { $0.id == deckId }) else { return }
        
        let otherIndex = index == 0 ? 1 : 0
        matchupIds[index] = deck.id
        matchupLocks[index] = true
        matchupLocks[otherIndex] = false
        matchupFormat = deck.format

        let candidates = decks.filter { $0.format == deck.format && $0.id != deck.id }
        if !candidates.isEmpty {
            matchupIds[otherIndex] = candidates.randomElement()?.id
        } else {
            matchupIds[otherIndex] = nil
        }
    }

    // MARK: - JSON Import / Export
    func exportJSONString() -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(decks)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Failed to encode decks: \(error)")
            return nil
        }
    }

    func importJSONData(_ data: Data) -> Bool {
        do {
            let decoder = JSONDecoder()
            let importedDecks = try decoder.decode([Deck].self, from: data)
            
            // Normalize all imported decks
            let normalized = importedDecks.map { DeckStore.normalize($0) }
            
            self.decks = normalized
            DeckStore.save(self.decks)
            randomizeMatchup()
            return true
        } catch {
            print("Failed to parse imported JSON: \(error)")
            return false
        }
    }
}
