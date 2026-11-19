//
//  RecipeDetailView.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var isShowingImage = false
    @Namespace private var namespace
    
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
                                .padding(10)
                                .glassEffect(in: .circle)
                                .matchedTransitionSource(id: recipe.id, in: namespace)
                                .padding(12)
                                .accessibilityHidden(true)
                        }
                }
                .accessibilityLabel("Ver imagen ampliada")
                .listRowInsets(EdgeInsets())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(.title2.bold())
                    Text(recipe.cuisine)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Datos clave
            Section("Resumen") {
                LabeledContent("Dificultad", value: recipe.difficulty)
                LabeledContent("Preparación", value: recipe.prepTime, format: .recipeTime)
                LabeledContent("Cocción", value: recipe.cookTime, format: .recipeTime)
                LabeledContent("Tiempo total", value: recipe.totalTime, format: .recipeTime)
                LabeledContent("Raciones", value: recipe.servings, format: .number)
                LabeledContent(
                    "Calorías por ración",
                    value: recipe.caloriesPerServingMeasurement,
                    format: .measurement(width: .abbreviated, usage: .asProvided)
                )
                LabeledContent("Valoración") {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                        Text(ratingText)
                    }
                    .foregroundStyle(.orange)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(ratingText) sobre 5, \(recipe.reviewCount) opiniones")
                }
            }
            
            if !recipe.ingredients.isEmpty {
                Section("Ingredientes") {
                    // Identidad por posición: un ingrediente puede repetirse en la lista.
                    ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { _, ingredient in
                        Text(ingredient)
                    }
                }
            }
            
            if !recipe.instructions.isEmpty {
                Section("Preparación") {
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
            
            if !recipe.tags.isEmpty || !recipe.mealType.isEmpty {
                Section("Etiquetas") {
                    if !recipe.mealType.isEmpty {
                        LabeledContent("Tipo de comida", value: recipe.mealType.joined(separator: ", "))
                    }
                    if !recipe.tags.isEmpty {
                        LabeledContent("Etiquetas", value: recipe.tags.joined(separator: ", "))
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingImage) {
            RecipeImageViewer(url: recipe.image, title: recipe.name)
                // Destino: la sheet sale desde la lupa
                .navigationTransition(.zoom(sourceID: recipe.id, in: namespace))
        }
    }
    
    private var ratingText: String {
        let rating = recipe.rating.formatted(.number.precision(.fractionLength(1)))
        return "\(rating) (\(recipe.reviewCount))"
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: .previewSample)
    }
}
