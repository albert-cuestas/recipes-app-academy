//
//  RecipeDetailView.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(RecipesVM.self) private var controller
    @State private var isShowingImage = false
    @Namespace private var namespace
    @ScaledMetric private var tagSpacing = 8.0
    
    var body: some View {
        List {
            // Imagen y nombre
            Section {
                Button {
                    isShowingImage = true
                } label: {
                    RecipeImage(url: recipe.image)
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .glassEffect(in: .circle)
                                .matchedTransitionSource(id: recipe.id, in: namespace)
                                .padding(12)
                                .accessibilityHidden(true)
                        }
                }
                .accessibilityLabel("View larger image")
                // Hermano del botón de la imagen, no dentro de su label: así cada botón recibe su toque
                .overlay(alignment: .topTrailing) {
                    SaveRecipeButton(isSaved: controller.isSaved(recipe)) {
                        controller.toggleSaved(recipe)
                    }
                    .padding(12)
                }
                .listRowInsets(EdgeInsets())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(.title2.bold())
                    Text(recipe.cuisine)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Datos clave
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
            
            if !recipe.ingredients.isEmpty {
                Section("Ingredients") {
                    // Identidad por posición: un ingrediente puede repetirse en la lista.
                    ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { _, ingredient in
                        Text(ingredient)
                    }
                }
            }
            
            if !recipe.instructions.isEmpty {
                Section("Instructions") {
                    ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text("\(index + 1).")
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                            Text(step)
                        }
                    }
                }
            }
            
            if !recipe.mealType.isEmpty {
                Section("Meal type") {
                    FlowLayout(spacing: tagSpacing, lineSpacing: tagSpacing) {
                        ForEach(recipe.mealType, id: \.self) { meal in
                            TagCapsule(text: meal, background: .orange.opacity(0.2))
                        }
                    }
                    .accessibilityElement(children: .combine)
                }
            }
            
            if !recipe.tags.isEmpty {
                Section("Tags") {
                    FlowLayout(spacing: tagSpacing, lineSpacing: tagSpacing) {
                        ForEach(recipe.tags, id: \.self) { tag in
                            TagCapsule(text: tag)
                        }
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ShareLink(item: shareText, subject: Text(recipe.name))
        }
        .sheet(isPresented: $isShowingImage) {
            RecipeImageViewer(url: recipe.image, title: recipe.name)
                .navigationTransition(.zoom(sourceID: recipe.id, in: namespace))
        }
    }
    
    private var shareText: String {
        let time = recipe.totalTime.formatted(.recipeTime)
        let ingredients = recipe.ingredients
            .map { "- \($0)" }
            .joined(separator: "\n")
        let steps = recipe.instructions.enumerated()
            .map { "\($0.offset + 1). \($0.element)" }
            .joined(separator: "\n")

        return """
        \(recipe.name)
        \(String(localized: "Total time")): \(time)

        \(String(localized: "Ingredients"))
        \(ingredients)

        \(String(localized: "Instructions"))
        \(steps)
        """
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
    NavigationStack {
        RecipeDetailView(recipe: .previewSample)
    }
}

#Preview("Accesibilidad XL", traits: .modifier(RecipesPreviewData())) {
    NavigationStack {
        RecipeDetailView(recipe: Recipe.previewSample)
    }
    .environment(\.dynamicTypeSize, .accessibility3)
}
