//
//  Recipe+Share.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 22/11/2026.
//

import Foundation

extension Recipe {
    /// Texto para compartir la receta (ShareLink)
    var shareText: String {
        let time = totalTime.formatted(.recipeTime)
        let ingredientList = ingredients
            .map { "- \($0)" }
            .joined(separator: "\n")
        let steps = instructions.enumerated()
            .map { "\($0.offset + 1). \($0.element)" }
            .joined(separator: "\n")

        return """
        \(name)
        \(String(localized: "Total time")): \(time)

        \(String(localized: "Ingredients"))
        \(ingredientList)

        \(String(localized: "Instructions"))
        \(steps)
        """
    }
}
