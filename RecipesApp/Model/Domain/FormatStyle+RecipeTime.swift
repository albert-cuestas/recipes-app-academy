//
//  FormatStyle+RecipeTime.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 22/11/2026.
//

import Foundation


extension FormatStyle where Self == Duration.UnitsFormatStyle {
    nonisolated static var recipeTime: Self {
        .units(allowed: [.hours, .minutes], width: .abbreviated)
    }
}
