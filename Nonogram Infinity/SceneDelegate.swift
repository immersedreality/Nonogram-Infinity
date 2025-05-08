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

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if connectingSceneSession.role == UISceneSession.Role.windowApplication {
            let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            config.delegateClass = SceneDelegate.self
            return config
        }
        fatalError("Unhandled scene role \(connectingSceneSession.role)")
    }

}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var cheaterStopperWindow: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: scene)
        let storyboard = UIStoryboard(name: "NonogramInfinity", bundle: nil)
        window?.rootViewController = storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()
        AudioManager.configurePlayers()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        preventDirtyRottenNoGoodCheaters(scene: scene)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        LeaderboardManager.authenticateLocalPlayer()
        AdManager.shared.requestIDFA()
        removeCheaterStopperWindow()
    }

    private func preventDirtyRottenNoGoodCheaters(scene: UIScene) {
        guard let scene = scene as? UIWindowScene else { return }
        let cheaterStopperWindow = UIWindow(windowScene: scene)
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
