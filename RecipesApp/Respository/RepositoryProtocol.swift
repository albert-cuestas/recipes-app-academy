//
//  RepositoryProtocol.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 18/11/2026.
//

import Foundation

protocol RepositoryProtocol {
    var file: String { get }
    func getRecipes() async throws(RecipeError) -> [Recipe]
}

extension RepositoryProtocol {
    var file: String { "recetas" }

    func getRecipes() async throws(RecipeError) -> [Recipe] {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            throw .urlNotFound
        }
        do {
            // Retardo artificial para ver la splash mientras se carga desde un JSON local.
            // Quitarlo cuando se use la API real.
            try await Task.sleep(for: .seconds(1.5))

            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(RecipesResponseDTO.self, from: data)
            return response.recipes.map(\.toRecipe)
        } catch let error as DecodingError {
            throw .json(error.localizedDescription)
        } catch {
            throw .general(error)
        }
    }
}
