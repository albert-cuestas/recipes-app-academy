//
//  RecipeError.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 18/11/2026.
//

import Foundation

enum RecipeError: LocalizedError {
    case urlNotFound
    case json(String)
    case general(Error)
    
    var errorDescription: String? {
        switch self {
        case .urlNotFound:
            "URL no válida"
        case .json(let string):
            "Error en el JSON: \(string)"
        case .general(let error):
            "Error general \(error.localizedDescription)"
        }
    }
}
