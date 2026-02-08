//
//  ViewController.swift
//  SwiftConfettiView
//
//  Created by Ugur Ethem AYDIN on 04/11/2019.
//  Copyright (c) 2019 Ugur Ethem AYDIN. All rights reserved.
//

import UIKit
import SwiftConfettiView

class ViewController: UIViewController {

    private var confettiView: SwiftConfettiView!

    @IBOutlet weak var confettiStatus: UILabel!
    private var statusLabel: UILabel?

    // MARK: - Controls

    private let controlPanel = UIView()
    private let startStopButton = UIButton(type: .system)

    private let intensitySlider = UISlider()
    private let intensityLabel = UILabel()

    private let spreadSlider = UISlider()
    private let spreadLabel = UILabel()

    private let typeSegment = UISegmentedControl(items: [
        "Confetti", "Triangle", "Star", "Diamond", "Emoji"
    ])

    private let fadeOutSwitch = UISwitch()
    private let addDepthSwitch = UISwitch()
    private let hapticSwitch = UISwitch()
    private let soundSwitch = UISwitch()

    private var isRunning = false
    private var restartDebounceTimer: Timer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        // Store strong reference before removing from superview (outlet is weak)
        statusLabel = confettiStatus

        confettiView = SwiftConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = false
        view.addSubview(confettiView)

        // Remove storyboard label's existing constraints to avoid conflicts
        if let status = statusLabel {
            status.removeFromSuperview()
            status.font = .systemFont(ofSize: 16, weight: .medium)
            status.textAlignment = .center
            status.textColor = .label
            status.text = "Tap Start to test confetti"
        }

        setupControlPanel()

        // Ensure confettiView is always behind all controls
        view.sendSubviewToBack(confettiView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topInset = view.safeAreaInsets.top
        confettiView.frame = CGRect(
            x: 0,
            y: -topInset,
            width: view.bounds.width,
            height: view.bounds.height + topInset
        )
    }

    // MARK: - Control Panel Setup

    private func setupControlPanel() {
        // Semi-transparent panel
        controlPanel.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        controlPanel.layer.cornerRadius = 16
        controlPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        controlPanel.layer.shadowColor = UIColor.black.cgColor
        controlPanel.layer.shadowOpacity = 0.15
        controlPanel.layer.shadowRadius = 8
        controlPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controlPanel)

