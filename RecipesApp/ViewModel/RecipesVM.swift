//
//  RecipesVM.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 18/11/2026.
//

import SwiftUI


@Observable
final class RecipesVM {
    var recipes: [Recipe] = []
    var error: RecipeError?
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol = Repository()) {
        self.repository = repository
    }
    
    func loadRecipes() async {
        do {
            recipes = try await  repository.getRecipes()
            self.error = nil
        } catch {
            self.error = error
            self.recipes = []
        }
    }
}
