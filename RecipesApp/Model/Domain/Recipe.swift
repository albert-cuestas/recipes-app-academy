//
//  Recipe.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 13/11/2026.
//

import Foundation
import SwiftData

/// Receta persistida en SwiftData. Es el modelo que usan directamente las vistas (MV con @Query).
@Model
final class Recipe {
    /// ID de la receta en el JSON. El `id` de Identifiable lo aporta SwiftData (persistentModelID).
    @Attribute(.unique) var recipeID: Int
    var name: String
    var ingredients: [String]
    var instructions: [String]
    var prepTimeMinutes: Int
    var cookTimeMinutes: Int
    var servings: Int
    var difficulty: String
    var cuisine: String
    var caloriesPerServing: Int
    var tags: [String]
    var userId: Int
    var image: URL?
    var rating: Double
    var reviewCount: Int
    var mealType: [String]
    var isFavorite: Bool

    init(recipeID: Int,
         name: String,
         ingredients: [String],
         instructions: [String],
         prepTimeMinutes: Int,
         cookTimeMinutes: Int,
         servings: Int,
         difficulty: String,
         cuisine: String,
         caloriesPerServing: Int,
         tags: [String],
         userId: Int,
         image: URL?,
         rating: Double,
         reviewCount: Int,
         mealType: [String],
         isFavorite: Bool = false) {
        self.recipeID = recipeID
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.prepTimeMinutes = prepTimeMinutes
        self.cookTimeMinutes = cookTimeMinutes
        self.servings = servings
        self.difficulty = difficulty
        self.cuisine = cuisine
        self.caloriesPerServing = caloriesPerServing
        self.tags = tags
        self.userId = userId
        self.image = image
        self.rating = rating
        self.reviewCount = reviewCount
        self.mealType = mealType
        self.isFavorite = isFavorite
    }
}

