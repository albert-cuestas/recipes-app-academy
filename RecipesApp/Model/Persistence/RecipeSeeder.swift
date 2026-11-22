//
//  RecipeSeeder.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 22/11/2026.
//

import Foundation
import SwiftData

/// Carga inicial de datos: si la base de datos está vacía, la llena con el JSON.
struct RecipeSeeder {
    /// - Parameters:
    ///   - context: contexto donde insertar las recetas.
    ///   - file: nombre del JSON en el bundle. En laas previews pasamos el "recetas-tests" con el previewdata.
    static func seedIfNeeded(in context: ModelContext, file: String = "recetas") throws(RecipeError) {
    
        do {
            guard try context.fetchCount(FetchDescriptor<Recipe>()) == 0 else { return }
        } catch {
            throw .general(error)
        }

        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            throw .urlNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(RecipesResponseDTO.self, from: data)
            for dto in response.recipes {
                context.insert(dto.toRecipe)
            }
            try context.save()
        } catch let error as DecodingError {
            throw .json(error.localizedDescription)
        } catch {
            throw .general(error)
        }
    }
}
