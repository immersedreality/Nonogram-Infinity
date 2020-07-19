//
//  GameScene.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 7/2/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let backgroundSound = SKAudioNode(fileNamed: "BGM.wav")
        self.addChild(backgroundSound)
    }

    override func update(_ currentTime: TimeInterval) {
    }

}
