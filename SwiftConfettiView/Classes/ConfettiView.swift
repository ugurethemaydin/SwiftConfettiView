//
//  ConfettiView.swift
//  SwiftConfettiView
//
//  Created by Uğur Ethem AYDIN on 2026
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
@MainActor
public struct ConfettiView: UIViewRepresentable {

    public var preset: SwiftConfettiView.Preset?
    public var type: SwiftConfettiView.ConfettiType
    public var colors: [UIColor]
    public var intensity: Float
    @Binding public var isActive: Bool

    public var emitterOrigin: CGPoint?
    public var emissionAngle: CGFloat
    public var spread: CGFloat
    public var burstCount: Int?
    public var hapticFeedback: Bool
    public var density: Float
    public var addDepth: Bool
    public var fadeOut: Bool
    public var playSound: Bool
    public var customSoundURL: URL?

    /// Full customization init.
    public init(
        type: SwiftConfettiView.ConfettiType = .confetti,
        colors: [UIColor] = [
            UIColor(red: 0.95, green: 0.40, blue: 0.27, alpha: 1.0),
            UIColor(red: 1.00, green: 0.78, blue: 0.36, alpha: 1.0),
            UIColor(red: 0.48, green: 0.78, blue: 0.64, alpha: 1.0),
            UIColor(red: 0.30, green: 0.76, blue: 0.85, alpha: 1.0),
            UIColor(red: 0.58, green: 0.39, blue: 0.55, alpha: 1.0)
        ],
        intensity: Float = 0.5,
        isActive: Binding<Bool>,
        emitterOrigin: CGPoint? = nil,
        emissionAngle: CGFloat = .pi,
        spread: CGFloat = .pi,
        burstCount: Int? = nil,
        hapticFeedback: Bool = false,
        density: Float = 1.0,
        addDepth: Bool = false,
        fadeOut: Bool = true,
        playSound: Bool = false,
        customSoundURL: URL? = nil
    ) {
        self.preset = nil
        self.type = type
        self.colors = colors
        self.intensity = intensity
        self._isActive = isActive
        self.emitterOrigin = emitterOrigin
        self.emissionAngle = emissionAngle
        self.spread = spread
        self.burstCount = burstCount
        self.hapticFeedback = hapticFeedback
        self.density = density
        self.addDepth = addDepth
        self.fadeOut = fadeOut
        self.playSound = playSound
        self.customSoundURL = customSoundURL
        self._playSoundOverride = nil
        self._hapticOverride = nil
    }

    /// Preset init — one line, with optional overrides.
    public init(
        preset: SwiftConfettiView.Preset,
        isActive: Binding<Bool>,
        playSound: Bool? = nil,
        hapticFeedback: Bool? = nil
    ) {
        self.preset = preset
        self.type = .confetti
        self.colors = [
            UIColor(red: 0.95, green: 0.40, blue: 0.27, alpha: 1.0),
            UIColor(red: 1.00, green: 0.78, blue: 0.36, alpha: 1.0),
            UIColor(red: 0.48, green: 0.78, blue: 0.64, alpha: 1.0),
            UIColor(red: 0.30, green: 0.76, blue: 0.85, alpha: 1.0),
            UIColor(red: 0.58, green: 0.39, blue: 0.55, alpha: 1.0)
        ]
        self.intensity = 0.5
        self._isActive = isActive
        self.emitterOrigin = nil
        self.emissionAngle = .pi
        self.spread = .pi
        self.burstCount = nil
        // Store overrides — applied after preset in configureView
        self.hapticFeedback = hapticFeedback ?? false
        self.density = 1.0
        self.addDepth = false
        self.fadeOut = true
        self.playSound = playSound ?? false
        self.customSoundURL = nil
        // Track which overrides were explicitly set
        self._playSoundOverride = playSound
        self._hapticOverride = hapticFeedback
    }

    // Override tracking (nil = use preset default)
    private var _playSoundOverride: Bool?
    private var _hapticOverride: Bool?

    public func makeCoordinator() -> Coordinator {
        Coordinator(isActive: $isActive)
    }

