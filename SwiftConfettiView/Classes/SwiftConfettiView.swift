//
//  SwiftConfettiView.swift
//  SwiftConfettiView
//
//  Created by Uğur Ethem AYDIN on 2019
//

import UIKit
import QuartzCore
import AVFoundation

@MainActor
public class SwiftConfettiView: UIView {

    public enum ConfettiType: @unchecked Sendable {
        case confetti
        case triangle
        case star
        case diamond
        case image(UIImage)
        case text(String)       // emoji: .text("🎉")
        case sfSymbol(String)   // SF Symbol: .sfSymbol("star.fill")

        // MARK: v1 migration shims — Xcode Fix-it: "Replace 'X' with 'x'"

        @available(*, unavailable, renamed: "confetti")
        case Confetti

        @available(*, unavailable, renamed: "triangle")
        case Triangle

        @available(*, unavailable, renamed: "star")
        case Star

        @available(*, unavailable, renamed: "diamond")
        case Diamond

        @available(*, unavailable, renamed: "image")
        case Image(UIImage)

        /// Compare types by case (ignoring associated values for image).
        public func isSameType(as other: ConfettiType) -> Bool {
            switch (self, other) {
            case (.confetti, .confetti), (.triangle, .triangle),
                 (.star, .star), (.diamond, .diamond):
                return true
            case let (.text(a), .text(b)):
                return a == b
            case let (.sfSymbol(a), .sfSymbol(b)):
                return a == b
            case let (.image(a), .image(b)):
                return a === b
            default:
                return false
            }
        }
    }

    /// Pre-configured confetti templates.
    public enum Preset {
        /// Showcase burst — intense top-edge explosion with depth, haptic & sound.
        case perfect
        /// 360° firework burst from screen center.
        case firework
        /// Gentle continuous rain from the top edge.
        case rain
    }

    /// Apply a preset template. Call before `startConfetti()`.
    /// You can override individual properties after applying.
    public func applyPreset(_ preset: Preset) {
        switch preset {
        case .perfect:
            type = .confetti
            intensity = 0.82
            emitterOrigin = CGPoint(x: bounds.midX, y: -20)
            spread = .pi
            burstCount = 500
            hapticFeedback = true
            density = 3.0
            addDepth = true
            fadeOut = false
            playSound = true
        case .firework:
            type = .star
            intensity = 0.8
            emitterOrigin = CGPoint(x: bounds.midX, y: bounds.midY * 0.8)
            spread = 2 * .pi
            burstCount = 250
            hapticFeedback = true
            density = 2.0
            addDepth = true
            fadeOut = false
        case .rain:
            type = .confetti
            intensity = 0.75
            emitterOrigin = nil
            spread = .pi
            burstCount = nil
            hapticFeedback = false
            density = 1.5
            addDepth = false
            fadeOut = true
        }
    }

    private var foregroundEmitter: CAEmitterLayer?
    private var backgroundEmitter: CAEmitterLayer?
    private var emitterGeneration: UInt64 = 0
    private var pendingStart: Bool = false

    public var colors: [UIColor] = [
        UIColor(red: 0.95, green: 0.40, blue: 0.27, alpha: 1.0),
        UIColor(red: 1.00, green: 0.78, blue: 0.36, alpha: 1.0),
        UIColor(red: 0.48, green: 0.78, blue: 0.64, alpha: 1.0),
        UIColor(red: 0.30, green: 0.76, blue: 0.85, alpha: 1.0),
        UIColor(red: 0.58, green: 0.39, blue: 0.55, alpha: 1.0)
    ]
    public var intensity: Float = 0.5
    public var type: ConfettiType = .confetti
    public private(set) var isActive: Bool = false

    /// Emission origin point. `nil` = top-edge line (default rain). Set a point for burst/firework.
    public var emitterOrigin: CGPoint? = nil

    /// Direction of emission in radians. `.pi` = downward (default). `3 * .pi / 2` = upward.
    public var emissionAngle: CGFloat = .pi

    /// Emission cone spread in radians. `.pi` = 180° (default). `2 * .pi` = 360° firework.
    public var spread: CGFloat = .pi

    /// Single burst particle count. `nil` = continuous (default). Set a value for one-shot burst.
    public var burstCount: Int? = nil

    /// Trigger haptic feedback on `startConfetti()`.
    public var hapticFeedback: Bool = false

    /// Particle density multiplier. 1.0 = default. Higher values = more particles on screen.
    public var density: Float = 1.0

    /// Called when confetti stops (useful for resetting SwiftUI bindings after burst).
    public var onStop: (() -> Void)? = nil

