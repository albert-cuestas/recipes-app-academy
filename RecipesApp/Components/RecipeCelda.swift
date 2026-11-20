//
//  RecipeCelda.swift
//  MyApp
//
//  Created by Albert Cuestas Casas on 13/11/2026.
//

import SwiftUI

struct RecipeCelda: View {
    let recipe: Recipe
    
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
    }
    
    private var header: some View {
        RecipeImage(url: recipe.image )
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
        
        return Text("Recipe photo and description: \(recipe.name), \(recipe.cuisine) cuisine, \(time), rated \(rating) out of 5")
    }
}

#Preview {
    RecipeCelda(recipe: Recipe.previewSample).padding()
}

#Preview("Accesibilidad XL") {
    ScrollView {
        RecipeCelda(recipe: Recipe.previewSample)
            .padding()
    }
    .environment(\.dynamicTypeSize, .accessibility3)
}

#Preview("Modo oscuro") {
    ScrollView {
        RecipeCelda(recipe: Recipe.previewSample)
            .padding()
    }
    .background(Color(.systemGroupedBackground))
    .preferredColorScheme(.dark)
}