    public func makeUIView(context: Context) -> SwiftConfettiView {
        let view = SwiftConfettiView(frame: .zero)
        if let preset = preset {
            // Defer preset application — needs valid bounds.
            // applyPreset is called in updateUIView after layout.
            context.coordinator.pendingPreset = preset
        }
        configureView(view, coordinator: context.coordinator)
        return view
    }

    public func updateUIView(_ uiView: SwiftConfettiView, context: Context) {
        // Apply deferred preset once bounds are available
        if let pending = context.coordinator.pendingPreset, uiView.bounds.width > 0 {
            uiView.applyPreset(pending)
            context.coordinator.pendingPreset = nil
        }

        // Capture current values before applying new ones
        let oldType = uiView.type
        let oldIntensity = uiView.intensity
        let oldSpread = uiView.spread
        let oldAddDepth = uiView.addDepth
        let oldDensity = uiView.density

        configureView(uiView, coordinator: context.coordinator)

        if isActive && !uiView.isActive {
            uiView.startConfetti()
        } else if !isActive && uiView.isActive {
            uiView.stopConfetti()
        } else if uiView.isActive {
            // Detect property changes while active
            let typeChanged = !uiView.type.isSameType(as: oldType)
            let structuralChange = uiView.addDepth != oldAddDepth
            let cellChange = typeChanged
                || uiView.intensity != oldIntensity
                || uiView.spread != oldSpread
                || uiView.density != oldDensity

            if structuralChange {
                // addDepth changes require full restart (add/remove layer)
                context.coordinator.scheduleRestart(uiView, fadeOut: fadeOut)
            } else if cellChange {
                // Cell-only changes: reload in place (no visual gap)
                context.coordinator.scheduleReload(uiView)
            }
        }
    }

    private func configureView(_ view: SwiftConfettiView, coordinator: Coordinator) {
        if let preset = preset {
            // Apply preset when view has valid bounds
            if view.bounds.width > 0 {
                view.applyPreset(preset)
                coordinator.pendingPreset = nil
            } else {
                coordinator.pendingPreset = preset
            }
            // Apply user overrides on top of preset
            if let sound = _playSoundOverride { view.playSound = sound }
            if let haptic = _hapticOverride { view.hapticFeedback = haptic }
        } else {
            view.type = type
            view.colors = colors
            view.intensity = intensity
            view.emitterOrigin = emitterOrigin
            view.emissionAngle = emissionAngle
            view.spread = spread
            view.burstCount = burstCount
            view.hapticFeedback = hapticFeedback
            view.density = density
            view.addDepth = addDepth
            view.fadeOut = fadeOut
            view.playSound = playSound
            view.customSoundURL = customSoundURL
        }
        view.onStop = { [weak coordinator] in
            coordinator?.resetIsActive()
        }
    }

    @MainActor
    public class Coordinator {
        private var isActive: Binding<Bool>
        private var restartTimer: Timer?
        var pendingPreset: SwiftConfettiView.Preset?

        init(isActive: Binding<Bool>) {
            self.isActive = isActive
        }

        deinit {
            restartTimer?.invalidate()
        }

        func resetIsActive() {
            isActive.wrappedValue = false
        }

        func scheduleRestart(_ view: SwiftConfettiView, fadeOut: Bool) {
            restartTimer?.invalidate()
            restartTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { [weak view] _ in
                guard let view = view, view.isActive else { return }
                let savedHaptic = view.hapticFeedback
                let savedSound = view.playSound
                view.hapticFeedback = false
                view.playSound = false
                view.fadeOut = false
                view.stopConfetti()
                view.fadeOut = fadeOut
                view.startConfetti()
                view.hapticFeedback = savedHaptic
                view.playSound = savedSound
            }
        }

        func scheduleReload(_ view: SwiftConfettiView) {
            restartTimer?.invalidate()
            restartTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { [weak view] _ in
                guard let view = view, view.isActive else { return }
                view.reloadCells()
            }
        }
    }
}
#endif