    /// Enable dual-layer depth effect. Background layer has smaller, slower, dimmer particles.
    /// Inspired by ConfettiKit's parallax technique.
    public var addDepth: Bool = false

    /// Fade out particles when stopping instead of abrupt cut.
    public var fadeOut: Bool = true

    /// Play a celebratory sound on `startConfetti()`.
    public var playSound: Bool = false {
        didSet {
            if playSound { preloadSound() }
            else { audioPlayer = nil }
        }
    }

    /// Custom sound URL. `nil` = built-in confetti sound.
    public var customSoundURL: URL? = nil {
        didSet {
            audioPlayer = nil
            if playSound { preloadSound() }
        }
    }

    private var audioPlayer: AVAudioPlayer?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            // View leaving screen — guarantee cleanup regardless of isActive state.
            // Increment generation to invalidate any pending completion blocks.
            pendingStart = false
            emitterGeneration &+= 1
            cleanupEmitters()
            isActive = false
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateEmitterGeometry(foregroundEmitter)
        updateEmitterGeometry(backgroundEmitter)

        // Deferred start: if startConfetti() was called before layout (zero bounds),
        // actually start now that we have valid geometry.
        if pendingStart && bounds.size.width > 0 && bounds.size.height > 0 {
            pendingStart = false
            startConfetti()
        }
    }

    private func updateEmitterGeometry(_ emitterLayer: CAEmitterLayer?) {
        guard let emitterLayer = emitterLayer else { return }
        if emitterOrigin != nil { return }  // point emitter — position is user-defined
        emitterLayer.emitterPosition = CGPoint(x: bounds.size.width / 2.0, y: 0)
        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: 1)
    }

    public func startConfetti() {
        // Defer start if bounds are zero (SwiftUI may call before layout)
        if bounds.size.width <= 0 || bounds.size.height <= 0 {
            pendingStart = true
            return
        }
        pendingStart = false

        // Safety: clean up any existing emitters
        cleanupEmitters()
        emitterGeneration &+= 1

        if hapticFeedback {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }

        if playSound {
            playConfettiSound()
        }

        let now = CACurrentMediaTime()

        // Background layer (depth effect) — smaller, slower, dimmer
        if addDepth {
            let bgLayer = createEmitterLayer(
                scale: 0.6,
                scaleRange: 0,
                speed: 0.95,
                birthRateMultiplier: 0.6
            )
            bgLayer.beginTime = now
            bgLayer.opacity = 0.5
            layer.addSublayer(bgLayer)
            backgroundEmitter = bgLayer
            applyAnimations(to: bgLayer)
        }

        // Foreground layer — main confetti
        let fgLayer = createEmitterLayer(
            scale: 0.8,
            scaleRange: 0.1,
            speed: 1.0,
            birthRateMultiplier: 1.0
        )
        fgLayer.beginTime = now
        layer.addSublayer(fgLayer)
        foregroundEmitter = fgLayer
        applyAnimations(to: fgLayer)

        isActive = true
    }

    public func stopConfetti() {
        pendingStart = false
        guard isActive else { return }

        if fadeOut {
            fadeOutAndStop()
        } else {
            cleanupEmitters()
            isActive = false
            onStop?()
        }
    }

    // MARK: - Emitter Layer Creation

    private func createEmitterLayer(
        scale: CGFloat,
        scaleRange: CGFloat,
        speed: Float,
        birthRateMultiplier: Float
    ) -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()

        if let origin = emitterOrigin {
            emitterLayer.emitterPosition = origin
            emitterLayer.emitterShape = .point
            emitterLayer.emitterSize = CGSize(width: 1, height: 1)
        } else {
            emitterLayer.emitterPosition = CGPoint(x: bounds.size.width / 2.0, y: 0)
            emitterLayer.emitterShape = .line
            emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: 1)
        }

        emitterLayer.speed = speed

        cellNameCounter = 0
        var cells = [CAEmitterCell]()
        for color in colors {
            let cell = confettiWithColor(color: color)
            cell.scale = scale
            cell.scaleRange = scaleRange
            cell.birthRate *= birthRateMultiplier * density
            cells.append(cell)
        }

        emitterLayer.emitterCells = cells
        return emitterLayer
    }

    private func applyAnimations(to emitterLayer: CAEmitterLayer) {
        if let burst = burstCount, burst > 0 {
            applyBurstAnimation(to: emitterLayer, burstCount: burst)
        } else {
            applyInitialBurstAnimation(to: emitterLayer)
        }
        applyGravityRamp(to: emitterLayer)
    }

    /// Reload emitter cells in-place without removing existing particles.
    /// Old particles finish their life with old settings; new particles use current settings.
    /// Use this for property changes (type, intensity, spread) instead of stop+start.
    public func reloadCells() {
        guard isActive else { return }
        reloadCellsForLayer(foregroundEmitter, scale: 0.8, scaleRange: 0.1, birthRateMultiplier: 1.0)
        if addDepth {
            reloadCellsForLayer(backgroundEmitter, scale: 0.6, scaleRange: 0, birthRateMultiplier: 0.6)
        }
    }

    private func reloadCellsForLayer(
        _ emitterLayer: CAEmitterLayer?,
        scale: CGFloat,
        scaleRange: CGFloat,
        birthRateMultiplier: Float
    ) {
        guard let emitterLayer = emitterLayer else { return }

        // Remove old gravity animations (they reference old cell names)
        if let oldCells = emitterLayer.emitterCells {
            for cell in oldCells {
                if let name = cell.name {
                    emitterLayer.removeAnimation(forKey: "gravity_\(name)")
                }
            }
        }

        // Create new cells with current properties
        cellNameCounter = 0
        var cells = [CAEmitterCell]()
        for color in colors {
            let cell = confettiWithColor(color: color)
            cell.scale = scale
            cell.scaleRange = scaleRange
            cell.birthRate *= birthRateMultiplier * density
            cells.append(cell)
        }
        emitterLayer.emitterCells = cells

        // Re-apply gravity ramp for new cells
        applyGravityRamp(to: emitterLayer)
    }

    private func cleanupEmitters() {
        foregroundEmitter?.removeAllAnimations()
        foregroundEmitter?.removeFromSuperlayer()
        foregroundEmitter = nil
        backgroundEmitter?.removeAllAnimations()
        backgroundEmitter?.removeFromSuperlayer()
        backgroundEmitter = nil
    }

    // MARK: - Burst Animations

    /// One-shot burst: high initial emission that tapers to zero.
    private func applyBurstAnimation(to emitterLayer: CAEmitterLayer, burstCount: Int) {
        let cellBirthRate = 10.0 * intensity * density
        let totalBirthRate = cellBirthRate * Float(colors.count)
        let duration = totalBirthRate > 0 ? max(Double(burstCount) / Double(totalBirthRate), 0.5) : 1.0

        let anim = CAKeyframeAnimation(keyPath: #keyPath(CAEmitterLayer.birthRate))
        anim.duration = duration
        anim.timingFunction = CAMediaTimingFunction(name: .easeIn)
        anim.values = [3, 1, 0, 0]
        anim.keyTimes = [0, 0.15, 0.5, 1]
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false

        // Only trigger stopConfetti from the foreground layer's completion
        if emitterLayer === foregroundEmitter {
            let capturedGeneration = emitterGeneration
            CATransaction.begin()
            CATransaction.setCompletionBlock { [weak self] in
                guard let self = self, self.emitterGeneration == capturedGeneration else { return }
                self.foregroundEmitter?.birthRate = 0
                self.backgroundEmitter?.birthRate = 0
                self.isActive = false
                self.onStop?()
            }
            emitterLayer.add(anim, forKey: "burstBirthRate")
            CATransaction.commit()
        } else {
            emitterLayer.add(anim, forKey: "burstBirthRate")
        }
    }

    /// Continuous mode: initial burst (3x birthRate) settling to steady rain (1x).
    private func applyInitialBurstAnimation(to emitterLayer: CAEmitterLayer) {
        let anim = CABasicAnimation(keyPath: #keyPath(CAEmitterLayer.birthRate))
        anim.fromValue = 3.0
        anim.toValue = 1.0
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        emitterLayer.add(anim, forKey: "initialBurst")
    }

    /// Gravity ramp: particles float briefly then accelerate downward.
    private func applyGravityRamp(to emitterLayer: CAEmitterLayer) {
        guard let cells = emitterLayer.emitterCells else { return }
        for cell in cells {
            guard let name = cell.name else { continue }
            let gravityAnim = CAKeyframeAnimation(keyPath: "emitterCells.\(name).yAcceleration")
            gravityAnim.duration = 6.0
            gravityAnim.keyTimes = [0, 0.05, 0.1, 0.5, 1]
            gravityAnim.values = [0, 0, 100, 400, 600]
            gravityAnim.fillMode = .forwards
            gravityAnim.isRemovedOnCompletion = false
            emitterLayer.add(gravityAnim, forKey: "gravity_\(name)")
        }
    }

    // MARK: - Fade Out

    private func fadeOutAndStop() {
        let capturedGeneration = emitterGeneration
        let fadeDuration = 1.0

        // Mark inactive IMMEDIATELY so startConfetti() can be called again
        // without waiting for the fade animation to complete.
        foregroundEmitter?.birthRate = 0
        backgroundEmitter?.birthRate = 0
        isActive = false
        onStop?()

        let fadeAnim = CABasicAnimation(keyPath: #keyPath(CAEmitterLayer.opacity))
        fadeAnim.fromValue = 1.0
        fadeAnim.toValue = 0.0
        fadeAnim.duration = fadeDuration
        fadeAnim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        fadeAnim.fillMode = .forwards
        fadeAnim.isRemovedOnCompletion = false

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let self = self, self.emitterGeneration == capturedGeneration else { return }
            self.cleanupEmitters()
        }

        foregroundEmitter?.add(fadeAnim, forKey: "fadeOut")
        backgroundEmitter?.add(fadeAnim, forKey: "fadeOut")

        CATransaction.commit()
    }

    // MARK: - Cell Configuration

    private func imageForType(_ type: ConfettiType) -> UIImage? {
        let fileName: String

        switch type {
        case .confetti:
            fileName = "confetti"
        case .triangle:
            fileName = "triangle"
        case .star:
            fileName = "star"
        case .diamond:
            fileName = "diamond"
        case let .image(customImage):
            return customImage
        case let .text(string):
            return imageFromText(string)
        case let .sfSymbol(name):
            return imageFromSFSymbol(name)
        }

        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let podBundle = Bundle(for: SwiftConfettiView.self)
        let bundlePath = podBundle.path(forResource: "SwiftConfettiView", ofType: "bundle")
        let bundle = bundlePath.flatMap { Bundle(path: $0) } ?? podBundle
        #endif

        if let image = UIImage(named: fileName, in: bundle, compatibleWith: nil) {
            return image
        }

        guard let path = bundle.path(forResource: fileName, ofType: "png"),
              let image = UIImage(contentsOfFile: path) else {
            return nil
        }
        return image
    }

    private var cellNameCounter = 0

    private func confettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.name = "cell_\(cellNameCounter)"
        cellNameCounter += 1

        confetti.birthRate = 10.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(100.0 * intensity)
        confetti.emissionLongitude = emissionAngle
        confetti.emissionRange = spread
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        confetti.alphaSpeed = (burstCount != nil) ? -0.03 : -0.1
        confetti.yAcceleration = 0
        confetti.contents = imageForType(type)?.cgImage

        // Preserve natural colors for text/emoji; apply tint for other types
        if case .text = type {
            confetti.color = UIColor.white.cgColor
        } else {
            confetti.color = color.cgColor
        }

        return confetti
    }

    // MARK: - Image Generators

    private func imageFromText(_ text: String) -> UIImage? {
        let size = CGSize(width: 36, height: 36)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 28)
            ]
            let textSize = (text as NSString).size(withAttributes: attributes)
            let origin = CGPoint(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2
            )
            (text as NSString).draw(at: origin, withAttributes: attributes)
        }
    }

    private func imageFromSFSymbol(_ name: String) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 36)
        guard let symbol = UIImage(systemName: name, withConfiguration: config)?
            .withTintColor(.white, renderingMode: .alwaysOriginal) else {
            return nil
        }
        let renderer = UIGraphicsImageRenderer(size: symbol.size)
        return renderer.image { ctx in
            symbol.draw(in: CGRect(origin: .zero, size: symbol.size))
        }
    }

    // MARK: - Sound

    private func soundURL() -> URL? {
        if let custom = customSoundURL { return custom }
        #if SWIFT_PACKAGE
        return Bundle.module.url(forResource: "confetti", withExtension: "mp3")
        #else
        let podBundle = Bundle(for: SwiftConfettiView.self)
        if let bundlePath = podBundle.path(forResource: "SwiftConfettiView", ofType: "bundle"),
           let resBundle = Bundle(path: bundlePath) {
            return resBundle.url(forResource: "confetti", withExtension: "mp3")
        } else {
            return podBundle.url(forResource: "confetti", withExtension: "mp3")
        }
        #endif
    }

    private func preloadSound() {
        guard audioPlayer == nil, let url = soundURL() else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            // Silently fail — sound is optional
        }
    }

    private func playConfettiSound() {
        if audioPlayer == nil { preloadSound() }
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
}
