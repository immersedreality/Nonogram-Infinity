//
//  LeaderboardManager.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/21/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import Foundation
import GameKit

final class LeaderboardManager {

    private static var containingViewController = UIApplication.shared.delegate?.window??.rootViewController as? NonogramInfinityViewController

    static var isConnectedToGameCenter = false
    static var defaultLeaderboardIdentifier: String?

    class func authenticateLocalPlayer() {

        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(gameCenterViewController, error) -> Void in
            if localPlayer.isAuthenticated {
                // MARK: Connect to GC and fetch the leadboard identifier
                isConnectedToGameCenter = true
                localPlayer.loadDefaultLeaderboardIdentifier { identifier, _ in
                    if let identifier = identifier {
                        self.defaultLeaderboardIdentifier = identifier
                    }
                }
            } else if let gameCenterViewController = gameCenterViewController {
                // MARK: Apparently this checkes to see if the user can be logged in?
                containingViewController?.present(gameCenterViewController, animated: true, completion: nil)
            } else {
                // MARK: Fail silently because I don't care
                isConnectedToGameCenter = false
            }
        }

    }

    class func submit(score: Int) {
        if let leaderboardIdentifier = defaultLeaderboardIdentifier, isConnectedToGameCenter {
            GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardIdentifier], completionHandler: { _ in })
        }
    }

    class func viewLeaderboard() {
        if let containingViewController = self.containingViewController, isConnectedToGameCenter {
            let gameCenterViewController = GKGameCenterViewController(state: .leaderboards)
            gameCenterViewController.gameCenterDelegate = containingViewController
            containingViewController.present(gameCenterViewController, animated: true, completion: nil)
        }
    }

}
