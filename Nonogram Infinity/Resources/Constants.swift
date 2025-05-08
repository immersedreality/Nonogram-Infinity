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

struct AdUnitIds {
    static let prod = "ca-app-pub-7985623540006861/8504729833"
    static let test = "ca-app-pub-3940256099942544/4411468910"
}

struct CreditsNodeNames {
    static let backLabel = "Back Label"
    static let bozoDesignLabsLabel = "Bozo Design Labs Label"
    static let eightBitEscapadesLabel = "8-Bit Escapades Label"
    static let kingGizzardLabel = "King Gizzard Label"
    static let littleRobotLabel = "Little Robot Label"
    static let meLabel = "Me Label"
}

struct GameNodeNames {
    static let animatedEventsLabel = "Animated Events Label"
    static let cell = "Cell-"
    static let columnLabel = "ColumnLabel-"
    static let playArea = "Play Area"
    static let rowLabel = "RowLabel-"
    static let scoreLabel = "Score Value Label"
    static let timeLabel = "Time Value Label"
}

struct GameOverScreenNodeNames {
    static let highScoreTitleLabel = "High Score Title Label"
    static let highScoreValueLabel = "High Score Value Label"
    static let quitLabel = "Quit Label"
    static let reopenLabel = "Reopen Label"
    static let scoreLabel = "Score Value Label"
}

struct HowToPlayNodeNames {
    static let gotItLabel = "Got It Label"
    static let practiceLabel = "Practice Label"
}

struct NotificationNames {
    static let newHighScore = "newHighScore"
}

struct SceneNames {
    static let creditsScene = "CreditsScene"
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

struct StoryboardNames {
    static let launchScreen = "LaunchScreen"
}

struct TitleScreenNodeNames {
    static let creditsLabel = "Credits Label"
    static let helpLabel = "Help Label"
    static let highScoreTitleLabel = "High Score Title Label"
    static let highScoreValueLabel = "High Score Value Label"
    static let leaderboardsLabel = "Leaderboards Label"
    static let openLabel = "Open Label"
    static let settingsLabel = "Settings Label"
}

struct UserDefaultKeys {
    static let allTimeHighScore = "all-time-high-score"
    static let musicDisabled = "music-disabled"
    static let playerHandedness = "player-handedness"
    static let userHasClaimedTheyGotIt = "user-has-claimed-they-got-it"
}
