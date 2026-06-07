import SwiftUI

@main
struct DeckKeeperApp: App {
    @StateObject private var viewModel = DeckViewModel()

    init() {
        #if os(macOS)
        // Force the app to register as a GUI app (shows in Dock) and take focus when run from Xcode
        let app = NSApplication.shared
        app.setActivationPolicy(.regular)
        DispatchQueue.main.async {
            app.activate(ignoringOtherApps: true)
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
        #if os(macOS)
        .windowStyle(.automatic)
        #endif
    }
}
