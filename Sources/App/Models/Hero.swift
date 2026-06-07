import Foundation

struct Hero: Codable, Hashable, Identifiable {
    var id: String { hero + "_" + className }
    let hero: String
    let className: String
    let talents: [String]
    let variants: [HeroVariant]
}

struct HeroVariant: Codable, Hashable, Identifiable {
    var id: String { fullName + "_" + format }
    let format: String
    let fullName: String
    let imageUrl: String
    let notes: String

    init(format: String, fullName: String, imageUrl: String, notes: String = "") {
        self.format = format
        self.fullName = fullName
        self.imageUrl = imageUrl
        self.notes = notes
    }
}
