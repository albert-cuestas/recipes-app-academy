//
//  RecipeOverviewSection.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 22/11/2026.
//

import SwiftUI

/// Datos clave de la receta.
struct RecipeOverviewSection: View {
    let recipe: Recipe

    var body: some View {
        Section("Overview") {
            LabeledContent("Difficulty", value: recipe.difficulty)
            LabeledContent("Prep time", value: recipe.prepTime, format: .recipeTime)
            LabeledContent("Cook time", value: recipe.cookTime, format: .recipeTime)
            LabeledContent(
                "Calories per serving",
                value: recipe.caloriesPerServingMeasurement,
                format: .measurement(width: .abbreviated, usage: .asProvided)
            )
        }
    }
}

#Preview(traits: .modifier(RecipesPreviewData())) {
    List {
        RecipeOverviewSection(recipe: .previewSample)
    }
    .listStyle(.insetGrouped)
}
