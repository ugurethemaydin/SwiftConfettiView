//
//  LegacyDemoView.swift
//  SwiftConfettiView
//
//  Created by Uğur Ethem AYDIN on 2026
//

import SwiftUI

struct LegacyDemoView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController() as! ViewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}
