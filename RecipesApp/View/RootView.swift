//
//  RootView.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI
import SwiftData

/// ya no se como hacer para mostrar la vista mientras se carga la app necesito descubri lauchscreen preguntar...
struct RootView: View {
    @Query(RootView.anyRecipe) private var recipes: [Recipe]

    private static var anyRecipe: FetchDescriptor<Recipe> {
        var descriptor = FetchDescriptor<Recipe>()
        descriptor.fetchLimit = 1
        return descriptor
    }

    private var isLoading: Bool {
        recipes.isEmpty
    }

    var body: some View {
        ZStack {
            if isLoading {
                SplashView()
                    .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.3), value: isLoading)
    }
}

#Preview(traits: .modifier(RecipesPreviewData())) {
    RootView()
}
