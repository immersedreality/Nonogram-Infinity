//
//  GameTimer.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/9/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import Foundation
import Combine
import SpriteKit

class GameTimer {

    @Published var secondsRemaining: Int = 60

    var waitAction = SKAction()
    var timerAction = SKAction()
    var timerSequence = SKAction()

    init() {
        setUpActions()
    }

    private func setUpActions() {
        self.waitAction = SKAction.wait(forDuration: 1.0)
        self.timerAction = SKAction.run { self.secondsRemaining -= 1 }
        self.timerSequence = SKAction.sequence([waitAction, timerAction])
    }

}
