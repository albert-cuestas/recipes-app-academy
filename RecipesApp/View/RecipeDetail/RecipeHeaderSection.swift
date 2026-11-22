//
//  RecipeHeaderSection.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 22/11/2026.
//

import SwiftUI

/// Cabecera del detalle
struct RecipeHeaderSection: View {
    let recipe: Recipe

    let namespace: Namespace.ID
    let onShowImage: () -> Void

    var body: some View {
        Section {
            Button(action: onShowImage) {
                RecipeImage(url: recipe.image)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "plus.magnifyingglass")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)   // mismo tamaño que SaveRecipeButton
                            .glassEffect(in: .circle)
                            .matchedTransitionSource(id: recipe.id, in: namespace)
                            .padding(12)
                            .accessibilityHidden(true)
                    }
            }
            .accessibilityLabel("View larger image")
            .overlay(alignment: .topTrailing) {
                SaveRecipeButton(isSaved: recipe.isFavorite) {
                    recipe.isFavorite.toggle() // creo grava solo asi
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
    }
}

#Preview(traits: .modifier(RecipesPreviewData())) {
    @Previewable @Namespace var namespace
    List {
        RecipeHeaderSection(recipe: .previewSample, namespace: namespace) {}
    }
    .listStyle(.insetGrouped)
}
