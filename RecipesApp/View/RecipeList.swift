//
//  RecipeList.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 18/11/2026.
//

import SwiftUI

struct RecipeList: View {
    @Environment(RecipesVM.self) private var controller
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var namespace
    
    var body: some View {
        let reduceMotion = reduceMotion
        @Bindable var controller = controller
        
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(controller.filteredRecipes) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeCelda(recipe: recipe)
                                 .matchedTransitionSource(id: recipe.id, in: namespace)
                        }
                        .buttonStyle(.plain)
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity || reduceMotion ? 1 : 0.92)
                                .opacity(phase.isIdentity ? 1 : 0.6)
                        }
                    }
                }
                .padding()
            }.refreshable {
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
                } else if controller.filteredRecipes.isEmpty && !controller.searchText.isEmpty {
                    ContentUnavailableView.search(text: controller.searchText)
                }
            }
            .navigationTitle("Recipes")
            .searchable(text: $controller.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search recipes")
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
                    .navigationTransition(.zoom(sourceID: recipe.id, in: namespace))
            }
        }
    }
}

#Preview(traits: .modifier(RecipesPreviewData())) {
    TabView{
        Tab("Recipes", systemImage: "fork.knife") {
            RecipeList()
        }
    }
}
