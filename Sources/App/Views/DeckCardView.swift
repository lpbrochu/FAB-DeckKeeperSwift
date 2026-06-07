import SwiftUI

struct DeckCardView: View {
    let deck: Deck
    let onFavorite: () -> Void
    let onEdit: () -> Void
    let onSelect: (() -> Void)? = nil
    let isSelected: Bool = false
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 18) {
            // Clickable content area
            HStack(spacing: 18) {
                PortraitView(imageUrl: deck.imageUrl, heroName: deck.hero, className: deck.className, colorSeed: deck.color)
                    .frame(width: 130, height: 182)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)

                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(deck.name)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .lineLimit(1)

                        Text("\(deck.hero) · \(deck.className)")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
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
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .italic(deck.notes.isEmpty)
                        .lineLimit(1)
                }
                .padding(.vertical, 8)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onSelect?()
            }

            Spacer()

            // Quick Actions (not tap-captured by selection)
            HStack(spacing: 6) {
                Button(action: onFavorite) {
                    Image(systemName: deck.favorite ? "star.fill" : "star")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(deck.favorite ? .orange : .secondary)
                        .frame(width: 32, height: 32)
                        .background(Color.primary.opacity(0.04))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color.primary.opacity(0.04))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(
            ZStack {
                Color.clear
                if isSelected {
                    Color.accentColor.opacity(0.12)
                }
            }
        )
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [
                            isSelected ? Color.accentColor : Color.white.opacity(0.2),
                            isSelected ? Color.accentColor.opacity(0.6) : Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: isSelected ? 2 : 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.05), radius: 8, x: 0, y: 4)
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
