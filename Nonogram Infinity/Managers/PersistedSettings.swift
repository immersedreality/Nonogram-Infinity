//
//  PersistedSettings.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/9/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import Foundation

final class PersistedSettings {

    static var userHasClaimedTheyGotIt: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.userHasClaimedTheyGotIt)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userHasClaimedTheyGotIt)
        }
    }

    static var allTimeHighScore: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultKeys.allTimeHighScore)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.allTimeHighScore)
            NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.newHighScore), object: nil)
        }
    }

    static var musicDisabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.musicDisabled)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.musicDisabled)
        }
    }

    static var playerHandedness: PlayerHandedness {
        get {
            PlayerHandedness.init(rawValue: UserDefaults.standard.string(forKey: UserDefaultKeys.playerHandedness) ?? "left") ?? .left
        }
        set {
            switch newValue {
            case .left:
                UserDefaults.standard.set("left", forKey: UserDefaultKeys.playerHandedness)
            case .right:
                UserDefaults.standard.set("right", forKey: UserDefaultKeys.playerHandedness)
            }
        }
    }

}

enum PlayerHandedness: String {
    case left, right
}
