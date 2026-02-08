//
//  CustomColorsDemo.swift
//  SwiftConfettiView
//
//  Created by Ugur Ethem AYDIN on 2026
//

import SwiftUI
import SwiftConfettiView

struct CustomColorsDemo: View {
    @State private var isActive = false

    private let palette: [UIColor] = [
        UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0),    // gold
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),     // black
        UIColor(red: 0.85, green: 0.85, blue: 0.88, alpha: 1.0),   // silver
    ]

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            ConfettiView(
                type: .diamond,
                colors: palette,
                intensity: 0.8,
                isActive: $isActive,
                density: 1.5
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            Button {
                isActive.toggle()
            } label: {
                Text(isActive ? "Stop" : "Gold Rain")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(isActive ? .red : .primary)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 14)
                    .background(glassButtonBackground())
            }
        }
        .navigationTitle("Custom Colors")
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
