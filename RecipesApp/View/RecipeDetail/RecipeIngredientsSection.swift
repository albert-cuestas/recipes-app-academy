//
//  RecipeIngredientsSection.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 22/11/2026.
//

import SwiftUI

/// Lista de ingredientes
struct RecipeIngredientsSection: View {
    let ingredients: [String]

    var body: some View {
        if !ingredients.isEmpty {
            Section("Ingredients") {
                ForEach(Array(ingredients.enumerated()), id: \.offset) { _, ingredient in
                    Text("· \(ingredient)")
                }
            }
        }
    }
}

#Preview {
    List {
        RecipeIngredientsSection(ingredients: ["Pizza dough", "Tomato sauce", "Fresh basil leaves"])
    }
    .listStyle(.insetGrouped)
}