        // Start/Stop button (above the panel)
        startStopButton.setTitle("Start Confetti", for: .normal)
        startStopButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        startStopButton.backgroundColor = .systemBlue
        startStopButton.setTitleColor(.white, for: .normal)
        startStopButton.layer.cornerRadius = 22
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.addTarget(self, action: #selector(toggleConfetti), for: .touchUpInside)
        view.addSubview(startStopButton)

        // Build control rows
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        controlPanel.addSubview(stack)

        // Type selector
        typeSegment.selectedSegmentIndex = 0
        typeSegment.addTarget(self, action: #selector(typeChanged), for: .valueChanged)
        stack.addArrangedSubview(makeRow(title: "Type", control: typeSegment))

        // Intensity slider (0.1 - 1.0)
        intensitySlider.minimumValue = 0.1
        intensitySlider.maximumValue = 1.0
        intensitySlider.value = 0.5
        intensitySlider.addTarget(self, action: #selector(intensityChanged), for: .valueChanged)
        intensityLabel.text = "0.50"
        intensityLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        intensityLabel.textAlignment = .right
        intensityLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        let intensityRow = makeRow(title: "Intensity", control: intensitySlider, accessory: intensityLabel)
        stack.addArrangedSubview(intensityRow)

        // Spread slider (0 - 2π)
        spreadSlider.minimumValue = 0
        spreadSlider.maximumValue = Float(2 * Double.pi)
        spreadSlider.value = Float(Double.pi)
        spreadSlider.addTarget(self, action: #selector(spreadChanged), for: .valueChanged)
        spreadLabel.text = "180°"
        spreadLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        spreadLabel.textAlignment = .right
        spreadLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        let spreadRow = makeRow(title: "Spread", control: spreadSlider, accessory: spreadLabel)
        stack.addArrangedSubview(spreadRow)

        // Toggles row
        let toggleStack = UIStackView()
        toggleStack.axis = .horizontal
        toggleStack.distribution = .fillEqually
        toggleStack.spacing = 8

        fadeOutSwitch.isOn = true
        fadeOutSwitch.addTarget(self, action: #selector(fadeOutChanged), for: .valueChanged)
        toggleStack.addArrangedSubview(makeSwitchRow(title: "Fade Out", toggle: fadeOutSwitch))

        addDepthSwitch.isOn = false
        addDepthSwitch.addTarget(self, action: #selector(depthChanged), for: .valueChanged)
        toggleStack.addArrangedSubview(makeSwitchRow(title: "Depth", toggle: addDepthSwitch))

        hapticSwitch.isOn = false
        hapticSwitch.addTarget(self, action: #selector(hapticChanged), for: .valueChanged)
        toggleStack.addArrangedSubview(makeSwitchRow(title: "Haptic", toggle: hapticSwitch))

        soundSwitch.isOn = false
        soundSwitch.addTarget(self, action: #selector(soundChanged), for: .valueChanged)
        toggleStack.addArrangedSubview(makeSwitchRow(title: "Sound", toggle: soundSwitch))

        stack.addArrangedSubview(toggleStack)

        // Re-add status label above the button (removed from storyboard to avoid conflicts)
        if let status = statusLabel {
            status.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(status)
        }

        // Constraints
        NSLayoutConstraint.activate([
            controlPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.topAnchor.constraint(equalTo: controlPanel.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: controlPanel.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: controlPanel.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),

            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startStopButton.bottomAnchor.constraint(equalTo: controlPanel.topAnchor, constant: -16),
            startStopButton.widthAnchor.constraint(equalToConstant: 200),
            startStopButton.heightAnchor.constraint(equalToConstant: 44),
        ])

        if let status = statusLabel {
            NSLayoutConstraint.activate([
                status.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                status.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                status.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                status.bottomAnchor.constraint(equalTo: startStopButton.topAnchor, constant: -12),
            ])
        }

        applySettings()
    }

    // MARK: - Row Helpers

    private func makeRow(title: String, control: UIView, accessory: UIView? = nil) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.widthAnchor.constraint(equalToConstant: 60).isActive = true

        let row = UIStackView(arrangedSubviews: [label, control])
        if let acc = accessory {
            row.addArrangedSubview(acc)
        }
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .center
        return row
    }

    private func makeSwitchRow(title: String, toggle: UISwitch) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [toggle, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }

    // MARK: - Actions

    @objc private func toggleConfetti() {
        if isRunning {
            restartDebounceTimer?.invalidate()
            confettiView.stopConfetti()
            isRunning = false
            startStopButton.setTitle("Start Confetti", for: .normal)
            startStopButton.backgroundColor = .systemBlue
            statusLabel?.text = "it's not raining confetti 🙁"
        } else {
            applySettings()
            confettiView.startConfetti()
            isRunning = true
            startStopButton.setTitle("Stop", for: .normal)
            startStopButton.backgroundColor = .systemRed
            statusLabel?.text = "it's raining confetti 🙂"
        }
    }

    @objc private func typeChanged() {
        applySettings()
    }

    @objc private func intensityChanged() {
        intensityLabel.text = String(format: "%.2f", intensitySlider.value)
        applySettings(debounce: true)
    }

    @objc private func spreadChanged() {
        let degrees = Int(spreadSlider.value * 180.0 / Float.pi)
        spreadLabel.text = "\(degrees)°"
        applySettings(debounce: true)
    }

    @objc private func fadeOutChanged() {
        applySettings()
    }

    @objc private func depthChanged() {
        confettiView.addDepth = addDepthSwitch.isOn
        guard isRunning else { return }
        restartDebounceTimer?.invalidate()
        restartConfetti()
    }

    @objc private func hapticChanged() {
        applySettings()
    }

    @objc private func soundChanged() {
        applySettings()
    }

    // MARK: - Apply Settings

    private func applySettings(debounce: Bool = false) {
        switch typeSegment.selectedSegmentIndex {
        case 0: confettiView.type = .confetti
        case 1: confettiView.type = .triangle
        case 2: confettiView.type = .star
        case 3: confettiView.type = .diamond
        case 4: confettiView.type = .text("🎉")
        default: confettiView.type = .confetti
        }

        confettiView.intensity = intensitySlider.value
        confettiView.spread = CGFloat(spreadSlider.value)
        confettiView.fadeOut = fadeOutSwitch.isOn
        confettiView.addDepth = addDepthSwitch.isOn
        confettiView.hapticFeedback = hapticSwitch.isOn
        confettiView.playSound = soundSwitch.isOn

        guard isRunning else { return }

        if debounce {
            restartDebounceTimer?.invalidate()
            restartDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { [weak self] _ in
                self?.confettiView.reloadCells()
            }
        } else {
            restartDebounceTimer?.invalidate()
            confettiView.reloadCells()
        }
    }

    private func restartConfetti() {
        guard isRunning else { return }
        // Suppress sound/haptic during structural restart
        let savedHaptic = confettiView.hapticFeedback
        let savedSound = confettiView.playSound
        confettiView.hapticFeedback = false
        confettiView.playSound = false
        confettiView.fadeOut = false  // skip fade animation for instant restart
        confettiView.stopConfetti()
        confettiView.fadeOut = fadeOutSwitch.isOn  // restore user's fadeOut preference
        confettiView.startConfetti()
        confettiView.hapticFeedback = savedHaptic
        confettiView.playSound = savedSound
    }
}
