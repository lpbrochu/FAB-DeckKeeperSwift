import SwiftUI

struct ChipView: View {
    let text: String
    let index: Int
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold, design: .default))
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .foregroundColor(textColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.primary.opacity(colorScheme == .dark ? 0.15 : 0.06), lineWidth: 1)
            )
    }

    private var paletteIndex: Int {
        let hash = DeckStore.hashCode(text)
        return abs(hash + index) % 6
    }

    private var backgroundColor: Color {
        let colorsLight = [
            Color(red: 0.91, green: 0.93, blue: 0.96), // #e8eef5
            Color(red: 0.95, green: 0.91, blue: 0.84), // #f1e9d7
            Color(red: 0.92, green: 0.87, blue: 0.91), // #eadfe8
            Color(red: 0.89, green: 0.93, blue: 0.89), // #e3eee4
            Color(red: 0.92, green: 0.90, blue: 0.87), // #ebe6df
            Color(red: 0.87, green: 0.91, blue: 0.92)  // #dfe9ea
        ]

        let colorsDark = [
            Color(red: 0.11, green: 0.15, blue: 0.21), // #1b2635
            Color(red: 0.17, green: 0.15, blue: 0.08), // #2c2514
            Color(red: 0.16, green: 0.10, blue: 0.15), // #281a27
            Color(red: 0.09, green: 0.16, blue: 0.11), // #182a1b
            Color(red: 0.17, green: 0.14, blue: 0.10), // #2b231a
            Color(red: 0.08, green: 0.15, blue: 0.15)  // #152627
        ]

        return colorScheme == .dark ? colorsDark[paletteIndex] : colorsLight[paletteIndex]
    }

    private var textColor: Color {
        colorScheme == .dark 
            ? Color(red: 0.91, green: 0.93, blue: 0.95) // #e8edf3
            : Color(red: 0.19, green: 0.22, blue: 0.27) // #313944
    }
}
