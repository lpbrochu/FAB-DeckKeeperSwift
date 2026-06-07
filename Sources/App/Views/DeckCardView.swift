import SwiftUI

struct DeckCardView: View {
    let deck: Deck
    let onFavorite: () -> Void
    let onEdit: () -> Void
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 12) {
            PortraitView(imageUrl: deck.imageUrl, heroName: deck.hero, className: deck.className, colorSeed: deck.color)
                .frame(width: 64, height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: Color.black.opacity(0.12), radius: 4, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(deck.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(1)

                        Text("\(deck.hero) · \(deck.className)")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    // Quick Actions
                    HStack(spacing: 4) {
                        Button(action: onFavorite) {
                            Image(systemName: deck.favorite ? "star.fill" : "star")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(deck.favorite ? .orange : .secondary)
                                .frame(width: 28, height: 28)
                                .background(Color.primary.opacity(0.04))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)

                        Button(action: onEdit) {
                            Image(systemName: "pencil")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.secondary)
                                .frame(width: 28, height: 28)
                                .background(Color.primary.opacity(0.04))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Tags in wrapping layout
                FlowLayout(spacing: 6) {
                    ChipView(text: deck.format, index: 0)
                    ChipView(text: deck.className, index: 1)
                    ForEach(Array(deck.talents.enumerated()), id: \.offset) { i, talent in
                        ChipView(text: talent, index: i + 2)
                    }
                }

                Spacer(minLength: 0)

                // Notes
                Text(deck.notes.isEmpty ? "No notes yet" : deck.notes)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .italic(deck.notes.isEmpty)
                    .lineLimit(1)
            }
            .padding(.vertical, 4)
        }
        .padding(10)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary.opacity(colorScheme == .dark ? 0.12 : 0.05), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.18 : 0.03), radius: 6, x: 0, y: 3)
    }

    private var cardBackground: Color {
        #if os(macOS)
        colorScheme == .dark 
            ? Color(nsColor: .windowBackgroundColor).opacity(0.4) 
            : Color(nsColor: .controlBackgroundColor)
        #else
        colorScheme == .dark 
            ? Color(uiColor: .secondarySystemBackground) 
            : Color(uiColor: .systemBackground)
        #endif
    }
}

// MARK: - SwiftUI wrapping Layout (FlowLayout)
struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let width = proposal.width ?? 0
        
        var currentX: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var maxLineWidth: CGFloat = 0
        
        for size in sizes {
            if currentX + size.width > width && currentX > 0 {
                totalHeight += lineHeight + spacing
                currentX = 0
                lineHeight = 0
            }
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
            maxLineWidth = max(maxLineWidth, currentX)
        }
        totalHeight += lineHeight
        
        return CGSize(width: maxLineWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX = bounds.minX
        var currentY = bounds.minY
        var lineHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX && currentX > bounds.minX {
                currentX = bounds.minX
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}
