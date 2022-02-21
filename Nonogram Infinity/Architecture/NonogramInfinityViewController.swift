//
//  NonogramInfinityViewController.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 7/2/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class NonogramInfinityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitleScreenScene()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setUpTitleScreenScene() {
        guard let view = self.view as? SKView else { return }
        if let titleScreenScene = TitleScreenScene(fileNamed: SceneNames.titleScreenScene) {
            titleScreenScene.scaleMode = .aspectFit
            view.presentScene(titleScreenScene)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension NonogramInfinityViewController: UINavigationControllerDelegate, GKGameCenterControllerDelegate {

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }

}
