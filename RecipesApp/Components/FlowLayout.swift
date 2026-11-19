//
//  FlowLayout.swift
//  RecipesApp
//
//  Created by Albert Cuestas Casas on 19/11/2026.
//

import SwiftUI


struct FlowLayout: Layout {
    var spacing: CGFloat = 8       // entre cápsulas
    var lineSpacing: CGFloat = 8   // entre líneas

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        arrange(maxWidth: proposal.width ?? .infinity, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(maxWidth: bounds.width, subviews: subviews)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY),
                proposal: ProposedViewSize(frame.size)
            )
        }
    }

    /// Calcula la posición de cada subvista y el tamaño total.
    private func arrange(maxWidth: CGFloat, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        var frames: [CGRect] = []
        var x: CGFloat = 0, y: CGFloat = 0
        var lineHeight: CGFloat = 0, usedWidth: CGFloat = 0

        for subview in subviews {
            // Nunca más ancha que el contenedor: una etiqueta muy larga se parte en dos líneas
            let size = subview.sizeThatFits(ProposedViewSize(width: maxWidth, height: nil))
            if x > 0 && x + size.width > maxWidth {   // no cabe: salto de línea
                x = 0
                y += lineHeight + lineSpacing
                lineHeight = 0
            }
            frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
            usedWidth = max(usedWidth, x + size.width)
            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
        return (CGSize(width: usedWidth, height: y + lineHeight), frames)
    }
}
