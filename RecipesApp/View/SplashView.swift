//
//  SplashView.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 24) {
              Image("Logo")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 250, height: 250)
                  .clipShape(.rect(cornerRadius: 26, style: .continuous))
                  .accessibilityHidden(true)   // decorativo

              ProgressView("Cargando recetas")
                .foregroundStyle(.launchText)
                .controlSize(.large)
                .tint(.launchText)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color("LaunchBackground"))
    }
}

#Preview {
    SplashView()
}
