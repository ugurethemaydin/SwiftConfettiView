//
//  RepeatBurstDemo.swift
//  SwiftConfettiView
//
//  Created by Ugur Ethem AYDIN on 2026
//

import SwiftUI
import SwiftConfettiView

struct RepeatBurstDemo: View {
    @State private var isActive = false
    @State private var isRepeating = false

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            ConfettiView(
                type: .triangle,
                intensity: 0.7,
                isActive: $isActive,
                burstCount: 120,
                hapticFeedback: true,
                density: 1.5
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            Button {
                if isRepeating {
                    isRepeating = false
                } else {
                    isRepeating = true
                    isActive = true
                }
            } label: {
                Text(isRepeating ? "Stop" : "Repeat Burst")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(isRepeating ? .red : .primary)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 14)
                    .background(glassButtonBackground())
            }
        }
        .navigationTitle("Repeat Burst")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { isRepeating = false; isActive = false }
        .onChange(of: isActive) { active in
            if !active && isRepeating {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    guard isRepeating else { return }
                    isActive = true
                }
            }
        }
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
