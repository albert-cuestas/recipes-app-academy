//
//  RecipesVM.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 18/11/2026.
//

import SwiftUI

@Observable
final class RecipesVM {
    private(set) var recipes: [Recipe] = []
    private(set) var error: RecipeError?
    private let repository: RepositoryProtocol
    
    var searchText = ""

    // TEMPORAL (paso 1): en el paso 2 se sustituye por SwiftData
    private(set) var savedIDs: Set<Int> = []

    var filteredRecipes: [Recipe] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return recipes }
        return recipes.filter { $0.name.localizedStandardContains(query) }
    }

    func isSaved(_ recipe: Recipe) -> Bool {
        savedIDs.contains(recipe.id)
    }

    func toggleSaved(_ recipe: Recipe) {
        if savedIDs.remove(recipe.id) == nil {
            savedIDs.insert(recipe.id)
        }
    }

    init(repository: RepositoryProtocol = Repository()) {
        self.repository = repository
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
