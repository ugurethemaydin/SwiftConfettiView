import XCTest
@testable import SwiftConfettiView

@MainActor
final class SwiftConfettiViewTests: XCTestCase {

    // MARK: - Existing Default Tests

    func testDefaultColors() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertEqual(view.colors.count, 5)
    }

    func testDefaultIntensity() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertEqual(view.intensity, 0.5)
    }

    func testDefaultType() {
        let view = SwiftConfettiView(frame: .zero)
        if case .confetti = view.type {
            // ok
        } else {
            XCTFail("Default type should be .confetti")
        }
    }

    func testIsActiveDefault() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertFalse(view.isActive)
    }

    // MARK: - New Property Defaults

    func testDefaultEmitterOrigin() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertNil(view.emitterOrigin)
    }

    func testDefaultEmissionAngle() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertEqual(view.emissionAngle, .pi)
    }

    func testDefaultSpread() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertEqual(view.spread, .pi)
    }

    func testDefaultBurstCount() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertNil(view.burstCount)
    }

    func testDefaultHapticFeedback() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertFalse(view.hapticFeedback)
    }

    func testDefaultDensity() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertEqual(view.density, 1.0)
    }

    func testDefaultPlaySound() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertFalse(view.playSound)
    }

    func testDensityAffectsParticles() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.density = 2.5
        view.fadeOut = false
        view.startConfetti()
        XCTAssertTrue(view.isActive)
        XCTAssertEqual(view.density, 2.5)
        view.stopConfetti()
        XCTAssertFalse(view.isActive)
    }

    // MARK: - New ConfettiType Cases

    func testTextTypeDoesNotCrash() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.type = .text("🎉")
        view.fadeOut = false
        view.startConfetti()
        XCTAssertTrue(view.isActive)
        view.stopConfetti()
        XCTAssertFalse(view.isActive)
    }

    func testSFSymbolTypeDoesNotCrash() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.type = .sfSymbol("star.fill")
        view.fadeOut = false
        view.startConfetti()
        XCTAssertTrue(view.isActive)
        view.stopConfetti()
        XCTAssertFalse(view.isActive)
    }

    // MARK: - Burst Mode

    func testBurstCountStopsAutomatically() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.burstCount = 10

        let expectation = expectation(description: "Burst completes")
        view.onStop = {
            expectation.fulfill()
        }

        view.startConfetti()
        XCTAssertTrue(view.isActive)

        waitForExpectations(timeout: 3.0)
        XCTAssertFalse(view.isActive)
    }

    // MARK: - Multiple Start Safety

    func testMultipleStartDoesNotDuplicateEmitters() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.startConfetti()
        view.startConfetti()
        view.startConfetti()

        // Only 1 emitter sublayer should exist
        let emitterLayers = view.layer.sublayers?.filter { $0 is CAEmitterLayer } ?? []
        XCTAssertEqual(emitterLayers.count, 1)
        view.stopConfetti()
    }

    // MARK: - onStop Callback

    func testOnStopCalledOnStop() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.fadeOut = false
        var called = false
        view.onStop = { called = true }

        view.startConfetti()
        view.stopConfetti()
        XCTAssertTrue(called)
    }

    // MARK: - Emitter Origin

    func testPointEmitterSetsOrigin() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.emitterOrigin = CGPoint(x: 100, y: 100)
        view.startConfetti()

        let emitterLayer = view.layer.sublayers?.first(where: { $0 is CAEmitterLayer }) as? CAEmitterLayer
        XCTAssertEqual(emitterLayer?.emitterPosition, CGPoint(x: 100, y: 100))
        XCTAssertEqual(emitterLayer?.emitterShape, .point)
        view.stopConfetti()
    }

    // MARK: - Cell Naming (required for gravity ramp)

    func testCellsHaveUniqueNames() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.startConfetti()

        let emitterLayer = view.layer.sublayers?.first(where: { $0 is CAEmitterLayer }) as? CAEmitterLayer
        let names = emitterLayer?.emitterCells?.compactMap { $0.name } ?? []
        XCTAssertEqual(names.count, view.colors.count, "Each color should produce a named cell")
        XCTAssertEqual(Set(names).count, names.count, "Cell names should be unique")
        view.stopConfetti()
    }

    // MARK: - Burst Animation Applied

    func testBurstAnimationApplied() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.burstCount = 50
        view.startConfetti()

        let emitterLayer = view.layer.sublayers?.first(where: { $0 is CAEmitterLayer }) as? CAEmitterLayer
        XCTAssertNotNil(emitterLayer?.animation(forKey: "burstBirthRate"), "Burst animation should be applied")
        view.stopConfetti()
    }

    func testContinuousInitialBurstAnimationApplied() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.startConfetti()

        let emitterLayer = view.layer.sublayers?.first(where: { $0 is CAEmitterLayer }) as? CAEmitterLayer
        XCTAssertNotNil(emitterLayer?.animation(forKey: "initialBurst"), "Initial burst animation should be applied")
        view.stopConfetti()
    }

    // MARK: - Depth Effect

    func testDefaultAddDepth() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertFalse(view.addDepth)
    }

    func testAddDepthCreatesTwoEmitterLayers() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.addDepth = true
        view.startConfetti()

        let emitterLayers = view.layer.sublayers?.filter { $0 is CAEmitterLayer } ?? []
        XCTAssertEqual(emitterLayers.count, 2, "addDepth should create background + foreground emitter layers")
        view.stopConfetti()
    }

    func testNoDepthCreatesSingleEmitterLayer() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.addDepth = false
        view.startConfetti()

        let emitterLayers = view.layer.sublayers?.filter { $0 is CAEmitterLayer } ?? []
        XCTAssertEqual(emitterLayers.count, 1, "Without addDepth, only foreground emitter should exist")
        view.stopConfetti()
    }

    // MARK: - Fade Out

    func testDefaultFadeOut() {
        let view = SwiftConfettiView(frame: .zero)
        XCTAssertTrue(view.fadeOut)
    }

    func testFadeOutDisabledCallsOnStopImmediately() {
        let view = SwiftConfettiView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.fadeOut = false
        var called = false
        view.onStop = { called = true }

        view.startConfetti()
        view.stopConfetti()
        XCTAssertTrue(called, "onStop should be called immediately when fadeOut is disabled")
        XCTAssertFalse(view.isActive)
    }
}
