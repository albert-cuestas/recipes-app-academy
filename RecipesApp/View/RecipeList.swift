//
//  RecipeList.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 18/11/2026.
//

import SwiftUI

struct RecipeList: View {
    @Environment(RecipesVM.self) private var controller
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        let reduceMotion = reduceMotion
        
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(controller.recipes) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeCelda(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity || reduceMotion ? 1 : 0.92)
                                .opacity(phase.isIdentity ? 1 : 0.6)
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Recetas")
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }
}

#Preview {
    RecipeList()
        .environment(RecipesVM(repository: RepositoryTest()))
}
