//
//  SolutionGenerator.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/9/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import SpriteKit
import GameplayKit

class SolutionGenerator {

    class func generateSolution() -> [[Bool]] {

        var unformattedSolution: [Bool] = []

        for _ in 1...25 {
            let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: 2)
            if randomNumber == 0 {
                unformattedSolution.append(false)
            } else {
                unformattedSolution.append(true)
            }
        }

        var solutionCount = unformattedSolution.filter { $0 == true }.count
        var falseIndexes: [Int] = []
        for (index, isCorrect) in unformattedSolution.enumerated() {
            if !isCorrect {
                falseIndexes.append(index)
            }
        }

        // 15 seems to work pretty well
        while solutionCount < 15 {
            let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: falseIndexes.count)
            let indexToFlip = falseIndexes.remove(at: randomIndex)
            unformattedSolution[indexToFlip] = true
            solutionCount = unformattedSolution.filter { $0 == true }.count
        }

        let rowOneSolution: [Bool] = Array(unformattedSolution[0...4])
        let rowTwoSolution: [Bool] = Array(unformattedSolution[5...9])
        let rowThreeSolution: [Bool] = Array(unformattedSolution[10...14])
        let rowFourSolution: [Bool] = Array(unformattedSolution[15...19])
        let rowFiveSolution: [Bool] = Array(unformattedSolution[20...24])

        let formattedSolution: [[Bool]] = [
            rowOneSolution,
            rowTwoSolution,
            rowThreeSolution,
            rowFourSolution,
            rowFiveSolution
        ]

        return formattedSolution

    }

    class func generatePuzzleLabelText(for solution: [Bool], rowOrColumn: SolutionTextGenerationType) -> String {

        var firstNumber: Int = 0
        var secondNumber: Int?
        var thirdNumber: Int?

        var currentNumberIteratingOver: CurrentNumberIteratingOver = .one

        for isCorrect in solution {
            switch currentNumberIteratingOver {
            case .one:
                if isCorrect {
                    firstNumber += 1
                } else {
                    if firstNumber > 0 {
                        currentNumberIteratingOver = .two
                    }
                }
            case .two:
                if isCorrect {
                    if let unwrappedSecondNumber = secondNumber {
                        secondNumber = unwrappedSecondNumber + 1
                    } else {
                        secondNumber = 1
                    }
                } else {
                    if secondNumber != nil {
                        currentNumberIteratingOver = .three
                    }
                }
            case .three:
                if isCorrect {
                    if let unwrappedThirdNumber = thirdNumber {
                        thirdNumber = unwrappedThirdNumber + 1
                    } else {
                        thirdNumber = 1
                    }
                }
            }
        }

        var formattedText = String(firstNumber)
        if let secondNumber = secondNumber {
            if rowOrColumn == .row {
                formattedText += " "
            }
            formattedText += String(secondNumber)
        }
        if let thirdNumber = thirdNumber {
            if rowOrColumn == .row {
                formattedText += " "
            }
            formattedText += String(thirdNumber)
        }

        return formattedText

    }

}

enum SolutionTextGenerationType {
    case column, row
}

enum CurrentNumberIteratingOver {
    case one, two, three
}
