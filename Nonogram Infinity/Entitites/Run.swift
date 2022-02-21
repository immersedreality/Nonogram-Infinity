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

    // MARK: Game Components
    var gameTimer = GameTimer()
    var currentPuzzle = Puzzle()

    // MARK: Scoring Properties
    var currentTouchCellIndexes: [Int] = []
    var currentTouchScore: Int = 0
    @Published var totalScore: Int = 0

    // MARK: Animation Properties
    var animatedEventsLabelCorrectText: String {
        if currentTouchScore == 10 {
            return String(currentTouchScore)
        } else {
            return String(currentTouchScore) + "x" + String(currentTouchCellIndexes.count)
        }
    }
    let animatedEventsLabelMissText = "-5 SEC"
    let animatedEventsLabelCompletedText = "+10 SEC"
    let animatedEventsLabelPracticeCompletedText = "NICE!"
    var latestEvent: EventToAnimate = .correct

    // MARK: State Properties
    var isForPractice = false
    var userAttemptedToCheat = false
}

enum EventToAnimate {
    case completed, correct, finishedAnimating, miss, practiceCompleted
}
