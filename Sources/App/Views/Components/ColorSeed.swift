import SwiftUI

struct ColorSeed {
    static func parseGradient(from string: String?) -> LinearGradient {
        guard let string = string else {
            return defaultGradient()
        }

        // Find hue from the HSL color declaration (e.g. hsl(123 20% 42%))
        let pattern = #"hsl\((\d+)"#
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: string, range: NSRange(string.startIndex..., in: string)),
           let hueRange = Range(match.range(at: 1), in: string),
           let hue = Double(string[hueRange]) {
            return gradient(forHue: hue)
        }

        return defaultGradient()
    }

    static func defaultGradient() -> LinearGradient {
        gradient(forHue: 200)
    }

    static func gradient(forHue hue: Double) -> LinearGradient {
        // HSL to HSB conversion for matching the web app colors:
        // Color 1: HSL(hue, 20%, 42%) -> HSB(hue, 33.3%, 50.4%)
        // Color 2: HSL(hue, 24%, 30%) -> HSB(hue, 38.7%, 37.2%)
        let c1 = Color(hue: hue / 360.0, saturation: 0.333, brightness: 0.504)
        let c2 = Color(hue: hue / 360.0, saturation: 0.387, brightness: 0.372)

        return LinearGradient(
            gradient: Gradient(colors: [c1, c2]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
