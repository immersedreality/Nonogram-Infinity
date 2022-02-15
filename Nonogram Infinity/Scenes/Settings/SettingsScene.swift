//
//  SettingsScene.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 7/6/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import SpriteKit

class SettingsScene: SKScene {

    var musicTitleLabel = SKLabelNode()
    var musicValueLabel = SKLabelNode()
    var handTitleLabel = SKLabelNode()
    var handValueLabel = SKLabelNode()
    var backLabel = SKLabelNode()

    override func sceneDidLoad() {
        setUpMusicLabels()
        setUpHandLabels()
        setUpBackLabel()
    }

    private func setUpMusicLabels() {
        guard let musicTitleLabel = self.childNode(withName: SettingsNodeNames.musicTitleLabel) as? SKLabelNode else { return }
        self.musicTitleLabel = musicTitleLabel

        guard let musicValueLabel = self.childNode(withName: SettingsNodeNames.musicValueLabel) as? SKLabelNode else { return }
        self.musicValueLabel = musicValueLabel

        updateMusicValueLabel()
    }

    private func updateMusicValueLabel() {
        musicValueLabel.text = PersistedSettings.musicDisabled ? "DISABLED" : "ENABLED"
    }

    private func setUpHandLabels() {
        guard let handTitleLabel = self.childNode(withName: SettingsNodeNames.handTitleLabel) as? SKLabelNode else { return }
        self.handTitleLabel = handTitleLabel

        guard let handValueLabel = self.childNode(withName: SettingsNodeNames.handValueLabel) as? SKLabelNode else { return }
        self.handValueLabel = handValueLabel

        updateHandValueLabel()
    }

    private func updateHandValueLabel() {
        handValueLabel.text = PersistedSettings.playerHandedness == .left ? "LEFT" : "RIGHT"
    }

    private func setUpBackLabel() {
        guard let backLabel = self.childNode(withName: SettingsNodeNames.backLabel) as? SKLabelNode else { return }
        self.backLabel = backLabel
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = nodes(at: touchLocation)

        if touchedNode.contains(musicTitleLabel) || touchedNode.contains(musicValueLabel) {
            handleMusicLabelTouch()
        } else if touchedNode.contains(handTitleLabel) || touchedNode.contains(handValueLabel) {
            handleHandLabelTouch()
        } else if touchedNode.contains(backLabel) {
            handleBackLabelTouch()
        }
    }

    private func handleMusicLabelTouch() {
        if !PersistedSettings.musicDisabled {
            PersistedSettings.musicDisabled = true
        } else {
            PersistedSettings.musicDisabled = false
        }
        updateMusicValueLabel()
    }

    private func handleHandLabelTouch() {
        if PersistedSettings.playerHandedness == .left {
            PersistedSettings.playerHandedness = .right
        } else {
            PersistedSettings.playerHandedness = .left
        }
        updateHandValueLabel()
    }

    private func handleBackLabelTouch() {
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.4)
        guard let titleScreenScene = TitleScreenScene(fileNamed: SceneNames.titleScreenScene) else { return }
        titleScreenScene.scaleMode = .aspectFit
        scene?.view?.presentScene(titleScreenScene, transition: transition)
    }

    override func update(_ currentTime: TimeInterval) {
    }

}
