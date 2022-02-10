//
//  TitleScreenScene.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 7/6/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import SpriteKit
import GameplayKit

class TitleScreenScene: SKScene {

    var openLabel = SKLabelNode()
    var settingsLabel = SKLabelNode()
    var highScoreTitleLabel = SKLabelNode()
    var highScoreValueLabel = SKLabelNode()

    override func sceneDidLoad() {
        setUpOpenLabel()
        setUpSettingsLabel()
        setUpHighScoreLabels()
    }

    private func setUpOpenLabel() {
        guard let openLabel = self.childNode(withName: TitleScreenNodeNames.openLabel) as? SKLabelNode else { return }
        self.openLabel = openLabel
    }

    private func setUpSettingsLabel() {
        guard let settingsLabel = self.childNode(withName: TitleScreenNodeNames.settingsLabel) as? SKLabelNode else { return }
        self.settingsLabel = settingsLabel
    }

    private func setUpHighScoreLabels() {
        guard let highScoreTitleLabel = self.childNode(withName: TitleScreenNodeNames.highScoreTitleLabel) as? SKLabelNode else { return }
        self.highScoreTitleLabel = highScoreTitleLabel

        guard let highScoreValueLabel = self.childNode(withName: TitleScreenNodeNames.highScoreValueLabel) as? SKLabelNode else { return }
        self.highScoreValueLabel = highScoreValueLabel

        let currentHighScore = PersistedSettings.allTimeHighScore
        if currentHighScore > 0 {
            highScoreTitleLabel.isHidden = false
            highScoreValueLabel.isHidden = false
            highScoreValueLabel.text = String(currentHighScore)
        } else {
            highScoreTitleLabel.isHidden = true
            highScoreValueLabel.isHidden = true
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = nodes(at: touchLocation)

        if touchedNode.contains(openLabel) {
            handleOpenLabelTouch()
        } else if touchedNode.contains(settingsLabel) {
            handleSettingsLabelTouch()
        }
    }

    private func handleOpenLabelTouch() {
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

    private func handleSettingsLabelTouch() {
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.4)
        guard let settingsScene = SettingsScene(fileNamed: SceneNames.settingsScene) else { return }
        settingsScene.scaleMode = .aspectFill
        scene?.view?.presentScene(settingsScene, transition: transition)
    }

}
