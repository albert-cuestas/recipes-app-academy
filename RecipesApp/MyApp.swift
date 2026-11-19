import SwiftUI

@main struct MyApp: App {
    @State private var recipeVM = RecipesVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(recipeVM)
        }
    }
}
