//
//  Run.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/9/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import Foundation
import Combine

class Run {

    var gameTimer = GameTimer()
    var currentPuzzle = Puzzle()

    var currentTouchCellIndexes: [Int] = []
    var currentTouchScore: Int = 0
    @Published var totalScore: Int = 0

    var animatedEventsLabelCorrectText: String {
        if currentTouchScore == 10 {
            return String(currentTouchScore)
        } else {
            return String(currentTouchScore) + "x" + String(currentTouchCellIndexes.count)
        }
    }
    let animatedEventsLabelMissText = "-5 SEC"
    let animatedEventsLabelCompletedText = "+10 SEC"
    var latestEvent: EventToAnimate = .correct

    var userAttemptedToCheat = false
}

enum EventToAnimate {
    case completed, correct, finishedAnimating, miss
}
