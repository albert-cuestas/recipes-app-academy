//
//  RecipesVM.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 18/11/2026.
//

import SwiftUI
import SwiftData

@Observable
final class RecipesVM {
    private(set) var recipes: [Recipe] = []
    private(set) var error: RecipeError?
    private let repository: RepositoryProtocol
    /// Se guarda el contenedor (no solo el contexto) para que viva mientras exista el VM.
    private let container: ModelContainer
    /// Contexto del MainActor, igual que este VM.
    private var context: ModelContext { container.mainContext }
    
    /// IDs de las recetas guardadas. Copia en memoria de SwiftData para que las vistas consulten rápido.
    private(set) var savedIDs: Set<Int> = []

    /// Recetas de un ámbito (todas o guardadas), filtradas por nombre.
    /// La búsqueda no distingue mayúsculas (localizedStandardContains).
    func recipes(in scope: RecipeScope, matching query: String) -> [Recipe] {
        let base = switch scope {
        case .all: recipes
        case .saved: recipes.filter { savedIDs.contains($0.id) }
        }
        let query = query.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return base }
        return base.filter { $0.name.localizedStandardContains(query) }
    }

    func isSaved(_ recipe: Recipe) -> Bool {
        savedIDs.contains(recipe.id)
    }

    /// Guarda o quita la receta en SwiftData y actualiza savedIDs.
    func toggleSaved(_ recipe: Recipe) {
        let id = recipe.id
        if savedIDs.contains(id) {
            let all = (try? context.fetch(FetchDescriptor<SavedRecipe>())) ?? []
            for saved in all where saved.recipeID == id {
                context.delete(saved)
            }
        } else {
            context.insert(SavedRecipe(recipeID: id))
        }

        if context.hasChanges {
            try? context.save()
        }
        loadSavedIDs()
    }

    private func loadSavedIDs() {
        let all = (try? context.fetch(FetchDescriptor<SavedRecipe>())) ?? []
        savedIDs = Set(all.map(\.recipeID))
    }

    init(repository: RepositoryProtocol = Repository(), container: ModelContainer) {
        self.repository = repository
        self.container = container
        loadSavedIDs()
    }
    
    @MainActor
    func loadRecipes() async {
        error = nil
        do {
            recipes = try await repository.getRecipes()
        } catch {
            guard !Task.isCancelled else { return }
            self.error = error
            recipes = []
        }
    }
}
