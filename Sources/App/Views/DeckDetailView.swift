import SwiftUI

struct DeckDetailView: View {
    @EnvironmentObject var viewModel: DeckViewModel
    @Environment(\.dismiss) var dismiss
    
    let deckId: UUID?
    
    // Form Inputs
    @State private var name: String = ""
    @State private var hero: String = ""
    @State private var className: String = ""
    @State private var talentsString: String = ""
    @State private var format: String = "CC"
    @State private var notes: String = ""
    
    @State private var showDeleteConfirmation = false
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var sizeClass
    #endif

    init(deckId: UUID? = nil) {
        self.deckId = deckId
    }

    var body: some View {
        NavigationStack {
            Group {
                #if os(macOS)
                horizontalContent
                #else
                if sizeClass == .compact {
                    verticalContent
                } else {
                    horizontalContent
                }
                #endif
            }
            .padding(20)
            .navigationTitle(deckId == nil ? "Add Deck" : "Edit Deck")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(name.isEmpty || hero.isEmpty || className.isEmpty)
                }
            }
            .onAppear(perform: populateData)
        }
        #if os(macOS)
        .frame(minWidth: 720, minHeight: 480)
        #endif
    }

    // MARK: - Layout Content
    private var verticalContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                previewCard
                    .frame(width: 240, height: 336)
                    .padding(.top, 10)
                
                formFields
            }
        }
    }

    private var horizontalContent: some View {
        HStack(alignment: .top, spacing: 32) {
            VStack {
                previewCard
                    .frame(width: 280, height: 392)
                
                Spacer()
            }
            
            ScrollView {
                formFields
            }
        }
    }

    // MARK: - Components
    private var previewCard: some View {
        PortraitView(
            imageUrl: resolvedImageUrl,
            heroName: hero.isEmpty ? "Hero" : hero,
            className: className.isEmpty ? "Class" : className,
            colorSeed: colorSeed
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
    }

    private var formFields: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Deck Name")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                TextField("e.g. Lexi Blitz, Bravo CC", text: $name)
                    .textFieldStyle(.roundedBorder)
            }

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Hero")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    TextField("e.g. Lexi, Bravo", text: $hero)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Class")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    TextField("e.g. Ranger, Guardian", text: $className)
                        .textFieldStyle(.roundedBorder)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Talents")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                TextField("Comma separated, e.g. Ice, Lightning", text: $talentsString)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Format")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Picker("", selection: $format) {
                    Text("Classic Constructed (CC)").tag("CC")
                    Text("Silver Age").tag("Silver Age")
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Notes")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                TextField("e.g. List version, testing notes, local meta", text: $notes)
                    .textFieldStyle(.roundedBorder)
            }
            
            if deckId != nil {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "trash")
                        Text("Delete Deck")
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(.bordered)
                .padding(.top, 12)
                .confirmationDialog("Are you sure you want to delete this deck?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                    Button("Delete", role: .destructive) {
                        if let id = deckId {
                            viewModel.deleteDeck(id: id)
                            dismiss()
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }
        }
    }

    // MARK: - Helpers
    private var resolvedImageUrl: String {
        let starterDecks = DeckStore.generateStarterDecks()
        let match = starterDecks.first { s in
            DeckStore.normalizeKeyPart(s.hero) == DeckStore.normalizeKeyPart(hero)
                && s.format == format
        }
        return match?.imageUrl ?? ""
    }

    private var colorSeed: String {
        let starterDecks = DeckStore.generateStarterDecks()
        let match = starterDecks.first { s in
            DeckStore.normalizeKeyPart(s.hero) == DeckStore.normalizeKeyPart(hero)
                && s.format == format
        }
        return match?.color ?? DeckStore.colorForSeed(hero + className)
    }

    private func populateData() {
        guard let id = deckId, let deck = viewModel.decks.first(where: { $0.id == id }) else { return }
        name = deck.name
        hero = deck.hero
        className = deck.className
        talentsString = deck.talents.joined(separator: ", ")
        format = deck.format
        notes = deck.notes
    }

    private func save() {
        let talents = talentsString.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        viewModel.saveDeck(
            id: deckId,
            name: name,
            hero: hero,
            className: className,
            talents: talents,
            format: format,
            notes: notes
        )
        dismiss()
    }
}
