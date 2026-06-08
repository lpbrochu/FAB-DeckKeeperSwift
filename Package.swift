// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FABDeckKeeper",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(name: "FAB Deck Keeper", targets: ["App"])
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
