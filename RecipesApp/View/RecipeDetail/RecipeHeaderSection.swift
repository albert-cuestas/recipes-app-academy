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

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

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

                metadataRow.padding(.top, 8)
            }
        }
    }

    private var metadataRow: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
        ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4))
        : AnyLayout(HStackLayout(spacing: 16))

        return layout {
            Label(recipe.totalTime.formatted(.recipeTime),systemImage: "clock")

            Label(recipe.servings.formatted(), systemImage: "person.2")
                .accessibilityLabel(Text("\(recipe.servings) servings"))
            

            if !dynamicTypeSize.isAccessibilitySize { Spacer() }

            Label(ratingText, systemImage: "star.fill")
                .foregroundStyle(.orange)
                .accessibilityLabel(Text("\(ratingValue) out of 5, \(reviewsText)"))
        }
        .font(.subheadline)
        .foregroundStyle(.primary)
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
    @Previewable @Namespace var namespace
    List {
        RecipeHeaderSection(recipe: .previewSample, namespace: namespace) {}
    }
    .listStyle(.insetGrouped)
}
