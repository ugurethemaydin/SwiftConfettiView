//
//  ExamplesView.swift
//  SwiftConfettiView
//
//  Created by Uğur Ethem AYDIN on 2026
//

import SwiftUI

struct ExamplesView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Showcase")) {
                    demoLink("Perfect", destination: PerfectDemo(),
                             tag: .confetti)
                }
                Section(header: Text("Confetti Demos")) {
                    demoLink("Default Rain", destination: DefaultRainDemo(),
                             tag: .confetti)
                    demoLink("From a Point", destination: PointEmissionDemo(),
                             tag: .confetti)
                    demoLink("Firework", destination: FireworkDemo(),
                             tag: .star)
                    demoLink("Emoji", destination: EmojiDemo(),
                             tag: .emoji)
                    demoLink("SF Symbol", destination: SFSymbolDemo(),
                             tag: .sfSymbol)
                    demoLink("Custom Colors", destination: CustomColorsDemo(),
                             tag: .diamond)
                    demoLink("Repeat Burst", destination: RepeatBurstDemo(),
                             tag: .triangle)
                    demoLink("Depth Effect", destination: DepthEffectDemo(),
                             tag: .confetti)
                }
                Section(header: Text("Legacy")) {
                    NavigationLink("UIKit Example", destination: LegacyDemoView())
                }
                Section {
                    Link(destination: URL(string: "https://github.com/ugurethemaydin/SwiftConfettiView")!) {
                        HStack {
                            Spacer()
                            VStack(spacing: 4) {
                                Text("\u{00A9} Ugur Ethem AYDIN")
                                    .font(.footnote.weight(.medium))
                                Text("github.com/ugurethemaydin")
                                    .font(.caption)
                            }
                            .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("SwiftConfettiView")
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Demo row with type tag

    private func demoLink<D: View>(_ title: String, destination: D, tag: TypeTag) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(title)
                Spacer()
                tag.badge
            }
        }
    }
}

// MARK: - Type tags

private enum TypeTag {
    case confetti, triangle, star, diamond, emoji, sfSymbol

    var badge: some View {
        HStack(spacing: 4) {
            icon
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundColor(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(
            Capsule()
                .fill(color.opacity(0.08))
        )
    }

    @ViewBuilder
    var icon: some View {
        switch self {
        case .confetti:
            Image(systemName: "square.fill")
                .font(.system(size: 8))
                .foregroundColor(color)
        case .triangle:
            Image(systemName: "triangle.fill")
                .font(.system(size: 8))
                .foregroundColor(color)
        case .star:
            Image(systemName: "star.fill")
                .font(.system(size: 8))
                .foregroundColor(color)
        case .diamond:
            Image(systemName: "diamond.fill")
                .font(.system(size: 8))
                .foregroundColor(color)
        case .emoji:
            Text("🎉")
                .font(.system(size: 10))
        case .sfSymbol:
            Image(systemName: "heart.fill")
                .font(.system(size: 8))
                .foregroundColor(color)
        }
    }

    var label: String {
        switch self {
        case .confetti: return "confetti"
        case .triangle: return "triangle"
        case .star: return "star"
        case .diamond: return "diamond"
        case .emoji: return "text"
        case .sfSymbol: return "sfSymbol"
        }
    }

    var color: Color {
        switch self {
        case .confetti: return .orange
        case .triangle: return .green
        case .star: return .yellow
        case .diamond: return .purple
        case .emoji: return .pink
        case .sfSymbol: return .red
        }
    }
}
