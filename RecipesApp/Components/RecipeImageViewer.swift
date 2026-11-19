//
//  RecipeImageViewer.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI

struct RecipeImageViewer: View {
    let url: URL?
    let title: String
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .controlSize(.large)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()   
                case .failure:
                    ContentUnavailableView(
                        "No se ha podido cargar la imagen",
                        systemImage: "photo"
                    )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeImageViewer(url: Recipe.previewSample.image, title: Recipe.previewSample.name)
}
