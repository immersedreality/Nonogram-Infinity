//
//  AdManager.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 5/7/25.
//  Copyright © 2025 Bozo Design Labs. All rights reserved.
//

import GoogleMobileAds

final class AdManager: NSObject, FullScreenContentDelegate {

    static let shared = AdManager()

    var interstitialAd: InterstitialAd?

    var awaitingAdToShow: Bool = false

    private var containingViewController: NonogramInfinityViewController? {
        let windowScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let activeScene = windowScenes.filter { $0.activationState == .foregroundActive }
        return activeScene.first?.keyWindow?.rootViewController as? NonogramInfinityViewController
    }
    
    func loadAd() async {
      do {
        self.interstitialAd = try await InterstitialAd.load(
          with: AdUnitIds.prod, request: Request())
        interstitialAd?.fullScreenContentDelegate = self
      } catch {
        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
      }
    }

    func showAd() {
        awaitingAdToShow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.interstitialAd?.present(from: self.containingViewController)
        }
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        awaitingAdToShow = false
        interstitialAd = nil
        Task {
            await loadAd()
        }
    }

}
