//
//  RecipeInstructionsSection.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 22/11/2026.
//

import SwiftUI

/// Pasos de la receta, si no hay datos la sección no se muestra.
struct RecipeInstructionsSection: View {
    let steps: [String]

    var body: some View {
        if !steps.isEmpty {
            Section("Instructions") {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text("\(index + 1).")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                        Text(step)
                    }
                }
            }
        }
    }
}

#Preview {
    List {
        RecipeInstructionsSection(steps: [
            "Preheat the oven to 475°F (245°C).",
            "Roll out the pizza dough and spread tomato sauce evenly.",
            "Bake for 12-15 minutes."
        ])
    }
    .listStyle(.insetGrouped)
}
