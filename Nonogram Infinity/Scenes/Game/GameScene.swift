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

    var playArea = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var timeLabel = SKLabelNode()
    var animatedEventsLabel = SKLabelNode()
    var cells: [NonogramCell] = []
    var rowLabels: [SKLabelNode] = []
    var columnLabels: [SKLabelNode] = []

    var currentRun = Run()

    private var cancellables: Set<AnyCancellable> = []

    override func sceneDidLoad() {
        setUpPlayableArea()
        setUpScoreLabel()
        setUpTimeLabel()
        setUpAnimatedEventsLabel()
        setUpPuzzleLabels()
        setUpNonogramCells()
    }

    override func didMove(to view: SKView) {
        setUpTimer()
        setUpAudio()
    }

    private func setUpPlayableArea() {
        guard let playArea = self.childNode(withName: GameNodeNames.playArea) as? SKSpriteNode else { return }
        self.playArea = playArea
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

    private func setUpAnimatedEventsLabel() {
        guard let animatedEventsLabel = self.childNode(withName: GameNodeNames.animatedEventsLabel) as? SKLabelNode else { return }
        self.animatedEventsLabel = animatedEventsLabel
    }

    private func setUpPuzzleLabels() {

        let rowLabelText = currentRun.currentPuzzle.generateRowLabelText()
        let columnLabelText = currentRun.currentPuzzle.generateColumnLabelText()

        for index in 1...5 {
            guard let rowLabel = self.childNode(withName: GameNodeNames.rowLabel + String(index)) as? SKLabelNode else { return }
            rowLabel.text = rowLabelText[index - 1]
            rowLabels.append(rowLabel)

            guard let columnLabel = self.childNode(withName: GameNodeNames.columnLabel + String(index)) as? SKLabelNode else { return }
            columnLabel.text = columnLabelText[index - 1]
            columnLabels.append(columnLabel)
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
            AudioManager.startBackgroundMusic()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)

        for cell in cells {
            guard !cell.isPartOfCurrentTouch, !cell.isActivated else { continue }

            if touchedNodes.contains(cell.sprite) {
                let touchWasCorrect = cell.checkIfCorrect()
                if touchWasCorrect {
                    currentRun.currentTouchCellIndexes.append(cell.index)
                    currentRun.currentTouchScore += 10
                    setAnimatedEventsLabelText(for: .correct)
                } else {
                    currentRun.gameTimer.secondsRemaining -= 5
                    setAnimatedEventsLabelText(for: .miss)
                }
                cell.isPartOfCurrentTouch = true
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)

        guard touchedNodes.contains(playArea) else {
            handleCompletedTouch()
            return
        }

        for cell in cells {

            if touchedNodes.contains(cell.sprite) {
                guard !cell.isPartOfCurrentTouch, !cell.isActivated else { continue }
                cell.isPartOfCurrentTouch = true
                let touchWasCorrect = cell.checkIfCorrect()
                if touchWasCorrect {
                    currentRun.currentTouchCellIndexes.append(cell.index)
                    currentRun.currentTouchScore += 10
                    setAnimatedEventsLabelText(for: .correct)
                } else {
                    for index in currentRun.currentTouchCellIndexes {
                        cells[index].resetCell(isCorrect: cells[index].isCorrect)
                    }
                    currentRun.currentTouchCellIndexes.removeAll()
                    currentRun.currentTouchScore = 0
                    currentRun.gameTimer.secondsRemaining -= 5
                    setAnimatedEventsLabelText(for: .miss)
                }
                cell.isPartOfCurrentTouch = true
            }
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleCompletedTouch()
    }

    private func handleCompletedTouch() {
        guard currentRun.latestEvent != .finishedAnimating else { return }

        AudioManager.resetHitPitch()
        animateAwayAnimatedEventsLabel()

        let scoreToAdd = (currentRun.currentTouchScore * currentRun.currentTouchCellIndexes.count)

        if scoreToAdd > 0 {
            checkForCompletedRowsAndColumns()
            currentRun.totalScore += scoreToAdd
        }

        if scoreToAdd > 10 {
            HapticsManager.playScoreEvent()
            AudioManager.play(soundEffect: .score)
        }

        cells.forEach { $0.isPartOfCurrentTouch = false }
        currentRun.currentTouchCellIndexes.removeAll()
        currentRun.currentTouchScore = 0
        checkForPuzzleCompletion()

        currentRun.latestEvent = .finishedAnimating
    }

    private func checkForCompletedRowsAndColumns() {
        let rowCorrectCounts = currentRun.currentPuzzle.rowCorrectCounts
        let columnCorrectCounts = currentRun.currentPuzzle.columnCorrectCounts

        for index in 1...5 {
            let numberOfCellsFilledInRow = cells.filter { $0.row == index && $0.isActivated == true }.count
            let numberOfCellsFilledInColumn = cells.filter { $0.column == index && $0.isActivated == true }.count

            if rowCorrectCounts[index - 1] == numberOfCellsFilledInRow {
                rowLabels[index - 1].alpha = 0.3
            }

            if columnCorrectCounts[index - 1] == numberOfCellsFilledInColumn {
                columnLabels[index - 1].alpha = 0.3
            }
        }

    }

    private func resetRowLabels() {
        rowLabels.forEach { label in
            label.alpha = 1.0
        }
        columnLabels.forEach { label in
            label.alpha = 1.0
        }
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
            HapticsManager.playCompleteEvent()
            AudioManager.play(soundEffect: .complete)
            setAnimatedEventsLabelText(for: .completed)
            animateAwayAnimatedEventsLabel()
            currentRun.gameTimer.secondsRemaining += 10
            currentRun.currentPuzzle = Puzzle()
            setUpPuzzleLabels()
            resetRowLabels()
            resetNonogramCells()
        }
    }

    private func transitionToGameOverScreen() {
        AudioManager.stopBackgroundMusic()
        let transition = SKTransition.doorsCloseVertical(withDuration: 0.4)
        guard let gameOverScreenScene = GameOverScreenScene(fileNamed: SceneNames.gameOverScreenScene) else { return }
        gameOverScreenScene.scaleMode = .aspectFit
        gameOverScreenScene.finishedRun = currentRun
        scene?.view?.presentScene(gameOverScreenScene, transition: transition)
    }

    private func setAnimatedEventsLabelText(for event: EventToAnimate) {
        switch event {
        case .completed:
            animatedEventsLabel.text = currentRun.animatedEventsLabelCompletedText
        case .correct:
            animatedEventsLabel.text = currentRun.animatedEventsLabelCorrectText
        case .finishedAnimating:
            return
        case .miss:
            animatedEventsLabel.text = currentRun.animatedEventsLabelMissText
        }
        animatedEventsLabel.removeAllActions()
        animatedEventsLabel.position = CGPoint(x: 0, y: 150)
        animatedEventsLabel.setScale(1.0)
        animatedEventsLabel.alpha = 1.0
        currentRun.latestEvent = event
    }

    private func animateAwayAnimatedEventsLabel() {
        switch currentRun.latestEvent {
        case .completed:
            animatedEventsLabel.removeAllActions()
            animatedEventsLabel.position = CGPoint(x: 0, y: 150)
            animatedEventsLabel.setScale(1.0)
            animatedEventsLabel.alpha = 1.0

            let actionGroup = SKAction.group([
                SKAction.scale(by: 0.1, duration: 0.2),
                SKAction.move(to: timeLabel.position, duration: 0.2),
                SKAction.fadeOut(withDuration: 0.2)
            ])

            let actionSequence = SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                actionGroup
            ])

            animatedEventsLabel.run(actionSequence)
        case .correct:
            let actionGroup = SKAction.group([
                SKAction.scale(by: 0.1, duration: 0.2),
                SKAction.move(to: scoreLabel.position, duration: 0.2),
                SKAction.fadeOut(withDuration: 0.2)
            ])

            let actionSequence = SKAction.sequence([
                SKAction.wait(forDuration: 0.1),
                actionGroup
            ])

            animatedEventsLabel.run(actionSequence)
        case .finishedAnimating:
            return
        case .miss:
            let actionGroup = SKAction.group([
                SKAction.scale(by: 0.1, duration: 0.2),
                SKAction.move(to: timeLabel.position, duration: 0.2),
                SKAction.fadeOut(withDuration: 0.2)
            ])

            let actionSequence = SKAction.sequence([
                SKAction.wait(forDuration: 0.1),
                actionGroup
            ])

            animatedEventsLabel.run(actionSequence)
        }
    }

}
