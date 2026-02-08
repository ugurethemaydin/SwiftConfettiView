//
//  DepthEffectDemo.swift
//  SwiftConfettiView
//
//  Created by Ugur Ethem AYDIN on 2026
//

import SwiftUI
import SwiftConfettiView

struct DepthEffectDemo: View {
    @State private var isActive = false
    @State private var intensity: Float = 0.82
    @State private var spread: Float = Float.pi
    @State private var density: Float = 3.0
    @State private var fadeOut = false
    @State private var haptic = true
    @State private var sound = true

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            ConfettiView(
                intensity: intensity,
                isActive: $isActive,
                spread: CGFloat(spread),
                hapticFeedback: haptic,
                density: density,
                addDepth: true,
                fadeOut: fadeOut,
                playSound: sound
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack {
                Spacer()

                // Start/Stop button
                Button {
                    isActive.toggle()
                } label: {
                    Text(isActive ? "Stop" : "Start")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(isActive ? .red : .primary)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .background(glassButtonBackground())
                }
                .padding(.bottom, 16)

                // Control panel
                VStack(spacing: 12) {
                    // Intensity
                    HStack {
                        Text("Intensity")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                            .frame(width: 65, alignment: .leading)
                        Slider(value: $intensity, in: 0.1...1.0)
                        Text(String(format: "%.2f", intensity))
                            .font(.caption.monospacedDigit())
                            .frame(width: 36, alignment: .trailing)
                    }

                    // Spread
                    HStack {
                        Text("Spread")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                            .frame(width: 65, alignment: .leading)
                        Slider(value: $spread, in: 0...(2 * Float.pi))
                        Text("\(Int(spread * 180 / Float.pi))°")
                            .font(.caption.monospacedDigit())
                            .frame(width: 36, alignment: .trailing)
                    }

                    // Density
                    HStack {
                        Text("Density")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                            .frame(width: 65, alignment: .leading)
                        Slider(value: $density, in: 0.5...3.0)
                        Text(String(format: "%.1fx", density))
                            .font(.caption.monospacedDigit())
                            .frame(width: 40, alignment: .trailing)
                    }

                    // Toggle row
                    HStack(spacing: 12) {
                        toggleItem(title: "Fade Out", isOn: $fadeOut)
                        toggleItem(title: "Haptic", isOn: $haptic)
                        toggleItem(title: "Sound", isOn: $sound)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemBackground).opacity(0.92))
                        .shadow(color: .black.opacity(0.1), radius: 8)
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("Depth Effect")
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

    private func toggleItem(title: String, isOn: Binding<Bool>) -> some View {
        VStack(spacing: 4) {
            Toggle("", isOn: isOn)
                .labelsHidden()
            Text(title)
                .font(.caption2.weight(.medium))
                .foregroundColor(.secondary)
        }
    }
}
