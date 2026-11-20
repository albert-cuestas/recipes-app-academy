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

    var filteredRecipes: [Recipe] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return recipes }
        return recipes.filter { $0.name.localizedStandardContains(query) }
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
