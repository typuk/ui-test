import SwiftUI
import SwiftData

@main
struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            JokeListView()
        }
        .modelContainer(BaseComponents.shared.sharedModelContainer)
    }
}
