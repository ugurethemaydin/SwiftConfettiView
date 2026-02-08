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
                    NavigationLink("Perfect", destination: PerfectDemo())
                }
                Section(header: Text("Confetti Demos")) {
                    NavigationLink("Default Rain", destination: DefaultRainDemo())
                    NavigationLink("From a Point", destination: PointEmissionDemo())
                    NavigationLink("Firework", destination: FireworkDemo())
                    NavigationLink("Emoji", destination: EmojiDemo())
                    NavigationLink("SF Symbol", destination: SFSymbolDemo())
                    NavigationLink("Custom Colors", destination: CustomColorsDemo())
                    NavigationLink("Repeat Burst", destination: RepeatBurstDemo())
                    NavigationLink("Depth Effect", destination: DepthEffectDemo())
                }
                Section(header: Text("Legacy")) {
                    NavigationLink("UIKit Example", destination: LegacyDemoView())
                }
            }
            .navigationTitle("SwiftConfettiView")
        }
        .navigationViewStyle(.stack)
    }
}
