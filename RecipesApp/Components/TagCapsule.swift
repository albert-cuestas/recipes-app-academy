//
//  TagCapsule.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI

struct TagCapsule: View {
    let text: String
    var background: Color = Color(.tertiarySystemFill)

    var body: some View {
        Text(text)
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(background, in: .capsule)
    }
}

#Preview {
    TagCapsule(text: "djkekehw")
}
