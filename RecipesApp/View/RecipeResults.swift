//
//  RecipeResults.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 22/11/2026.
//

import SwiftUI
import SwiftData

/// Resultados de RecipeList, la @Query se construye en el init con el ámbito, la búsqueda y el límite de la página:
/// cuando cambia cualquiera de ellos, SwiftUI vuelve a crear la vista con una consulta nueva.
/// El filtrado lo hace la base de datos, no un filter en memoria. no me gusta no saber usar offset/limit
struct RecipeResults: View {
    @Query private var recipes: [Recipe]

    private let scope: RecipeScope
    private let searchText: String
    private let hasQuery: Bool
    private let hasCuisineFilter: Bool
    /// Binding para que el botón "Quitar filtros" del estado vacío pueda limpiar el filtro de RecipeList.
    @Binding private var selectedCuisines: Set<String>
    private let limit: Int
    private let namespace: Namespace.ID
    private let onReachEnd: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    /// es solo para List (iOS 26), para poder hacer el visualeffect.
    @State private var visibleFrame: CGRect = .zero

    init(scope: RecipeScope,
         searchText: String,
         sortField: RecipeSortField = .standard,
         sortDirection: RecipeSortDirection = .ascending,
         selectedCuisines: Binding<Set<String>> = .constant([]),
         limit: Int,
         namespace: Namespace.ID,
         onReachEnd: @escaping () -> Void) { //practicando escaping
        let query = searchText.trimmingCharacters(in: .whitespaces)

        let favoritesOnly = scope == .saved
        let hasQuery = !query.isEmpty

        // Constante (Array): #Predicate solo puede usar constantes del ámbito
        let cuisines = Array(selectedCuisines.wrappedValue)
        let hasCuisineFilter = !cuisines.isEmpty

        let predicate = #Predicate<Recipe> { recipe in
            (!favoritesOnly || recipe.isFavorite) &&
            (!hasQuery || recipe.name.localizedStandardContains(query)) &&
            (!hasCuisineFilter || cuisines.contains(recipe.cuisine))
        }
    
        let order = sortDirection.sortOrder
        let sortBy: [SortDescriptor<Recipe>] = switch sortField {
        case .standard:
            [SortDescriptor(\.recipeID)]
        case .name:
            [SortDescriptor(\.name, comparator: .localizedStandard, order: order),
             SortDescriptor(\.recipeID)]
        case .cuisine:
            [SortDescriptor(\.cuisine, comparator: .localizedStandard, order: order),
             SortDescriptor(\.name, comparator: .localizedStandard),
             SortDescriptor(\.recipeID)]
        }

        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sortBy)
        descriptor.fetchLimit = limit
        
        _recipes = Query(descriptor, animation: .default) // dice anima pero no veo yo

        self.scope = scope
        self.searchText = query
        self.hasQuery = hasQuery
        self.hasCuisineFilter = hasCuisineFilter
        _selectedCuisines = selectedCuisines
        self.limit = limit
        self.namespace = namespace
        self.onReachEnd = onReachEnd
    }

    var body: some View {
        recipesContent(reduceMotion: reduceMotion)
            .overlay {
                if recipes.isEmpty {
                    if hasQuery {
                        ContentUnavailableView.search(text: searchText)
                    } else if hasCuisineFilter {
                        ContentUnavailableView {
                            Label("No Results", systemImage: "line.3.horizontal.decrease.circle")
                        } description: {
                            Text("No recipes match the selected cuisines.")
                        } actions: {
                            Button("Clear Filters") {
                                selectedCuisines.removeAll()
                            }
                        }
                    } else if scope == .saved {
                        ContentUnavailableView(
                            "No Saved Recipes",
                            systemImage: "bookmark",
                            description: Text("Recipes you save will appear here.")
                        )
                    }
                }
            }
    }

    /// Contenedor de la lista según la versión de iOS.
    /// - iOS 27: ScrollView + LazyVStack, con scrollTransition y swipe gracias a swipeActionsContainer().
    /// - iOS 26: List, porque swipeActions solo funciona en List. scrollTransition no funciona en List,
    ///   así que el mismo efecto se calcula con visualEffect y la posición de cada tarjeta.
    @ViewBuilder
    private func recipesContent(reduceMotion: Bool) -> some View {
        if #available(iOS 27, *) {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(recipes) { recipe in
                        recipeRow(recipe)
                            .scrollTransition { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity || reduceMotion ? 1 : 0.92)
                                    .opacity(phase.isIdentity ? 1 : 0.6)
                            }
                    }
                }
                .padding()
            }
            .swipeActionsContainer()
        } else {
            List(recipes) { recipe in
                recipeRow(recipe)
                    .visualEffect { [visibleFrame] content, proxy in
                        let frame = proxy.frame(in: .global)

                        let outside = max(visibleFrame.minY - frame.minY,
                                          frame.maxY - visibleFrame.maxY, 0)
                        let progress = frame.height > 0 ? min(outside / frame.height, 1) : 0

                        return content
                            .scaleEffect(reduceMotion ? 1 : 1 - progress * 0.08)
                            .opacity(1 - progress * 0.4)
                    }
                    .listRowInsets(.horizontal, 16)
                    .listRowInsets(.vertical, 8)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .navigationLinkIndicatorVisibility(.hidden)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { frame in
                visibleFrame = frame
            }
        }
    }

    private func recipeRow(_ recipe: Recipe) -> some View {
        let isSaved = recipe.isFavorite
        let title: LocalizedStringKey = isSaved ? "Remove from Saved" : "Save"
        let icon = isSaved ? "bookmark.slash" : "bookmark"

        let tint: Color = isSaved ? .gray : .orange

        return NavigationLink(value: recipe) {
            RecipeCelda(recipe: recipe, isSaved: isSaved) {
                toggleFavorite(recipe)
            }
            .matchedTransitionSource(id: recipe.id, in: namespace)
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .leading) {
            Button {
                toggleFavorite(recipe)
            } label: {
                Label(title, systemImage: icon)
            }
            .tint(tint)
        }
        .onAppear {
            loadMoreIfNeeded(after: recipe)
        }
    }

    /// Cambia el favorito directamente en el modelo. El mainContext guarda solo???
    private func toggleFavorite(_ recipe: Recipe) {
        withAnimation {
            recipe.isFavorite.toggle()
        }
    }

    /// Paginación: si aparece la última tarjeta y la página estaba llena, puede haber más.
    ///  debe estar otra forma pero no se como hacerlo
    private func loadMoreIfNeeded(after recipe: Recipe) {
        guard recipe == recipes.last, recipes.count == limit else { return }
        onReachEnd()
    }
}

#Preview("All", traits: .modifier(RecipesPreviewData())) {
    @Previewable @Namespace var namespace
    NavigationStack {
        RecipeResults(scope: .all, searchText: "", limit: RecipeList.pageSize, namespace: namespace) {}
            .background(Color(.systemGroupedBackground))
    }
}

#Preview("Saved", traits: .modifier(RecipesPreviewData())) {
    @Previewable @Namespace var namespace
    NavigationStack {
        RecipeResults(scope: .saved, searchText: "", limit: RecipeList.pageSize, namespace: namespace) {}
            .background(Color(.systemGroupedBackground))
    }
}
