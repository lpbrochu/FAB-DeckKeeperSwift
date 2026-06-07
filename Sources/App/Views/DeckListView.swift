import SwiftUI

struct DeckIdentifier: Identifiable {
    let id: UUID
}

struct DeckListView: View {
    @EnvironmentObject var viewModel: DeckViewModel
    @State private var editingDeckId: DeckIdentifier? = nil
    @State private var isShowingAddSheet = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                Section {
                    // Deck List Grid
                    if viewModel.filteredDecks.isEmpty {
                        emptyState
                            .padding(.top, 40)
                    } else {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 480), spacing: 16)], spacing: 16) {
                            ForEach(viewModel.filteredDecks) { deck in
                                DeckCardView(
                                    deck: deck,
                                    onFavorite: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            viewModel.toggleFavorite(id: deck.id)
                                        }
                                    },
                                    onEdit: {
                                        editingDeckId = DeckIdentifier(id: deck.id)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                } header: {
                    // Pinned Header with frosted glass background
                    VStack(spacing: 12) {
                        // Search Bar
                        HStack {
                            searchField
                                .frame(maxWidth: 500)
                            Spacer(minLength: 0)
                        }
                        .padding(.top, 12)

                        // Filters Grid
                        filterGrid

                        // Section Header (Count & Sort)
                        sectionHeader
                            .padding(.bottom, 8)
                    }
                    .padding(.horizontal, 16)
                    #if os(macOS)
                    .padding(.top, 80)
                    #endif
                    .background(.ultraThinMaterial)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .background(Color.white.opacity(0.12))
                            .allowsHitTesting(false)
                    }
                    .ignoresSafeArea(edges: .top)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $isShowingAddSheet) {
            DeckDetailView()
        }
        .sheet(item: $editingDeckId) { deckIdent in
            DeckDetailView(deckId: deckIdent.id)
        }
        .background(
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
        )
        .toolbar {
            #if os(macOS)
            ToolbarItem(placement: .primaryAction) {
                Button(action: { isShowingAddSheet = true }) {
                    Label("Add Deck", systemImage: "plus")
                }
            }
            #else
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isShowingAddSheet = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                }
            }
            #endif
        }
    }

    // MARK: - Components
    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 16))
            
            TextField("Search decks...", text: $viewModel.searchText)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .font(.system(size: 15))
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.2), .white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    private var filterGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140, maximum: .infinity), spacing: 8)], spacing: 8) {
            filterMenu(title: "Hero", selection: $viewModel.selectedHeroFilter, options: viewModel.heroOptions)
            filterMenu(title: "Talent", selection: $viewModel.selectedTalentFilter, options: viewModel.talentOptions)
            filterMenu(title: "Class", selection: $viewModel.selectedClassFilter, options: viewModel.classOptions)
            filterMenu(title: "Format", selection: $viewModel.selectedFormatFilter, options: viewModel.formatOptions)
        }
    }

    private func filterMenu(title: String, selection: Binding<String>, options: [String]) -> some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: { selection.wrappedValue = option }) {
                    HStack {
                        Text(option)
                        if selection.wrappedValue == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text("\(title):")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                Text(selection.wrappedValue)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
                
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.15), .white.opacity(0.03)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var sectionHeader: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Your Decks")
                    .font(.system(size: 18, weight: .bold))
                
                Text("\(viewModel.filteredDecks.count) of \(viewModel.decks.count)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Sort Dropdown
            Menu {
                ForEach(DeckViewModel.SortOption.allCases) { option in
                    Button(action: { viewModel.sortOption = option }) {
                        HStack {
                            Text(option.rawValue)
                            if viewModel.sortOption == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text("Sort:")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    Text(viewModel.sortOption.rawValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.15), .white.opacity(0.03)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "square.dashed")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No decks match those filters.")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Button("Clear Filters") {
                withAnimation {
                    viewModel.clearFilters()
                }
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


