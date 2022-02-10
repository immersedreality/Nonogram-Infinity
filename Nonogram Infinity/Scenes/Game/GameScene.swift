//
//  GameScene.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 7/2/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import SpriteKit
import GameplayKit
import Combine

class GameScene: SKScene {

    var scoreLabel = SKLabelNode()
    var timeLabel = SKLabelNode()
    var cells: [NonogramCell] = []
    var rowLabels: [SKLabelNode] = []
    var columnLabels: [SKLabelNode] = []

    var currentRun = Run()

    private var cancellables: Set<AnyCancellable> = []

    override func sceneDidLoad() {
        setUpScoreLabel()
        setUpTimeLabel()
        setUpPuzzleLabels()
        setUpNonogramCells()
    }

    override func didMove(to view: SKView) {
        setUpTimer()
        setUpAudio()
    }

    private func setUpScoreLabel() {
        guard let scoreLabel = self.childNode(withName: GameNodeNames.scoreLabel) as? SKLabelNode else { return }
        self.scoreLabel = scoreLabel

        currentRun.$totalScore
            .sink { newScore in self.scoreLabel.text = String(newScore) }
            .store(in: &cancellables)

    }

    private func setUpTimeLabel() {
        guard let timeLabel = self.childNode(withName: GameNodeNames.timeLabel) as? SKLabelNode else { return }
        self.timeLabel = timeLabel

        currentRun.gameTimer.$secondsRemaining
            .sink { newTime in
                if newTime > 0 {
                    self.timeLabel.text = String(newTime)
                } else {
                    self.removeAction(forKey: ActionKeys.timer)
                    self.transitionToGameOverScreen()
                }
            }
            .store(in: &cancellables)
    }

    private func setUpPuzzleLabels() {

        let rowLabelText = currentRun.currentPuzzle.generateRowLabelText()
        let columnLabelText = currentRun.currentPuzzle.generateColumnLabelText()

        for index in 1...5 {
            guard let rowLabel = self.childNode(withName: GameNodeNames.rowLabel + String(index)) as? SKLabelNode else { return }
            guard let columnLabel = self.childNode(withName: GameNodeNames.columnLabel + String(index)) as? SKLabelNode else { return }
            rowLabel.text = rowLabelText[index - 1]
            columnLabel.text = columnLabelText[index - 1]
        }

    }

    private func setUpNonogramCells() {

        var row = 1
        var column = 1

        for index in 1...25 {
            guard let cellNode = self.childNode(withName: GameNodeNames.cell + String(index)) as? SKSpriteNode else { return }
            self.cells.append(NonogramCell(index: (index - 1), sprite: cellNode, row: row, column: column, isCorrect: currentRun.currentPuzzle.solution[row - 1][column - 1]))

            column += 1
            if column > 5 {
                column = 1
                row += 1
            }
        }

    }

    private func setUpTimer() {
        run(SKAction.repeatForever(currentRun.gameTimer.timerSequence), withKey: ActionKeys.timer)
    }

    private func setUpAudio() {
        if !PersistedSettings.musicDisabled {
            let backgroundSound = SKAudioNode(fileNamed: "BGM.wav")
            self.addChild(backgroundSound)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = nodes(at: touchLocation)

        for cell in cells {
            guard !cell.isPartOfCurrentTouch, !cell.isActivated else { continue }

            if touchedNode.contains(cell.sprite) {
                let touchWasCorrect = cell.checkIfCorrect()
                if touchWasCorrect {
                    currentRun.currentTouchCellIndexes.append(cell.index)
                    currentRun.currentTouchScore += 10
                } else {
                    currentRun.gameTimer.secondsRemaining -= 5
                }
                cell.isPartOfCurrentTouch = true
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = nodes(at: touchLocation)

        var touchMovedOutOfRange = true

        for cell in cells {

            if touchedNode.contains(cell.sprite) {
                touchMovedOutOfRange = false

                guard !cell.isPartOfCurrentTouch, !cell.isActivated else { continue }
                cell.isPartOfCurrentTouch = true
                let touchWasCorrect = cell.checkIfCorrect()
                if touchWasCorrect {
                    currentRun.currentTouchCellIndexes.append(cell.index)
                    currentRun.currentTouchScore += 10
                } else {
                    for index in currentRun.currentTouchCellIndexes {
                        cells[index].resetCell(isCorrect: cells[index].isCorrect)
                    }
                    currentRun.currentTouchCellIndexes.removeAll()
                    currentRun.currentTouchScore = 0
                    currentRun.gameTimer.secondsRemaining -= 5
                }
                cell.isPartOfCurrentTouch = true
            }
        }

        if touchMovedOutOfRange {
            handleCompletedTouch()
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleCompletedTouch()
    }

    private func handleCompletedTouch() {
        cells.forEach { $0.isPartOfCurrentTouch = false }
        currentRun.totalScore += (currentRun.currentTouchScore * currentRun.currentTouchCellIndexes.count)
        currentRun.currentTouchCellIndexes.removeAll()
        currentRun.currentTouchScore = 0
        checkForPuzzleCompletion()
    }

    private func resetNonogramCells() {

        for index in 1...25 {
            let currentCell = cells[index - 1]
            currentCell.resetCell(isCorrect: currentRun.currentPuzzle.solution[currentCell.row - 1][currentCell.column - 1])
        }

    }

    private func checkForPuzzleCompletion() {
        let numberOfCellsFilled = cells.filter { $0.isActivated == true }.count
        if numberOfCellsFilled == currentRun.currentPuzzle.totalCorrectCount {
            currentRun.gameTimer.secondsRemaining += 10
            currentRun.currentPuzzle = Puzzle()
            setUpPuzzleLabels()
            resetNonogramCells()
        }
    }

    private func transitionToGameOverScreen() {
        let transition = SKTransition.doorsCloseVertical(withDuration: 0.4)
        guard let gameOverScreenScene = GameOverScreenScene(fileNamed: SceneNames.gameOverScreenScene) else { return }
        gameOverScreenScene.scaleMode = .aspectFill
        gameOverScreenScene.finishedRun = currentRun
        scene?.view?.presentScene(gameOverScreenScene, transition: transition)
    }

    override func update(_ currentTime: TimeInterval) {
    }

}
