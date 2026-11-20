//
//  MainTabView.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 20/11/2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Recetas", systemImage: "fork.knife") {
                RecipeList()
            }

            Tab("Guardadas", systemImage: "bookmark") {
                SavedRecipesView()
            }

            Tab("Perfil", systemImage: "person.crop.circle") {
                ProfileView()
            }
        }
    }
}

private struct SavedRecipesView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Sin recetas guardadas",
                systemImage: "bookmark",
                description: Text("Las recetas que guardes aparecerán aquí.")
            )
            .navigationTitle("Guardadas")
        }
    }
}

private struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Perfil",
                systemImage: "person.crop.circle",
                description: Text("Próximamente podrás gestionar tu perfil aquí.")
            )
            .navigationTitle("Perfil")
        }
    }
}

#Preview(traits: .modifier(RecipesPreviewData())) {
    MainTabView()
}
