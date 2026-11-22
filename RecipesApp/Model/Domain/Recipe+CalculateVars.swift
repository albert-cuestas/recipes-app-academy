//
//  Recipe+CalculateVars.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 22/11/2026.
//

import Foundation


extension Recipe {
    var totalMinutes: Int { prepTimeMinutes + cookTimeMinutes }

    var prepTime: Duration { .seconds(prepTimeMinutes * 60) }
    var cookTime: Duration { .seconds(cookTimeMinutes * 60) }
    var totalTime: Duration { .seconds(totalMinutes * 60) }
    var caloriesPerServingMeasurement: Measurement<UnitEnergy> {
        Measurement(value: Double(caloriesPerServing), unit: .kilocalories)
    }
}
