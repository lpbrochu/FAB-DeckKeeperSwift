import SwiftUI

struct PortraitView: View {
    let imageUrl: String
    let heroName: String
    let className: String
    let colorSeed: String?

    var body: some View {
        ZStack {
            if let url = URL(string: imageUrl), !imageUrl.isEmpty {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    fallbackView
                }
                .id(url)
            } else {
                fallbackView
            }
        }
        .id("\(imageUrl)_\(heroName)")
    }

    private var fallbackView: some View {
        ZStack {
            ColorSeed.parseGradient(from: colorSeed ?? (heroName + className))

            VStack(spacing: 2) {
                Text(getInitials(from: heroName))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)

                Text(className.uppercased())
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
                    .tracking(1)
            }
            .padding(4)
        }
    }

    private func getInitials(from name: String) -> String {
        let parts = name.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        if parts.isEmpty { return "?" }
        let letters = parts.compactMap { $0.first }
        let initials = letters.map { String($0) }.joined()
        return String(initials.prefix(2)).uppercased()
    }
}
