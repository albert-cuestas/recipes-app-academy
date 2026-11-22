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
            LabeledContent("Total time", value: recipe.totalTime, format: .recipeTime)
            LabeledContent("Servings", value: recipe.servings, format: .number)
            LabeledContent(
                "Calories per serving",
                value: recipe.caloriesPerServingMeasurement,
                format: .measurement(width: .abbreviated, usage: .asProvided)
            )
            LabeledContent("Rating") {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                    Text(ratingText)
                }
                .foregroundStyle(.orange)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(ratingValue) out of 5, \(reviewsText)")
            }
        }
    }

    private var ratingValue: String {
        recipe.rating.formatted(.number.precision(.fractionLength(1)))
    }

    private var ratingText: String {
        "\(ratingValue) (\(recipe.reviewCount))"
    }

    private var reviewsText: String {
        String(localized: "\(recipe.reviewCount) reviews")
    }
}

#Preview(traits: .modifier(RecipesPreviewData())) {
    List {
        RecipeOverviewSection(recipe: .previewSample)
    }
    .listStyle(.insetGrouped)
}
