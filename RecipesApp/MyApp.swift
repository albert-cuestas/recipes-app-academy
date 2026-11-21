import SwiftUI
import SwiftData

@main struct MyApp: App {
    private let container: ModelContainer
    @State private var recipeVM: RecipesVM

    init() {
        do {
            let container = try ModelContainer.recipes()
            self.container = container
            _recipeVM = State(initialValue: RecipesVM(container: container))
        } catch {
            fatalError("Couldn't create the SwiftData container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(recipeVM)
        }
        .modelContainer(container)
    }
}
