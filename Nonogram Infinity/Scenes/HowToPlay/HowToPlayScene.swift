//
//  HowToPlayScene.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/10/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import SpriteKit

class HowToPlayScene: SKScene {

    var gotItLabel = SKLabelNode()

    override func sceneDidLoad() {
        setUpGotItLabel()
    }

    private func setUpGotItLabel() {
        guard let gotItLabel = self.childNode(withName: HowToPlayNodeNames.gotItLabel) as? SKLabelNode else { return }
        self.gotItLabel = gotItLabel
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = nodes(at: touchLocation)

        if touchedNode.contains(gotItLabel) {
            handleGotItLabelTouch()
        }

    }

    private func handleGotItLabelTouch() {
        if PersistedSettings.userHasClaimedTheyGotIt {
            let transition = SKTransition.push(with: .down, duration: 0.4)
            guard let titleScreenScene = TitleScreenScene(fileNamed: SceneNames.titleScreenScene) else { return }
            titleScreenScene.scaleMode = .aspectFill
            scene?.view?.presentScene(titleScreenScene, transition: transition)
        } else {
            PersistedSettings.userHasClaimedTheyGotIt = true

            let transition = SKTransition.doorway(withDuration: 0.8)
            switch PersistedSettings.playerHandedness {
            case .left:
                guard let gameScene = GameScene(fileNamed: SceneNames.gameSceneLeftHanded) else { return }
                gameScene.scaleMode = .aspectFill
                scene?.view?.presentScene(gameScene, transition: transition)
            case .right:
                guard let gameScene = GameScene(fileNamed: SceneNames.gameSceneRightHanded) else { return }
                gameScene.scaleMode = .aspectFill
                scene?.view?.presentScene(gameScene, transition: transition)
            }
        }

    }
    
}
