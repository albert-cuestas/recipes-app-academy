//
//  SaveRecipeButton.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 21/11/2026.
//

import SwiftUI

/// Botón de guardar receta con Liquid Glass.
/// Es un control, así que el vidrio está justificado (HIG Materials: Liquid Glass es para
/// controles y navegación, no para contenido). Se usa en RecipeCelda y en RecipeDetailView.
struct SaveRecipeButton: View {
    let isSaved: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .font(.title3)
                .foregroundStyle(isSaved ? .red : .white)
                .frame(width: 44, height: 44)      // área táctil mínima de la HIG
                .glassEffect(in: .circle)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isSaved ? Text("Remove from Saved") : Text("Save"))
    }
}

#Preview {
    @Previewable @State var isSaved = false
    SaveRecipeButton(isSaved: isSaved) {
        isSaved.toggle()
    }
    .padding()
    .background(.orange)
}
