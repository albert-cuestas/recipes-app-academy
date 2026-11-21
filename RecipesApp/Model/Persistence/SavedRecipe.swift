//
//  SavedRecipe.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 21/11/2026.
//

import Foundation
import SwiftData

@Model
final class SavedRecipe {
    var recipeID: Int
    var savedAt: Date

    init(recipeID: Int, savedAt: Date = .now) {
        self.recipeID = recipeID
        self.savedAt = savedAt
    }
}

extension ModelContainer {
    static func recipes(inMemory: Bool = false) throws -> ModelContainer {
        try ModelContainer(for: SavedRecipe.self,
                           configurations: ModelConfiguration(isStoredInMemoryOnly: inMemory))
    }
}
