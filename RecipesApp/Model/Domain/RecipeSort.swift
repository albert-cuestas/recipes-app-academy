//
//  RecipeSort.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 22/11/2026.
//

import Foundation

enum RecipeSortField: String, CaseIterable, Identifiable {
    case standard
    case name
    case cuisine

    var id: Self { self }

    var title: LocalizedStringResource {
        switch self {
        case .standard: "Default"
        case .name: "Name"
        case .cuisine: "Cuisine"
        }
    }
}

enum RecipeSortDirection: String, CaseIterable, Identifiable {
    case ascending
    case descending

    var id: Self { self }

    var title: LocalizedStringResource {
        switch self {
        case .ascending: "A to Z"
        case .descending: "Z to A"
        }
    }

    var sortOrder: SortOrder {
        self == .ascending ? .forward : .reverse
    }
}
