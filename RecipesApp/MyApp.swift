import SwiftUI
import SwiftData

@main struct MyApp: App {
    /// Contenedor de SwiftData. Se crea y se llena (si está vacío) antes de mostrar la primera pantalla,
    /// igual que en el ejemplo Wishlist de Apple: el JSON es local.
    let container: ModelContainer = {
        do {
            let container = try ModelContainer(for: Recipe.self)
            try RecipeSeeder.seedIfNeeded(in: container.mainContext)
            return container
        } catch {
            fatalError("Could not create model container: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
