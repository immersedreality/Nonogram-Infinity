//
//  CreditsScene.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/15/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import SpriteKit

class CreditsScene: SKScene {

    var bozoDesignLabsLabel = SKLabelNode()
    var meLabel = SKLabelNode()
    var eightBitEscapadesLabel = SKLabelNode()
    var kingGizzardLabel = SKLabelNode()
    var littleRobotLabel = SKLabelNode()
    var backLabel = SKLabelNode()

    override func sceneDidLoad() {
        super.sceneDidLoad()
        setUpLinkLabels()
        setUpBackLabel()
    }

    private func setUpLinkLabels() {
        guard let bozoDesignLabsLabel = self.childNode(withName: CreditsNodeNames.bozoDesignLabsLabel) as? SKLabelNode else { return }
        self.bozoDesignLabsLabel = bozoDesignLabsLabel

        guard let meLabel = self.childNode(withName: CreditsNodeNames.meLabel) as? SKLabelNode else { return }
        self.meLabel = meLabel

        guard let eightBitEscapadesLabel = self.childNode(withName: CreditsNodeNames.eightBitEscapadesLabel) as? SKLabelNode else { return }
        self.eightBitEscapadesLabel = eightBitEscapadesLabel

        guard let kingGizzardLabel = self.childNode(withName: CreditsNodeNames.kingGizzardLabel) as? SKLabelNode else { return }
        self.kingGizzardLabel = kingGizzardLabel

        guard let littleRobotLabel = self.childNode(withName: CreditsNodeNames.littleRobotLabel) as? SKLabelNode else { return }
        self.littleRobotLabel = littleRobotLabel
    }

    private func setUpBackLabel() {
        guard let backLabel = self.childNode(withName: CreditsNodeNames.backLabel) as? SKLabelNode else { return }
        self.backLabel = backLabel
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = nodes(at: touchLocation)

        if touchedNode.contains(bozoDesignLabsLabel) {
            guard let url = URL(string: "https://www.bozodesignlabs.com") else { return }
            UIApplication.shared.open(url)
        } else if touchedNode.contains(meLabel) {
            guard let url = URL(string: "https://www.linkedin.com/in/jeffreyhoch/") else { return }
            UIApplication.shared.open(url)
        } else if touchedNode.contains(eightBitEscapadesLabel) {
            guard let url = URL(string: "https://8-bitescapades.bandcamp.com") else { return }
            UIApplication.shared.open(url)
        } else if touchedNode.contains(kingGizzardLabel) {
            guard let url = URL(string: "https://gizzverse.com") else { return }
            UIApplication.shared.open(url)
        } else if touchedNode.contains(littleRobotLabel) {
            guard let url = URL(string: "https://freesound.org/people/LittleRobotSoundFactory/") else { return }
            UIApplication.shared.open(url)
        } else if touchedNode.contains(backLabel) {
            handleBackLabelTouch()
        }

    }

    private func handleBackLabelTouch() {
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.4)
        guard let titleScreenScene = TitleScreenScene(fileNamed: SceneNames.titleScreenScene) else { return }
        titleScreenScene.scaleMode = .aspectFit
        scene?.view?.presentScene(titleScreenScene, transition: transition)
    }

}
