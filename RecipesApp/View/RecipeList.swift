//
//  RecipeList.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 18/11/2026.
//

import SwiftUI

/// Pantalla de lista de recetas: búsqueda, título y navegación.
/// La consulta a SwiftData la hace RecipeResults, porque el filtro de @Query
/// solo se puede fijar al crear la vista (y la búsqueda cambia con cada letra).
struct RecipeList: View {

    let scope: RecipeScope

    /// Recetas por pagina , no se como hacer offset y si se puede, en ios27 dice hay un observable nuevo docum
    static let pageSize = 20

    @State private var searchText = ""
    @State private var limit = RecipeList.pageSize
    @Namespace private var namespace

    private var navigationTitleKey: LocalizedStringKey {
        switch scope {
        case .all: "Recipes"
        case .saved: "Saved"
        }
    }

    var body: some View {
        NavigationStack {
            RecipeResults(scope: scope, searchText: searchText, limit: limit, namespace: namespace) {
                limit += Self.pageSize   // no me gusta pero acumulo
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(navigationTitleKey)
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search recipes")
            .onChange(of: searchText) {
                limit = Self.pageSize  // no me gusta pero acumulo
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
                    .navigationTransition(.zoom(sourceID: recipe.id, in: namespace))
            }
        }
    }
}

#Preview("Todas", traits: .modifier(RecipesPreviewData())) {
    TabView {
        Tab("Recipes", systemImage: "fork.knife") {
            RecipeList(scope: .all)
        }
    }
}

#Preview("Guardadas", traits: .modifier(RecipesPreviewData())) {
    TabView {
        Tab("Saved", systemImage: "bookmark") {
            RecipeList(scope: .saved)
        }
    }
}
