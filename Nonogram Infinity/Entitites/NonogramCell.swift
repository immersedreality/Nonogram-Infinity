//
//  NonogramCell.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/9/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import SpriteKit

class NonogramCell {

    let index: Int
    let sprite: SKSpriteNode

    let row: Int
    let column: Int
    
    var isCorrect: Bool
    var isPartOfCurrentTouch: Bool = false
    var isActivated: Bool = false

    init(index: Int, sprite: SKSpriteNode, row: Int, column: Int, isCorrect: Bool) {
        self.index = index
        self.sprite = sprite
        self.row = row
        self.column = column
        self.isCorrect = isCorrect
    }

    func resetCell(isCorrect: Bool) {
        self.isCorrect = isCorrect
        sprite.color = .white
        isActivated = false
    }

    func checkIfCorrect() -> Bool {
        if !isActivated && isCorrect {
            HapticsManager.playTapEvent()
            AudioManager.play(soundEffect: .hit)
            sprite.color = .red
            isActivated = true
        } else if !isCorrect {
            HapticsManager.playMissEvent()
            AudioManager.play(soundEffect: .miss)
        }
        return isCorrect
    }

}
