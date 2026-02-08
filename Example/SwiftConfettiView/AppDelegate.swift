//
//  AppDelegate.swift
//  SwiftConfettiView
//
//  Created by Uğur Ethem AYDIN on 04/11/2019.
//  Copyright (c) 2019 Uğur Ethem AYDIN. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: ExamplesView())
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
