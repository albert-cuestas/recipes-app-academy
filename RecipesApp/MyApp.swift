import SwiftUI

@main struct MyApp: App {
    @State var recipeVM = RecipesVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(recipeVM)
        }
    }
}
