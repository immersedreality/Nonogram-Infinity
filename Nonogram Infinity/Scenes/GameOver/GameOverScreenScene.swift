//
//  GameOverScreenScene.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 7/6/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScreenScene: SKScene {

    var finishedRun: Run!

    var scoreLabel = SKLabelNode()
    var highScoreTitleLabel = SKLabelNode()
    var highScoreValueLabel = SKLabelNode()
    var reopenLabel = SKLabelNode()
    var quitLabel = SKLabelNode()

    override func sceneDidLoad() {
        super.sceneDidLoad()
        setUpReopenLabel()
        setUpQuitLabel()
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setUpScoreLabel()
        setUpHighScoreLabels()
    }

    private func setUpReopenLabel() {
        guard let reopenLabel = self.childNode(withName: GameOverScreenNodeNames.reopenLabel) as? SKLabelNode else { return }
        self.reopenLabel = reopenLabel
    }

    private func setUpQuitLabel() {
        guard let quitLabel = self.childNode(withName: GameOverScreenNodeNames.quitLabel) as? SKLabelNode else { return }
        self.quitLabel = quitLabel
    }

    private func setUpScoreLabel() {
        guard let scoreLabel = self.childNode(withName: GameOverScreenNodeNames.scoreLabel) as? SKLabelNode else { return }
        self.scoreLabel = scoreLabel

        guard !finishedRun.userAttemptedToCheat else {
            scoreLabel.text = "NICE TRY!"
            return
        }

        scoreLabel.text = String(finishedRun.totalScore)
    }

    private func setUpHighScoreLabels() {
        guard let highScoreTitleLabel = self.childNode(withName: GameOverScreenNodeNames.highScoreTitleLabel) as? SKLabelNode else { return }
        self.highScoreTitleLabel = highScoreTitleLabel

        guard let highScoreValueLabel = self.childNode(withName: GameOverScreenNodeNames.highScoreValueLabel) as? SKLabelNode else { return }
        self.highScoreValueLabel = highScoreValueLabel

        let currentHighScore = PersistedSettings.allTimeHighScore
        if finishedRun.totalScore > currentHighScore {
            highScoreTitleLabel.text = "NEW HIGH SCORE!"
            highScoreValueLabel.isHidden = true
            saveHighScore()
        } else {
            highScoreValueLabel.text = String(currentHighScore)
        }

    }

    private func saveHighScore() {
        LeaderboardManager.submit(score: finishedRun.totalScore)
        PersistedSettings.allTimeHighScore = finishedRun.totalScore
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = nodes(at: touchLocation)

        if touchedNode.contains(reopenLabel) {
            handleReopenLabelTouch()
        } else if touchedNode.contains(quitLabel) {
            handleQuitLabelTouch()
        }
        
    }

    private func handleReopenLabelTouch() {
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

    private func handleQuitLabelTouch() {
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.4)
        guard let titleScreenScene = TitleScreenScene(fileNamed: SceneNames.titleScreenScene) else { return }
        titleScreenScene.scaleMode = .aspectFit
        scene?.view?.presentScene(titleScreenScene, transition: transition)
    }
    
}
