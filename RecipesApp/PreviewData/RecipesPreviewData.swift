//
//  RecipesPreviewData.swift
//  MyApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI
import SwiftData

#if DEBUG
/// Para previews usamos esta db en memoria con las recetas de prueba.
/// Usa el mismo RecipeSeeder que la app, pero le pasamos el  "recetas-tests.json".
/// lo mando a container para que reutilizen entre previews, creo funciona pero no he sabia localizarlo bien
struct RecipesPreviewData: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: Recipe.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        try RecipeSeeder.seedIfNeeded(in: container.mainContext, file: "recetas-tests")
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}
#endif
