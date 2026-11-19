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
            String(localized: "URL no válida")
        case .json(let string):
            String(localized: "Error en el JSON: \(string)")
        case .general(let error):
            String(localized: "Error general \(error.localizedDescription)")
        }
    }
}
