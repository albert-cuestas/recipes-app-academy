//
//  RecipesPreviewData.swift
//  MyApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI

#if DEBUG
/// Carga las recetas de prueba una sola vez y las inyecta en las previews que lo usen.
/// El preview system guarda en caché el contexto y lo reutiliza entre previews
struct RecipesPreviewData: PreviewModifier {
    static func makeSharedContext() async throws -> RecipesVM {
        let vm = RecipesVM(repository: RepositoryTest())
        await vm.loadRecipes()
        return vm
    }

    func body(content: Content, context: RecipesVM) -> some View {
        content.environment(context)
    }
}
#endif
