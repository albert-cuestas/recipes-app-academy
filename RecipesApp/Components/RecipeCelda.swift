//
//  RecipeCelda.swift
//  MyApp
//
//  Created by Albert Cuestas Casas on 13/11/2026.
//

import SwiftUI

struct RecipeCelda: View {
    let recipe: Recipe
    var isSaved = false
    /// Acción del botón de guardar. Si es nil (previews, otras pantallas), el botón no se muestra.
    var onToggleSaved: (() -> Void)? = nil
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private let cornerRadius: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            details.padding(16)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
        .accessibilityValue(isSaved ? Text("Bookmarked") : Text(verbatim: ""))
        .accessibilityAction(named: isSaved ? Text("Remove from Saved") : Text("Save")) {
            onToggleSaved?()
        }
    }
    
    private var header: some View {
        RecipeImage(url: recipe.image)
            .overlay(alignment: .topTrailing) {
                if let onToggleSaved {
                    SaveRecipeButton(isSaved: isSaved, action: onToggleSaved)
                        .padding(8)
                        .accessibilityHidden(true)
                }
            }
            .overlay(alignment: .bottomLeading) {
                Label(recipe.servings.formatted(), systemImage: "person.2.fill")
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.gray.opacity(0.85), in: .capsule)
                    .padding(8)
            }
    }
    
    private var details: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(recipe.name)
                .font(.title3.bold())
                .lineLimit(2)
            
            Text(recipe.cuisine)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            metadataRow.padding(.top, 4)
        }
    }
    
    private var metadataRow: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
        ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4))
        : AnyLayout(HStackLayout())
        
        return layout {
            Label {
                Text(recipe.totalTime, format: .recipeTime)
            } icon: {
                Image(systemName: "clock")
            }
            
            if !dynamicTypeSize.isAccessibilitySize { Spacer() }
            
            Label(
                recipe.rating.formatted(.number.precision(.fractionLength(1))),
                systemImage: "star.fill"
            )
            .foregroundStyle(.orange)
        }
        .font(.subheadline)
    }
    
    private var accessibilityText: Text {
        let rating = recipe.rating.formatted(.number.precision(.fractionLength(1)))
        let time = recipe.totalTime.formatted(.units(allowed: [.hours, .minutes], width: .wide))
        let servings = String(localized: "\(recipe.servings) servings")
        
        return Text("Recipe photo and description: \(recipe.name), \(recipe.cuisine) cuisine, \(time), \(servings), rated \(rating) out of 5")
    }
}

#Preview(traits: .modifier(RecipesPreviewData())) {
    RecipeCelda(recipe: Recipe.previewSample).padding()
}

#Preview("Guardada", traits: .modifier(RecipesPreviewData())) {
    @Previewable @State var isSaved = true
    RecipeCelda(recipe: Recipe.previewSample, isSaved: isSaved) {
        isSaved.toggle()
    }
    .padding()
}

#Preview("Accesibilidad XL", traits: .modifier(RecipesPreviewData())) {
    ScrollView {
        RecipeCelda(recipe: Recipe.previewSample)
            .padding()
    }
    .environment(\.dynamicTypeSize, .accessibility3)
}

#Preview("Modo oscuro", traits: .modifier(RecipesPreviewData())) {
    ScrollView {
        RecipeCelda(recipe: Recipe.previewSample)
            .padding()
    }
    .background(Color(.systemGroupedBackground))
    .preferredColorScheme(.dark)
}
