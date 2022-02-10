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

    var totalCorrectCount: Int {
        get {
            let flattenedSolution = solution.flatMap { $0 }
            return flattenedSolution.filter { $0 == true }.count
        }
    }

    init() {
        self.solution = SolutionGenerator.generateSolution()
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

        let columnOneSolution = solution.map { $0[0] }
        let columnTwoSolution = solution.map { $0[1] }
        let columnThreeSolution = solution.map { $0[2] }
        let columnFourSolution = solution.map { $0[3] }
        let columnFiveSolution = solution.map { $0[4] }

        columnLabelText.append(SolutionGenerator.generatePuzzleLabelText(for: columnOneSolution, rowOrColumn: .column))
        columnLabelText.append(SolutionGenerator.generatePuzzleLabelText(for: columnTwoSolution, rowOrColumn: .column))
        columnLabelText.append(SolutionGenerator.generatePuzzleLabelText(for: columnThreeSolution, rowOrColumn: .column))
        columnLabelText.append(SolutionGenerator.generatePuzzleLabelText(for: columnFourSolution, rowOrColumn: .column))
        columnLabelText.append(SolutionGenerator.generatePuzzleLabelText(for: columnFiveSolution, rowOrColumn: .column))

        return columnLabelText
    }

}
