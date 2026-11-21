//
//  RecipesPreviewData.swift
//  MyApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI
import SwiftData

#if DEBUG
extension RecipesVM {
    /// VM para previews: recetas de prueba y base de datos en memoria (no toca los datos reales).
    static func preview() -> RecipesVM {
        do {
            return RecipesVM(repository: RepositoryTest(), container: try .recipes(inMemory: true))
        } catch {
            fatalError("Couldn't create the preview container: \(error)")
        }
    }
}

/// Carga las recetas de prueba una sola vez y las inyecta en las previews que lo usen.
/// El preview system guarda en caché el contexto y lo reutiliza entre previews
struct RecipesPreviewData: PreviewModifier {
    static func makeSharedContext() async throws -> RecipesVM {
        let vm = RecipesVM.preview()
        await vm.loadRecipes()
        return vm
    }

    func body(content: Content, context: RecipesVM) -> some View {
        content.environment(context)
    }
}
#endif
