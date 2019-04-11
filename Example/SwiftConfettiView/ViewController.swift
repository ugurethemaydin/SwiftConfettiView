//
//  ViewController.swift
//  SwiftConfettiView
//
//  Created by Uğur Ethem AYDIN on 04/11/2019.
//  Copyright (c) 2019 Uğur Ethem AYDIN. All rights reserved.
//

import UIKit
import SwiftConfettiView
class ViewController: UIViewController {

    var confettiView: SwiftConfettiView!
    var isRainingConfetti = false
    
    @IBOutlet weak var confettiStatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        confettiView = SwiftConfettiView(frame: self.view.bounds)
        
        // Set colors (default colors are red, green and blue)
        confettiView.colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                               UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                               UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                               UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                               UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
        
        // Set intensity (from 0 - 1, default intensity is 0.5)
        confettiView.intensity = 0.5
        
        // Set type
        confettiView.type = .diamond
        
        // For custom image
        // confettiView.type = .Image(UIImage(named: "diamond")!)
        
        // Add subview
        view.addSubview(confettiView)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isRainingConfetti) {
            // Stop confetti
            confettiView.stopConfetti()
            confettiStatus.text = "it's not raining confetti 🙁"
        } else {
            // Start confetti
            confettiView.startConfetti()
            confettiStatus.text = "it's raining confetti 🙂"
        }
        isRainingConfetti = !isRainingConfetti
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

