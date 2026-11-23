//
//  RecipeList.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 18/11/2026.
//

import SwiftUI
import SwiftData

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

    @AppStorage private var sortField: RecipeSortField
    @AppStorage private var sortDirection: RecipeSortDirection

    /// Cocinas elegidas en el filtro.
    @State private var selectedCuisines: Set<String> = []
    /// query de todas la cocinas, no seria lo mejor pero para seguir como si fuera json...
    @Query private var cuisineSources: [Recipe]

    init(scope: RecipeScope) {
        self.scope = scope
        // recupero valor guardado en settings app
        _sortField = AppStorage(wrappedValue: .standard, "sortField.\(scope)")
        _sortDirection = AppStorage(wrappedValue: .ascending, "sortDirection.\(scope)")

        // me aseguro que si es marcada solo esas cocinas no todas
        let favoritesOnly = scope == .saved
        var descriptor = FetchDescriptor<Recipe>(predicate: #Predicate { recipe in
            !favoritesOnly || recipe.isFavorite
        })
        descriptor.propertiesToFetch = [\.cuisine]
        _cuisineSources = Query(descriptor)
    }

    /// lo hago en un ser para asegurar no repitir
    private var cuisines: [String] {
        Set(cuisineSources.map(\.cuisine))
            .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    private var navigationTitleKey: LocalizedStringKey {
        switch scope {
        case .all: "Recipes"
        case .saved: "Saved"
        }
    }

    private var sortMenu: some View {
        Menu {
            // averigue lo binding creado y con render cada vez aplica comportambiento mejor esperar seleccionen 
            Section("Sort By") {
                ForEach(RecipeSortField.allCases) { field in
                    Toggle(isOn: Binding(
                        get: { sortField == field },
                        set: { isOn in if isOn { sortField = field } }
                    )) {
                        Text(field.title)
                    }
                    .menuActionDismissBehavior(field == .standard ? .enabled : .disabled)
                }
            }

            if sortField != .standard {
                Picker("Order", selection: $sortDirection) {
                    ForEach(RecipeSortDirection.allCases) { direction in
                        Text(direction.title).tag(direction)
                    }
                }
                .pickerStyle(.inline)
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }//.menuActionDismissBehavior(.disabled)
    }

    /// Botón Filtrar: Todas las cocinas quita el filtro de golpe
    private var filterMenu: some View {
        Menu {
            Toggle(isOn: Binding(
                get: { selectedCuisines.isEmpty },
                set: { isOn in if isOn { selectedCuisines.removeAll() } }
            )) {
                Text("All Cuisines")
            }
            .menuActionDismissBehavior(.enabled)

            Section {
                ForEach(cuisines, id: \.self) { cuisine in
                    Toggle(cuisine, isOn: Binding(
                        get: { selectedCuisines.contains(cuisine) },
                        set: { isOn in
                            if isOn {
                                selectedCuisines.insert(cuisine)
                            } else {
                                selectedCuisines.remove(cuisine)
                            }
                        }
                    ))
                    .menuActionDismissBehavior(.disabled)
                }
            }
        } label: {
            Label("Filter", systemImage: selectedCuisines.isEmpty
                  ? "line.3.horizontal.decrease.circle"
                  : "line.3.horizontal.decrease.circle.fill")
        }
        .accessibilityValue(selectedCuisines.isEmpty
                            ? Text(verbatim: "")
                            : Text("\(selectedCuisines.count) cuisines selected"))
    }

    var body: some View {
        NavigationStack {
            RecipeResults(scope: scope,
                          searchText: searchText,
                          sortField: sortField,
                          sortDirection: sortDirection,
                          selectedCuisines: $selectedCuisines,
                          limit: limit,
                          namespace: namespace) {
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
            .onChange(of: sortField) {
                limit = Self.pageSize
            }
            .onChange(of: sortDirection) {
                limit = Self.pageSize
            }
            .onChange(of: selectedCuisines) {
                limit = Self.pageSize
            }
            .toolbar {
                filterMenu.tint(selectedCuisines.isEmpty
                                ? Color.primary
                                : Color.accentColor)
                sortMenu
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
