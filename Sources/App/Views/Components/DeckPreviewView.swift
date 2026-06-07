import SwiftUI

struct DeckPreviewView: View {
    let deck: Deck
    let onEdit: () -> Void
    let onFavorite: () -> Void
    let onDelete: () -> Void

    @Environment(\.colorScheme) var colorScheme
    @State private var showDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // Main split layout for details: Image on left, metadata on right
                HStack(alignment: .top, spacing: 32) {
                    // Left Column: Large Hero Card Preview
                    VStack {
                        PortraitView(
                            imageUrl: deck.imageUrl,
                            heroName: deck.hero,
                            className: deck.className,
                            colorSeed: deck.color
                        )
                        .frame(width: 240, height: 336)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.15), radius: 12, x: 0, y: 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                        )
                    }

                    // Right Column: Metadata & Actions
                    VStack(alignment: .leading, spacing: 18) {
                        // Title & Format
                        VStack(alignment: .leading, spacing: 6) {
                            Text(deck.format)
                                .font(.system(size: 11, weight: .bold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .foregroundColor(.primary)
                                .background(Color.primary.opacity(0.06))
                                .clipShape(Capsule())

                            Text(deck.name)
                                .font(.system(size: 26, weight: .black, design: .rounded))
                                .foregroundColor(.primary)
                                .lineLimit(3)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        // Hero & Class
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hero & Class")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)

                            Text("\(deck.hero) · \(deck.className)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                        }

                        // Talents
                        if !deck.talents.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Talents")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)

                                FlowLayout(spacing: 6) {
                                    ForEach(Array(deck.talents.enumerated()), id: \.offset) { i, talent in
                                        ChipView(text: talent, index: i)
                                    }
                                }
                            }
                        }

                        Spacer(minLength: 12)

                        // Action Buttons Bar
                        HStack(spacing: 12) {
                            Button(action: onFavorite) {
                                Label(
                                    deck.favorite ? "Favorited" : "Favorite",
                                    systemImage: deck.favorite ? "star.fill" : "star"
                                )
                                .font(.system(size: 13, weight: .bold))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .foregroundColor(deck.favorite ? .orange : .primary)
                                .background(Color.primary.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)

                            Button(action: onEdit) {
                                Label("Edit Deck", systemImage: "pencil")
                                    .font(.system(size: 13, weight: .bold))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.white)
                                    .background(Color.accentColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)

                            Button(action: { showDeleteConfirmation = true }) {
                                Image(systemName: "trash")
                                    .font(.system(size: 13, weight: .bold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.red)
                                    .background(Color.red.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    Spacer()
                }
                
                // Notes Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Deck Notes")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    VStack(alignment: .leading) {
                        if deck.notes.isEmpty {
                            Text("No notes added yet. Edit this deck to add details about matchups, sideboarding, or strategies.")
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            Text(deck.notes)
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color.primary.opacity(0.02))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primary.opacity(0.05), lineWidth: 1)
                    )
                }
            }
            .padding(24)
        }
        .confirmationDialog(
            "Are you sure you want to delete \(deck.name)?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete Deck", role: .destructive, action: onDelete)
            Button("Cancel", role: .cancel) {}
        }
    }
}
