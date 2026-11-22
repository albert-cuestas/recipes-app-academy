//
//  RecipeDetailView.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI

/// Detalle de una receta. 
struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var isShowingImage = false
    @Namespace private var namespace

    var body: some View {
        List {
            RecipeHeaderSection(recipe: recipe, namespace: namespace) {
                isShowingImage = true
            }
            RecipeOverviewSection(recipe: recipe)
            RecipeIngredientsSection(ingredients: recipe.ingredients)
            RecipeInstructionsSection(steps: recipe.instructions)
            RecipeTagsSection("Meal type", tags: recipe.mealType, background: .orange.opacity(0.2))
            RecipeTagsSection("Tags", tags: recipe.tags)
        }
        .listStyle(.insetGrouped)
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ShareLink(item: recipe.shareText, subject: Text(recipe.name))
        }
        .sheet(isPresented: $isShowingImage) {
            RecipeImageViewer(url: recipe.image, title: recipe.name)
                .navigationTransition(.zoom(sourceID: recipe.id, in: namespace))
        }
    }
}

#Preview(traits: .modifier(RecipesPreviewData())) {
    NavigationStack {
        RecipeDetailView(recipe: .previewSample)
    }
}

#Preview("Accesibilidad XL", traits: .modifier(RecipesPreviewData())) {
    NavigationStack {
        RecipeDetailView(recipe: .previewSample)
    }
    .environment(\.dynamicTypeSize, .accessibility3)
}
