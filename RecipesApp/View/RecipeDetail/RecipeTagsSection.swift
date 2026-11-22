//
//  RecipeTagsSection.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 22/11/2026.
//

import SwiftUI

/// Sección de cápsulas , si no hay ninguna la sección no se muestra.
struct RecipeTagsSection: View {
    let title: LocalizedStringKey
    let tags: [String]
    let background: Color

    @ScaledMetric private var spacing = 8.0

    init(_ title: LocalizedStringKey, tags: [String], background: Color = Color(.tertiarySystemFill)) {
        self.title = title
        self.tags = tags
        self.background = background
    }

    var body: some View {
        if !tags.isEmpty {
            Section(title) {
                FlowLayout(spacing: spacing, lineSpacing: spacing) {
                    ForEach(tags, id: \.self) { tag in
                        TagCapsule(text: tag, background: background)
                    }
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}

#Preview {
    List {
        RecipeTagsSection("Meal type", tags: ["Dinner", "Lunch"], background: .orange.opacity(0.2))
        RecipeTagsSection("Tags", tags: ["Pizza", "Italian", "Vegetarian", "Quick"])
    }
    .listStyle(.insetGrouped)
}
