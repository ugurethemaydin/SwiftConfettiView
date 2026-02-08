//
//  FireworkDemo.swift
//  SwiftConfettiView
//
//  Created by Ugur Ethem AYDIN on 2026
//

import SwiftUI
import SwiftConfettiView

struct FireworkDemo: View {
    @State private var isActive = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                ConfettiView(
                    type: .star,
                    intensity: 0.8,
                    isActive: $isActive,
                    emitterOrigin: CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.4),
                    spread: 2 * .pi,
                    burstCount: 250,
                    hapticFeedback: true,
                    density: 2.0,
                    addDepth: true,
                    fadeOut: false
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)

                Button {
                    if !isActive { isActive = true }
                } label: {
                    Text(isActive ? "Boom!" : "Firework!")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .background(glassButtonBackground())
                }
                .allowsHitTesting(!isActive)
            }
        }
        .navigationTitle("Firework")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { isActive = false }
    }

    @ViewBuilder
    private func glassButtonBackground() -> some View {
        if #available(iOS 15.0, *) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        } else {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemGray5).opacity(0.7))
                .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        }
    }
}
