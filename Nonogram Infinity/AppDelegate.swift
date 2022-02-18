//
//  AppDelegate.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 7/2/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var cheaterStopperWindow: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AudioManager.configurePlayers()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        preventDirtyRottenNoGoodCheaters()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        removeCheaterStopperWindow()
    }

    private func preventDirtyRottenNoGoodCheaters() {
        let cheaterStopperWindow = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: StoryboardNames.launchScreen, bundle: nil)
        let launchScreenViewController = storyboard.instantiateInitialViewController()
        cheaterStopperWindow.windowLevel = .alert + 1
        cheaterStopperWindow.rootViewController = launchScreenViewController
        cheaterStopperWindow.makeKeyAndVisible()
        self.cheaterStopperWindow = cheaterStopperWindow
    }

    private func removeCheaterStopperWindow() {
        cheaterStopperWindow = nil
    }

}

