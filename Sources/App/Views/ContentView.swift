import SwiftUI
import UniformTypeIdentifiers

// MARK: - File Document for Import/Export
struct JSONDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    
    var jsonString: String
    
    init(jsonString: String) {
        self.jsonString = jsonString
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents,
           let string = String(data: data, encoding: .utf8) {
            self.jsonString = string
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = jsonString.data(using: .utf8) ?? Data()
        return FileWrapper(regularFileWithContents: data)
    }
}

// MARK: - Main Content View
struct ContentView: View {
    @EnvironmentObject var viewModel: DeckViewModel
    
    @State private var selectedTab: Tab = .decks
    @State private var showResetConfirmation = false
    
    // File Import/Export State
    @State private var isExporting = false
    @State private var isImporting = false
    @State private var exportDocument: JSONDocument? = nil
    @State private var importErrorMessage: String? = nil
    @State private var showImportError = false

    // Navigation selection states for 3-column split view
    @State private var selectedDeckId: UUID? = nil
    @State private var isEditingSelectedDeck = false

    #if os(iOS)
    @Environment(\.horizontalSizeClass) var sizeClass
    #endif

    enum Tab: String, CaseIterable, Identifiable {
        case decks = "Decks"
        case matchup = "Matchup"
        
        var id: String { self.rawValue }
        
        var icon: String {
            switch self {
            case .decks: return "square.stack.3d.up.fill"
            case .matchup: return "gamecontroller.fill"
            }
        }
    }

    var body: some View {
        Group {
            #if os(macOS)
            splitViewLayout
            #else
            if sizeClass == .compact {
                tabViewLayout
            } else {
                splitViewLayout
            }
            #endif
        }
        // File exporter modifier
        .fileExporter(
            isPresented: $isExporting,
            document: exportDocument,
            contentType: .json,
            defaultFilename: "fab-deckkeeper-\(currentDateString())"
        ) { result in
            switch result {
            case .success(let url):
                print("Decks exported successfully to \(url)")
            case .failure(let error):
                print("Failed to export decks: \(error.localizedDescription)")
            }
        }
        // File importer modifier
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.json]
        ) { result in
            switch result {
            case .success(let url):
                importDecks(from: url)
            case .failure(let error):
                importErrorMessage = error.localizedDescription
                showImportError = true
            }
        }
        .alert("Import Failed", isPresented: $showImportError, presenting: importErrorMessage) { _ in
            Button("OK", role: .cancel) {}
        } message: { message in
            Text(message)
        }
        .onAppear {
            #if os(macOS)
            NSApplication.shared.activate(ignoringOtherApps: true)
            #endif
            // Auto-select the first deck if none selected yet
            if selectedDeckId == nil, let firstDeck = viewModel.decks.first {
                selectedDeckId = firstDeck.id
            }
        }
    }

    // MARK: - iPhone Layout
    private var tabViewLayout: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DeckListView()
                    .navigationTitle("Decks")
                    .toolbar { toolbarActions }
            }
            .tabItem {
                Label(Tab.decks.rawValue, systemImage: Tab.decks.icon)
            }
            .tag(Tab.decks)

            NavigationStack {
                MatchupView()
                    .navigationTitle("Matchup")
                    .toolbar { toolbarActions }
            }
            .tabItem {
                Label(Tab.matchup.rawValue, systemImage: Tab.matchup.icon)
            }
            .tag(Tab.matchup)
        }
    }

    // MARK: - iPad & Mac Layout
    private var splitViewLayout: some View {
        let selectionBinding = Binding<Tab?>(
            get: { selectedTab },
            set: { newValue in
                if let newValue {
                    selectedTab = newValue
                }
            }
        )
        
        let deckSelectionBinding = Binding<UUID?>(
            get: { selectedDeckId },
            set: { newValue in
                selectedDeckId = newValue
                isEditingSelectedDeck = false // Reset editing mode on selection change
            }
        )
        
        return NavigationSplitView {
            List(Tab.allCases, selection: selectionBinding) { tab in
                NavigationLink(value: tab) {
                    Label(tab.rawValue, systemImage: tab.icon)
                }
            }
            .navigationTitle("DeckKeeper")
            .listStyle(.sidebar)
        } content: {
            Group {
                switch selectedTab {
                case .decks:
                    DeckListView(selectedDeckId: deckSelectionBinding)
                case .matchup:
                    VStack(spacing: 16) {
                        Image(systemName: "gamecontroller")
                            .font(.system(size: 36))
                            .foregroundColor(.secondary)
                        Text("Matchup Active")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle(selectedTab == .decks ? "Decks" : "")
        } detail: {
            NavigationStack {
                Group {
                    switch selectedTab {
                    case .decks:
                        if let deckId = selectedDeckId,
                           let deck = viewModel.decks.first(where: { $0.id == deckId }) {
                            if isEditingSelectedDeck {
                                DeckDetailView(deckId: deckId, isInline: true) {
                                    isEditingSelectedDeck = false
                                }
                            } else {
                                DeckPreviewView(
                                    deck: deck,
                                    onEdit: {
                                        isEditingSelectedDeck = true
                                    },
                                    onFavorite: {
                                        withAnimation {
                                            viewModel.toggleFavorite(id: deck.id)
                                        }
                                    },
                                    onDelete: {
                                        withAnimation {
                                            viewModel.deleteDeck(id: deck.id)
                                            selectedDeckId = viewModel.decks.first?.id
                                        }
                                    }
                                )
                            }
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "square.stack.3d.up")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary)
                                Text("Select a Deck to View Details")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    case .matchup:
                        MatchupView()
                    }
                }
                .navigationTitle(selectedTab == .decks ? (isEditingSelectedDeck ? "Edit Deck" : "Deck Details") : "Matchup")
                .toolbar { toolbarActions }
            }
        }
    }

    // MARK: - Shared Toolbar Actions
    @ToolbarContentBuilder
    private var toolbarActions: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            // Import Button
            Button(action: { isImporting = true }) {
                Label("Import", systemImage: "square.and.arrow.down")
            }
            .help("Import decks from a JSON file")

            // Export Button
            Button(action: triggerExport) {
                Label("Export", systemImage: "square.and.arrow.up")
            }
            .help("Export decks to a JSON file")

            // Reset Button
            Button(action: { showResetConfirmation = true }) {
                Label("Reset", systemImage: "arrow.clockwise")
            }
            .help("Reset decks to default starters")
            .confirmationDialog(
                "Replace your current decks with the current legal hero defaults?",
                isPresented: $showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset Defaults", role: .destructive) {
                    withAnimation {
                        viewModel.resetToDefaults()
                        selectedDeckId = viewModel.decks.first?.id
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    // MARK: - File Helper Methods
    private func triggerExport() {
        if let jsonString = viewModel.exportJSONString() {
            exportDocument = JSONDocument(jsonString: jsonString)
            isExporting = true
        }
    }

    private func importDecks(from url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            importErrorMessage = "Failed to access the selected file."
            showImportError = true
            return
        }
        defer { url.stopAccessingSecurityScopedResource() }
        
        do {
            let data = try Data(contentsOf: url)
            if viewModel.importJSONData(data) {
                print("Imported decks successfully!")
            } else {
                importErrorMessage = "The JSON format is invalid or has unsupported structures."
                showImportError = true
            }
        } catch {
            importErrorMessage = error.localizedDescription
            showImportError = true
        }
    }

    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
