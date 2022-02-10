//
//  Constants.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 7/6/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation

struct ActionKeys {
    static let timer = "Timer"
}

struct GameNodeNames {
    static let cell = "Cell-"
    static let columnLabel = "ColumnLabel-"
    static let playArea = "Play Area"
    static let rowLabel = "RowLabel-"
    static let scoreLabel = "Score Value Label"
    static let timeLabel = "Time Value Label"
}

struct GameOverScreenNodeNames {
    static let quitLabel = "Quit Label"
    static let reopenLabel = "Reopen Label"
    static let scoreLabel = "Score Value Label"
}

struct HowToPlayNodeNames {
    static let gotItLabel = "Got It Label"
}

struct SceneNames {
    static let gameOverScreenScene = "GameOverScreenScene"
    static let gameSceneLeftHanded = "GameScene-LeftHanded"
    static let gameSceneRightHanded = "GameScene-RightHanded"
    static let howToPlayScene = "HowToPlayScene"
    static let settingsScene = "SettingsScene"
    static let titleScreenScene = "TitleScreenScene"
}

struct SettingsNodeNames {
    static let backLabel = "Back Label"
    static let handTitleLabel = "Hand Title Label"
    static let handValueLabel = "Hand Value Label"
    static let musicTitleLabel = "Music Title Label"
    static let musicValueLabel = "Music Value Label"
}

struct TitleScreenNodeNames {
    static let helpLabel = "Help Label"
    static let highScoreTitleLabel = "High Score Title Label"
    static let highScoreValueLabel = "High Score Value Label"
    static let openLabel = "Open Label"
    static let settingsLabel = "Settings Label"
}

struct UserDefaultKeys {
    static let allTimeHighScore = "all-time-high-score"
    static let musicDisabled = "music-disabled"
    static let playerHandedness = "player-handedness"
    static let userHasClaimedTheyGotIt = "user-has-claimed-they-got-it"
}
