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
    @ScaledMetric(relativeTo: .largeTitle) private var placeholderIconSize = 56.0
    private let cornerRadius: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            details.padding(16)
        }
        .background(.background, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
        .environment(\.locale, Locale(identifier: "es")) // esto deberia ser localizacion dle proyecto pero como mando solo la Zelda pues os lo pongo aqui para que probeis voiceover !!! 🤪
    }
    
    private var header: some View {
        Color.clear
            .aspectRatio(16 / 9, contentMode: .fit)
            .overlay {
                AsyncImage(url: recipe.image) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .controlSize(.large)
                            .tint(.secondary)
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: placeholderIconSize))
                            .foregroundStyle(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            .background(.quaternary)
            .clipped()
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
            Label("\(recipe.totalMinutes) min", systemImage: "clock")
            
            if !dynamicTypeSize.isAccessibilitySize { Spacer() }
            
            Label(
                recipe.rating.formatted(.number.precision(.fractionLength(1))),
                systemImage: "star.fill"
            )
            .foregroundStyle(.orange)
        }
        .font(.subheadline)
    }
    
    private var accessibilityText: String {
        let rating = recipe.rating.formatted(.number.precision(.fractionLength(1)))
        return "Foto y descripción de la receta: \(recipe.name), cocina \(recipe.cuisine), \(recipe.totalMinutes) minutos, valoración de \(rating) sobre 5"
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
