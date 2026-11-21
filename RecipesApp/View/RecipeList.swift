//
//  RecipeList.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 18/11/2026.
//

import SwiftUI

struct RecipeList: View {

    let scope: RecipeScope

    @Environment(RecipesVM.self) private var controller
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var namespace
    
    @State private var visibleFrame: CGRect = .zero
    
    @State private var searchText = ""

    
    private var visibleRecipes: [Recipe] {
        controller.recipes(in: scope, matching: searchText)
    }

    private var navigationTitleKey: LocalizedStringKey {
        switch scope {
        case .all: "Recipes"
        case .saved: "Saved"
        }
    }
    
    var body: some View {
        let reduceMotion = reduceMotion
        
        NavigationStack {
            recipesContent(reduceMotion: reduceMotion)
                .refreshable {
                    await controller.loadRecipes()
                }
                .background(Color(.systemGroupedBackground))
                .overlay {
                    if let error = controller.error {
                        ContentUnavailableView {
                            Label("Couldn't load recipes", systemImage: "exclamationmark.triangle")
                        } description: {
                            Text(error.localizedDescription)
                        } actions: {
                            Button("Try Again") {
                                Task { await controller.loadRecipes() }
                            }
                            .buttonStyle(.glassProminent)
                        }
                    } else if visibleRecipes.isEmpty {
                        if !searchText.isEmpty {
                            ContentUnavailableView.search(text: searchText)
                        } else if scope == .saved {
                            ContentUnavailableView(
                                "No Saved Recipes",
                                systemImage: "bookmark",
                                description: Text("Recipes you save will appear here.")
                            )
                        }
                    }
                }
                .navigationTitle(navigationTitleKey)
                .searchable(text: $searchText,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "Search recipes")
                .navigationDestination(for: Recipe.self) { recipe in
                    RecipeDetailView(recipe: recipe)
                        .navigationTransition(.zoom(sourceID: recipe.id, in: namespace))
                }
        }
    }
    
    /// Contenedor de la lista según la versión de iOS.
    /// - iOS 27+: ScrollView + LazyVStack, con scrollTransition y swipe gracias a swipeActionsContainer().
    /// - iOS 26: List, porque swipeActions solo funciona en List. scrollTransition no funciona en List,
    ///   así que el mismo efecto se calcula con visualEffect y la posición de cada tarjeta.
    @ViewBuilder
    private func recipesContent(reduceMotion: Bool) -> some View {
        if #available(iOS 27, *) {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(visibleRecipes) { recipe in
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
            List(visibleRecipes) { recipe in
                recipeRow(recipe)
                    .visualEffect { [visibleFrame] content, proxy in
                        let frame = proxy.frame(in: .global)
                        // Cuánto ha salido la tarjeta por arriba o por abajo (0 = entera dentro)
                        let outside = max(visibleFrame.minY - frame.minY,
                                          frame.maxY - visibleFrame.maxY, 0)
                        let progress = frame.height > 0 ? min(outside / frame.height, 1) : 0

                        return content
                            .scaleEffect(reduceMotion ? 1 : 1 - progress * 0.08)  // hasta 0,92
                            .opacity(1 - progress * 0.4)                          // hasta 0,6
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
        let isSaved = controller.isSaved(recipe)
        let title: LocalizedStringKey = isSaved ? "Remove from Saved" : "Save"
        let icon = isSaved ? "bookmark.slash" : "bookmark"
        let tint: Color = isSaved ? .gray : .orange
        
        return NavigationLink(value: recipe) {
            RecipeCelda(recipe: recipe, isSaved: isSaved) {
                toggleSaved(recipe)
            }
            .matchedTransitionSource(id: recipe.id, in: namespace)
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .leading) {
            Button {
                toggleSaved(recipe)
            } label: {
                Label(title, systemImage: icon)
            }
            .tint(tint)
        }
    }

    private func toggleSaved(_ recipe: Recipe) {
        withAnimation {
            controller.toggleSaved(recipe)
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
