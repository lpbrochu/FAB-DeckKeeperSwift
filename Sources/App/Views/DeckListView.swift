import SwiftUI

struct DeckIdentifier: Identifiable {
    let id: UUID
}

struct DeckListView: View {
    @EnvironmentObject var viewModel: DeckViewModel
    @State private var editingDeckId: DeckIdentifier? = nil
    @State private var isShowingAddSheet = false

    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                searchField
                    .frame(maxWidth: 500)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            // Filters Grid
            filterGrid
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

            // Section Header (Count & Sort)
            sectionHeader
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

            // Deck List
            if viewModel.filteredDecks.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 340), spacing: 12)], spacing: 12) {
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
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            DeckDetailView()
        }
        .sheet(item: $editingDeckId) { deckIdent in
            DeckDetailView(deckId: deckIdent.id)
        }
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
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search decks...", text: $viewModel.searchText)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.primary.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
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
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.primary.opacity(0.03))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.primary.opacity(0.05), lineWidth: 1)
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
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.primary.opacity(0.03))
                .clipShape(RoundedRectangle(cornerRadius: 6))
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


