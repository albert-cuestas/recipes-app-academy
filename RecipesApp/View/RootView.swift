//
//  RootView.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI

struct RootView: View {
    @Environment(RecipesVM.self) private var controller

    private var isLoading: Bool {
        controller.recipes.isEmpty && controller.error == nil
    }

    var body: some View {
        ZStack {
            if isLoading {
                SplashView()
                    .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.3), value: isLoading)
        .task { await controller.loadRecipes() }
    }
}

#Preview {
    RootView()
        .environment(RecipesVM.preview())
}
