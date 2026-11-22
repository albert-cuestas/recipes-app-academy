import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview(traits: .modifier(RecipesPreviewData())) {
    ContentView()
}
