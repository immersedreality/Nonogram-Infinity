//
//  SolutionGenerator.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/9/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import SpriteKit
import GameplayKit

final class SolutionGenerator {

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

        increaseNumberOfCorrectSquaresIfNecessary(for: &unformattedSolution)

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

        if puzzleIsSolveableWithoutGuesswork(formattedSolution: formattedSolution) {
            return formattedSolution
        } else {
            return generateSolution()
        }

    }

    private class func increaseNumberOfCorrectSquaresIfNecessary(for unformattedSolution: inout [Bool]) {
        var solutionCount = unformattedSolution.filter { $0 == true }.count
        var falseIndexes: [Int] = []
        for (index, isCorrect) in unformattedSolution.enumerated() {
            if !isCorrect {
                falseIndexes.append(index)
            }
        }

        // 16 seems to work pretty well
        while solutionCount < 16 {
            let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: falseIndexes.count)
            let indexToFlip = falseIndexes.remove(at: randomIndex)
            unformattedSolution[indexToFlip] = true
            solutionCount = unformattedSolution.filter { $0 == true }.count
        }
    }

    private class func puzzleIsSolveableWithoutGuesswork(formattedSolution: [[Bool]]) -> Bool {
        let columnOneSolution = formattedSolution.map { $0[0] }
        let columnTwoSolution = formattedSolution.map { $0[1] }
        let columnThreeSolution = formattedSolution.map { $0[2] }
        let columnFourSolution = formattedSolution.map { $0[3] }
        let columnFiveSolution = formattedSolution.map { $0[4] }
        let columnSolutions = [columnOneSolution, columnTwoSolution, columnThreeSolution, columnFourSolution, columnFiveSolution]

        let rowTextArray = formattedSolution.map { generatePuzzleLabelText(for: $0, rowOrColumn: .row) }
        let columnTextArray = columnSolutions.map { generatePuzzleLabelText(for: $0, rowOrColumn: .column) }

        return Set(rowTextArray).count == 5 || Set(columnTextArray).count == 5
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
