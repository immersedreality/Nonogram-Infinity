//
//  HowToPlayScene.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/10/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import SpriteKit

class HowToPlayScene: SKScene {

    var practiceLabel = SKLabelNode()
    var gotItLabel = SKLabelNode()

    override func sceneDidLoad() {
        setUpPracticeLabel()
        setUpGotItLabel()
    }

    private func setUpPracticeLabel() {
        guard let practiceLabel = self.childNode(withName: HowToPlayNodeNames.practiceLabel) as? SKLabelNode else { return }
        self.practiceLabel = practiceLabel
    }

    private func setUpGotItLabel() {
        guard let gotItLabel = self.childNode(withName: HowToPlayNodeNames.gotItLabel) as? SKLabelNode else { return }
        self.gotItLabel = gotItLabel
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = nodes(at: touchLocation)

        if touchedNode.contains(practiceLabel) {
            handlePracticeLabelTouch()
        } else if touchedNode.contains(gotItLabel) {
            handleGotItLabelTouch()
        }

    }

    private func handlePracticeLabelTouch() {
        navigateToGameScene(forPractice: true)
    }

    private func handleGotItLabelTouch() {
        if PersistedSettings.userHasClaimedTheyGotIt {
            let transition = SKTransition.push(with: .down, duration: 0.4)
            guard let titleScreenScene = TitleScreenScene(fileNamed: SceneNames.titleScreenScene) else { return }
            titleScreenScene.scaleMode = .aspectFit
            scene?.view?.presentScene(titleScreenScene, transition: transition)
        } else {
            PersistedSettings.userHasClaimedTheyGotIt = true
            navigateToGameScene(forPractice: false)
        }

    }

    private func navigateToGameScene(forPractice: Bool) {
        let transition: SKTransition

        if forPractice {
            transition = SKTransition.doorsOpenHorizontal(withDuration: 0.4)
        } else {
            transition = SKTransition.doorway(withDuration: 0.8)
        }

        switch PersistedSettings.playerHandedness {
        case .left:
            guard let gameScene = GameScene(fileNamed: SceneNames.gameSceneLeftHanded) else { return }
            gameScene.currentRun.isForPractice = forPractice
            gameScene.scaleMode = .aspectFit
            scene?.view?.presentScene(gameScene, transition: transition)
        case .right:
            guard let gameScene = GameScene(fileNamed: SceneNames.gameSceneRightHanded) else { return }
            gameScene.currentRun.isForPractice = forPractice
            gameScene.scaleMode = .aspectFit
            scene?.view?.presentScene(gameScene, transition: transition)
        }
    }
    
}
