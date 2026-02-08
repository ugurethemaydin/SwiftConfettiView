//
//  PerfectDemo.swift
//  SwiftConfettiView
//
//  Created by Ugur Ethem AYDIN on 2026
//

import SwiftUI
import SwiftConfettiView

struct PerfectDemo: View {
    @State private var isActive = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                ConfettiView(
                    intensity: 0.82,
                    isActive: $isActive,
                    emitterOrigin: CGPoint(x: geo.size.width / 2, y: -20),
                    spread: .pi,
                    burstCount: 500,
                    hapticFeedback: true,
                    density: 3.0,
                    addDepth: true,
                    fadeOut: false,
                    playSound: true
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)

                Button {
                    if !isActive { isActive = true }
                } label: {
                    Text(isActive ? "Voilà! 🎉" : "Celebrate!")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .background(glassButtonBackground())
                }
                .allowsHitTesting(!isActive)
            }
        }
        .navigationTitle("Perfect")
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
