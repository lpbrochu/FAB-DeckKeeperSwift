// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DeckKeeperSwift",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(name: "DeckKeeperSwift", targets: ["App"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [],
            path: "Sources/App"
        )
    ]
)
