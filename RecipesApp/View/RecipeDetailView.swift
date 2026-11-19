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
                                .background(.ultraThinMaterial, in: Circle())
                                .padding(12)
                                .accessibilityHidden(true)
                        }
                }
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel("Ver imagen ampliada")
                .accessibilityAction { isShowingImage = true }
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
                LabeledContent("Preparación", value: "\(recipe.prepTimeMinutes) min")
                LabeledContent("Cocción", value: "\(recipe.cookTimeMinutes) min")
                LabeledContent("Tiempo total", value: "\(recipe.totalMinutes) min")
                LabeledContent("Raciones", value: recipe.servings, format: .number)
                LabeledContent("Calorías por ración", value: "\(recipe.caloriesPerServing) kcal")
                LabeledContent("Valoración") {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                        Text(ratingText)
                    }.foregroundStyle(.orange)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(ratingText) sobre 5, \(recipe.reviewCount) opiniones")
                }
            }
            
            if !recipe.ingredients.isEmpty {
                Section("Ingredientes") {
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                    }
                }
            }
            
            if !recipe.instructions.isEmpty {
                Section("Preparación") {
                    ForEach(recipe.instructions.indices, id: \.self) { index in
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text("\(index + 1).")
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                            Text(recipe.instructions[index])
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
