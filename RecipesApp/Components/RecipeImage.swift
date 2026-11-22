//
//  RecipeImage.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI

struct RecipeImage: View {
    let url: URL?

    @ScaledMetric(relativeTo: .largeTitle) private var placeholderIconSize = 56.0

    var body: some View {
        Color.clear
            .aspectRatio(16 / 9, contentMode: .fit)
            .overlay {
                AsyncImage(url: url) { phase in
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
            .accessibilityHidden(true)
    }
}

#Preview(traits: .modifier(RecipesPreviewData())) {
    RecipeImage(url: Recipe.previewSample.image)
}
