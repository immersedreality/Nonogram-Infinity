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

    static var isConnectedToGameCenter = false
    static var defaultLeaderboardIdentifier: String?

    private static var containingViewController: NonogramInfinityViewController? {
        let windowScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let activeScene = windowScenes.filter { $0.activationState == .foregroundActive }
        return activeScene.first?.keyWindow?.rootViewController as? NonogramInfinityViewController
    }
    
    class func authenticateLocalPlayer() {

        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(gameCenterViewController, error) -> Void in
            if localPlayer.isAuthenticated {
                // MARK: Connect to GC and fetch the leadboard identifier
                isConnectedToGameCenter = true
                localPlayer.loadDefaultLeaderboardIdentifier { identifier, _ in
                    if let identifier = identifier {
                        self.defaultLeaderboardIdentifier = identifier
                        self.fetchGameCenterHighScore()
                    }
                }
            } else if let gameCenterViewController = gameCenterViewController {
                // MARK: Apparently this checks to see if the user can be logged in?
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

    class func fetchGameCenterHighScore() {
        if let leaderboardIdentifier = defaultLeaderboardIdentifier, isConnectedToGameCenter {
            Task {
                guard let leaderboards = try? await GKLeaderboard.loadLeaderboards(IDs: [leaderboardIdentifier]) else { return }
                guard let localPlayerEntry = try? await leaderboards.first?.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime).0 else { return }
                if localPlayerEntry.score > PersistedSettings.allTimeHighScore {
                    PersistedSettings.allTimeHighScore = localPlayerEntry.score
                }
            }
        }
    }

    class func viewLeaderboards() {
        if let containingViewController = self.containingViewController, isConnectedToGameCenter {
            let gameCenterViewController = GKGameCenterViewController(state: .leaderboards)
            gameCenterViewController.gameCenterDelegate = containingViewController
            containingViewController.present(gameCenterViewController, animated: true, completion: nil)
        }
    }

}
