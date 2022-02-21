//
//  TitleScreenScene.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 7/6/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import SpriteKit
import GameKit
import GameplayKit

class TitleScreenScene: SKScene {

    var helpLabel = SKLabelNode()
    var openLabel = SKLabelNode()
    var settingsLabel = SKLabelNode()
    var creditsLabel = SKLabelNode()
    var highScoreTitleLabel = SKLabelNode()
    var highScoreValueLabel = SKLabelNode()

    override func sceneDidLoad() {
        super.sceneDidLoad()
        setUpHelpLabel()
        setUpOpenLabel()
        setUpSettingsLabel()
        setUpCreditsLabel()
        setUpHighScoreLabels()
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        LeaderboardManager.authenticateLocalPlayer()
    }

    private func setUpHelpLabel() {
        guard let helpLabel = self.childNode(withName: TitleScreenNodeNames.helpLabel) as? SKLabelNode else { return }
        self.helpLabel = helpLabel
        helpLabel.isHidden = !PersistedSettings.userHasClaimedTheyGotIt
    }

    private func setUpOpenLabel() {
        guard let openLabel = self.childNode(withName: TitleScreenNodeNames.openLabel) as? SKLabelNode else { return }
        self.openLabel = openLabel
    }

    private func setUpSettingsLabel() {
        guard let settingsLabel = self.childNode(withName: TitleScreenNodeNames.settingsLabel) as? SKLabelNode else { return }
        self.settingsLabel = settingsLabel
    }

    private func setUpCreditsLabel() {
        guard let creditsLabel = self.childNode(withName: TitleScreenNodeNames.creditsLabel) as? SKLabelNode else { return }
        self.creditsLabel = creditsLabel
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

        if touchedNode.contains(helpLabel) {
            handleHelpLabelTouch()
        } else if touchedNode.contains(openLabel) {
            handleOpenLabelTouch()
        } else if touchedNode.contains(settingsLabel) {
            handleSettingsLabelTouch()
        } else if touchedNode.contains(creditsLabel) {
            handleCreditsLabelTouch()
        } else if touchedNode.contains(highScoreTitleLabel) || touchedNode.contains(highScoreValueLabel) {
            handleHighScoreLabelTouch()
        }
    }

    private func handleHelpLabelTouch() {
        let transition = SKTransition.push(with: .up, duration: 0.4)
        guard let howToPlayScene = HowToPlayScene(fileNamed: SceneNames.howToPlayScene) else { return }
        howToPlayScene.scaleMode = .aspectFit
        scene?.view?.presentScene(howToPlayScene, transition: transition)
    }

    private func handleOpenLabelTouch() {
        guard PersistedSettings.userHasClaimedTheyGotIt else {
            handleHelpLabelTouch()
            return
        }

        let transition = SKTransition.doorway(withDuration: 0.8)
        switch PersistedSettings.playerHandedness {
        case .left:
            guard let gameScene = GameScene(fileNamed: SceneNames.gameSceneLeftHanded) else { return }
            gameScene.scaleMode = .aspectFit
            scene?.view?.presentScene(gameScene, transition: transition)
        case .right:
            guard let gameScene = GameScene(fileNamed: SceneNames.gameSceneRightHanded) else { return }
            gameScene.scaleMode = .aspectFit
            scene?.view?.presentScene(gameScene, transition: transition)
        }

    }

    private func handleSettingsLabelTouch() {
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.4)
        guard let settingsScene = SettingsScene(fileNamed: SceneNames.settingsScene) else { return }
        settingsScene.scaleMode = .aspectFit
        scene?.view?.presentScene(settingsScene, transition: transition)
    }

    private func handleCreditsLabelTouch() {
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.4)
        guard let creditsScene = CreditsScene(fileNamed: SceneNames.creditsScene) else { return }
        creditsScene.scaleMode = .aspectFit
        scene?.view?.presentScene(creditsScene, transition: transition)
    }

    private func handleHighScoreLabelTouch() {
        LeaderboardManager.viewLeaderboard()
    }

}
