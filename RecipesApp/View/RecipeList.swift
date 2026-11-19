//
//  RecipeList.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 18/11/2026.
//

import SwiftUI

struct RecipeList: View {
    @Environment(RecipesVM.self) private var controller
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(controller.recipes) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeCelda(recipe: recipe)
                        }
                        .buttonStyle(.plain)
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
