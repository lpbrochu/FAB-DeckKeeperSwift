import SwiftUI

struct MatchupView: View {
    @EnvironmentObject var viewModel: DeckViewModel
    @State private var isShowingAddSheet = false

    #if os(iOS)
    @Environment(\.horizontalSizeClass) var sizeClass
    #endif

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24, pinnedViews: [.sectionHeaders]) {
                Section {
                    // Matchup Pair Display
                    if let firstId = viewModel.matchupIds[0], let firstDeck = viewModel.decks.first(where: { $0.id == firstId }),
                       let secondId = viewModel.matchupIds[1], let secondDeck = viewModel.decks.first(where: { $0.id == secondId }) {
                        
                        VStack(spacing: 16) {
                            // Format Badge
                            if !viewModel.matchupFormat.isEmpty {
                                Text(viewModel.matchupFormat)
                                    .font(.system(size: 12, weight: .bold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .foregroundColor(.primary)
                                    .background(Color.primary.opacity(0.06))
                                    .clipShape(Capsule())
                            }
                            
                            #if os(macOS)
                            horizontalPair(deck1: firstDeck, deck2: secondDeck)
                            #else
                            if sizeClass == .compact {
                                verticalPair(deck1: firstDeck, deck2: secondDeck)
                            } else {
                                horizontalPair(deck1: firstDeck, deck2: secondDeck)
                            }
                            #endif
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                        
                    } else {
                        emptyState
                            .padding(.horizontal, 16)
                            .padding(.top, 40)
                            .padding(.bottom, 24)
                    }
                } header: {
                    // Frosted Header containing selectors and Random Matchup title
                    VStack(spacing: 0) {
                        #if os(macOS)
                        Spacer()
                            .frame(height: 52)
                        #endif
                        
                        headerSection
                            .padding(.vertical, 16)
                    }
                    .background(.ultraThinMaterial)
                    .overlay(
                        VStack {
                            Spacer()
                            Divider()
                                .background(Color.white.opacity(0.12))
                        }
                    )
                    .ignoresSafeArea(edges: .top)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .ignoresSafeArea(edges: .top)
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
        .sheet(isPresented: $isShowingAddSheet) {
            DeckDetailView()
        }
    }

    // MARK: - Components
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Random Matchup")
                    .font(.system(size: 20, weight: .bold))
                
                Text("Shuffle two of your saved deck shells.")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    viewModel.randomizeMatchup()
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "shuffle")
                    Text("Shuffle")
                }
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .disabled(viewModel.decks.count < 2)
        }
        .padding(.horizontal, 16)
    }

    private func horizontalPair(deck1: Deck, deck2: Deck) -> some View {
        HStack(spacing: 24) {
            Spacer()
            
            matchupDeckCard(deck: deck1, index: 0)
                .frame(maxWidth: 440)
            
            vsDivider
            
            matchupDeckCard(deck: deck2, index: 1)
                .frame(maxWidth: 440)
            
            Spacer()
        }
    }

    private func verticalPair(deck1: Deck, deck2: Deck) -> some View {
        VStack(spacing: 20) {
            matchupDeckCard(deck: deck1, index: 0)
                .frame(maxWidth: 440)
            
            vsDivider
            
            matchupDeckCard(deck: deck2, index: 1)
                .frame(maxWidth: 440)
        }
    }

    private var vsDivider: some View {
        Text("VS")
            .font(.system(size: 22, weight: .black, design: .rounded))
            .foregroundColor(.secondary)
            .padding(16)
            .background(.thinMaterial)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 6)
    }

    private func matchupDeckCard(deck: Deck, index: Int) -> some View {
        VStack(spacing: 18) {
            ZStack(alignment: .topTrailing) {
                PortraitView(imageUrl: deck.imageUrl, heroName: deck.hero, className: deck.className, colorSeed: deck.color)
                    .id(deck.id)
                    .frame(width: 260, height: 364)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                
                // Lock Button
                Button(action: {
                    viewModel.matchupLocks[index].toggle()
                }) {
                    Image(systemName: viewModel.matchupLocks[index] ? "lock.fill" : "lock.open")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(viewModel.matchupLocks[index] ? .white : .primary)
                        .frame(width: 38, height: 38)
                        .background(viewModel.matchupLocks[index] ? Color.accentColor : Color.primary.opacity(0.06))
                        .clipShape(Circle())
                        .padding(12)
                }
                .buttonStyle(.plain)
            }

            VStack(spacing: 6) {
                Text(deck.name)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text("\(deck.hero) · \(deck.className)")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }

            // Deck Selection Picker
            Menu {
                // Group decks by format
                let formats = Array(Set(viewModel.decks.map { $0.format })).sorted()
                ForEach(formats, id: \.self) { format in
                    let formatDecks = viewModel.decks.filter { $0.format == format }.sorted(by: { $0.name < $1.name })
                    if !formatDecks.isEmpty {
                        Menu(format) {
                            ForEach(formatDecks) { candidate in
                                Button(action: {
                                    withAnimation {
                                        viewModel.selectMatchupDeck(index: index, deckId: candidate.id)
                                    }
                                }) {
                                    HStack {
                                        Text(candidate.name)
                                        if candidate.id == deck.id {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text("Deck")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    Text(deck.name)
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

            // Chips
            FlowLayout(spacing: 6) {
                ChipView(text: deck.format, index: 0)
                ChipView(text: deck.className, index: 1)
                ForEach(Array(deck.talents.enumerated()), id: \.offset) { i, talent in
                    ChipView(text: talent, index: i + 2)
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.2),
                            .white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "gamecontroller.dashed")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("Add at least two decks in the same format to randomize a matchup.")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Add Deck") {
                isShowingAddSheet = true
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color.primary.opacity(0.02))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
