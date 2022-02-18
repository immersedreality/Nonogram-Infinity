//
//  Puzzle.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/9/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import Foundation

class Puzzle {

    let solution: [[Bool]]
    let columnOneSolution: [Bool]
    let columnTwoSolution: [Bool]
    let columnThreeSolution: [Bool]
    let columnFourSolution: [Bool]
    let columnFiveSolution: [Bool]

    var rowCorrectCounts: [Int] {
        return solution.map { $0.filter { $0 == true }.count }
    }

    var columnCorrectCounts: [Int] {
        return [
            columnOneSolution,
            columnTwoSolution,
            columnThreeSolution,
            columnFourSolution,
            columnFiveSolution
        ].map { $0.filter { $0 == true }.count }
    }

    var totalCorrectCount: Int {
        get {
            let flattenedSolution = solution.flatMap { $0 }
            return flattenedSolution.filter { $0 == true }.count
        }
    }

    init() {
        self.solution = SolutionGenerator.generateSolution()
        self.columnOneSolution = solution.map { $0[0] }
        self.columnTwoSolution = solution.map { $0[1] }
        self.columnThreeSolution = solution.map { $0[2] }
        self.columnFourSolution = solution.map { $0[3] }
        self.columnFiveSolution = solution.map { $0[4] }
    }

    func generateRowLabelText() -> [String] {

        var rowLabelText: [String] = []

        for row in solution {
            rowLabelText.append(SolutionGenerator.generatePuzzleLabelText(for: row, rowOrColumn: .row))
        }

        return rowLabelText
    }

    func generateColumnLabelText() -> [String] {

        var columnLabelText: [String] = []

        columnLabelText.append(SolutionGenerator.generatePuzzleLabelText(for: columnOneSolution, rowOrColumn: .column))
        columnLabelText.append(SolutionGenerator.generatePuzzleLabelText(for: columnTwoSolution, rowOrColumn: .column))
        columnLabelText.append(SolutionGenerator.generatePuzzleLabelText(for: columnThreeSolution, rowOrColumn: .column))
        columnLabelText.append(SolutionGenerator.generatePuzzleLabelText(for: columnFourSolution, rowOrColumn: .column))
        columnLabelText.append(SolutionGenerator.generatePuzzleLabelText(for: columnFiveSolution, rowOrColumn: .column))

        return columnLabelText
    }

}
