//
//  Recipe.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 13/11/2026.
//

import Foundation

struct RecipesResponse {
    let recipes: [Recipe]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Recipe: Identifiable, Hashable {
    let id: Int
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let prepTimeMinutes: Int
    let cookTimeMinutes: Int
    let servings: Int
    let difficulty: String
    let cuisine: String
    let caloriesPerServing: Int
    let tags: [String]
    let userId: Int
    let image: URL?
    let rating: Double
    let reviewCount: Int
    let mealType: [String]

    var totalMinutes: Int { prepTimeMinutes + cookTimeMinutes }

    var prepTime: Duration { .seconds(prepTimeMinutes * 60) }
    var cookTime: Duration { .seconds(cookTimeMinutes * 60) }
    var totalTime: Duration { .seconds(totalMinutes * 60) }
    var caloriesPerServingMeasurement: Measurement<UnitEnergy> {
        Measurement(value: Double(caloriesPerServing), unit: .kilocalories)
    }
}

extension FormatStyle where Self == Duration.UnitsFormatStyle {
    static var recipeTime: Self {
        .units(allowed: [.hours, .minutes], width: .abbreviated)
    }
}

extension Recipe {
    static let previewSample = Recipe(
        id: 1,
        name: "Classic Margherita Pizza",
        ingredients: [
            "Pizza dough",
            "Tomato sauce",
            "Fresh mozzarella cheese",
            "Fresh basil leaves",
            "Olive oil",
            "Salt and pepper to taste"
        ],
        instructions: [
            "Preheat the oven to 475°F (245°C).",
            "Roll out the pizza dough and spread tomato sauce evenly.",
            "Top with slices of fresh mozzarella and fresh basil leaves.",
            "Drizzle with olive oil and season with salt and pepper.",
            "Bake in the preheated oven for 12-15 minutes or until the crust is golden brown.",
            "Slice and serve hot."
        ],
        prepTimeMinutes: 20,
        cookTimeMinutes: 15,
        servings: 4,
        difficulty: "Easy",
        cuisine: "Italian",
        caloriesPerServing: 300,
        tags: ["Pizza", "Italian"],
        userId: 166,
        image: URL(string: "https://cdn.dummyjson.com/recipe-images/1.webp"),
        //image: URL(string: "https://starwarsgallery.netlify.app/assets/starships/199990.jpg"),
        rating: 4.6,
        reviewCount: 98,
        mealType: ["Dinner",        "Lunch with",
                   "Dinner soap del to","cos","asbc"]
    )
}
