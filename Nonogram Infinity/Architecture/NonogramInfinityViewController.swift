//
//  NonogramInfinityViewController.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 7/2/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class NonogramInfinityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitleScreenScene()
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
