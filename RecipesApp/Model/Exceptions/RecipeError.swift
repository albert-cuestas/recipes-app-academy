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
            String(localized: "Invalid URL")
        case .json(let string):
            String(localized: "Couldn't read the recipe data: \(string)")
        case .general(let error):
            String(localized: "Something went wrong: \(error.localizedDescription)")
        }
    }
}
