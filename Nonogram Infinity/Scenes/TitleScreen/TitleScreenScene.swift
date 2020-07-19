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

    var playLabel = SKLabelNode()
    var settingsLabel = SKLabelNode()

    override func didMove(to view: SKView) {
        setUpPlayLabel()
        setUpSettingsLabel()
    }

    private func setUpPlayLabel() {
        guard let playLabel = self.childNode(withName: TitleScreenNodeNames.playLabel) as? SKLabelNode else { return }
        self.playLabel = playLabel
    }

    private func setUpSettingsLabel() {
        guard let settingsLabel = self.childNode(withName: TitleScreenNodeNames.settingsLabel) as? SKLabelNode else { return }
        self.settingsLabel = settingsLabel
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = nodes(at: touchLocation)

        if touchedNode.contains(playLabel) {
            handlePlayLabelTouch()
        } else if touchedNode.contains(settingsLabel) {
            handleSettingsLabelTouch()
        }

    }

    private func handlePlayLabelTouch() {
        let transition = SKTransition.doorway(withDuration: 0.8)
        guard let gameScene = GameScene(fileNamed: SceneNames.gameScene) else { return }
        gameScene.scaleMode = .aspectFill
        scene?.view?.presentScene(gameScene, transition: transition)
    }

    private func handleSettingsLabelTouch() {

    }

}
