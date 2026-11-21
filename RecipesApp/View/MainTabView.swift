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
            Tab("Recipes", systemImage: "fork.knife") {
                RecipeList(scope: .all)
            }

            Tab("Saved", systemImage: "bookmark") {
                RecipeList(scope: .saved)
            }

            Tab("Profile", systemImage: "person.crop.circle") {
                ProfileView()
            }
        }
    }
}

private struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Profile",
                systemImage: "person.crop.circle",
                description: Text("You'll be able to manage your profile here soon.")
            )
            .navigationTitle("Profile")
        }
    }
}

#Preview(traits: .modifier(RecipesPreviewData())) {
    MainTabView()
}
