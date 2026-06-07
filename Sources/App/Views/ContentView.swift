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
        ZStack {
            // Liquid glass background gradient
            ZStack {
                Color(red: 0.04, green: 0.03, blue: 0.08)
                
                RadialGradient(
                    colors: [Color(red: 0.54, green: 0.17, blue: 0.89).opacity(0.18), .clear],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 450
                )
                
                RadialGradient(
                    colors: [Color(red: 0.0, green: 0.8, blue: 0.82).opacity(0.12), .clear],
                    center: .bottomTrailing,
                    startRadius: 0,
                    endRadius: 550
                )
            }
            .ignoresSafeArea()

            // Frosted header backdrop behind transparent native toolbars
            frostedHeaderBackdrop

            Group {
                #if os(macOS)
                toolbarLayout
                #else
                if sizeClass == .compact {
                    tabViewLayout
                } else {
                    toolbarLayout
                }
                #endif
            }
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
        }
    }

    #if !os(macOS)
    // MARK: - iPhone Layout
    private var tabViewLayout: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DeckListView()
                    .navigationTitle("Decks")
                    .toolbar { toolbarActions }
                    .toolbarBackground(.hidden, for: .navigationBar)
            }
            .tabItem {
                Label(Tab.decks.rawValue, systemImage: Tab.decks.icon)
            }
            .tag(Tab.decks)

            NavigationStack {
                MatchupView()
                    .navigationTitle("Matchup")
                    .toolbar { toolbarActions }
                    .toolbarBackground(.hidden, for: .navigationBar)
            }
            .tabItem {
                Label(Tab.matchup.rawValue, systemImage: Tab.matchup.icon)
            }
            .tag(Tab.matchup)
        }
    }
    #endif

    // MARK: - iPad & Mac Toolbar Layout
    private var toolbarLayout: some View {
        NavigationStack {
            Group {
                switch selectedTab {
                case .decks:
                    DeckListView()
                case .matchup:
                    MatchupView()
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("View Selection", selection: $selectedTab) {
                        ForEach(Tab.allCases) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                }
                
                toolbarActions
            }
            #if os(macOS)
            .toolbarBackground(.hidden)
            #else
            .toolbarBackground(.hidden, for: .navigationBar)
            #endif
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

    // MARK: - Frosted Window Header Backdrop
    private var frostedHeaderBackdrop: some View {
        VStack {
            #if os(macOS)
            let headerHeight: CGFloat = 52
            #else
            let headerHeight: CGFloat = 44
            #endif
            
            Color.clear
                .frame(height: headerHeight)
                .background(.ultraThinMaterial)
                .overlay(
                    VStack {
                        Spacer()
                        Divider()
                            .background(Color.white.opacity(0.12))
                    }
                )
                .ignoresSafeArea(edges: .top)
            
            Spacer()
        }
    }
}
