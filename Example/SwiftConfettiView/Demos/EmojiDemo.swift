//
//  EmojiDemo.swift
//  SwiftConfettiView
//
//  Created by Ugur Ethem AYDIN on 2026
//

import SwiftUI
import SwiftConfettiView

struct EmojiDemo: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            ConfettiView(
                type: .text("🎉"),
                intensity: 0.7,
                isActive: $isActive,
                density: 1.5
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            Button {
                isActive.toggle()
            } label: {
                Text(isActive ? "Stop" : "Party!")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(isActive ? .red : .primary)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 14)
                    .background(glassButtonBackground())
            }
        }
        .navigationTitle("Emoji")
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
