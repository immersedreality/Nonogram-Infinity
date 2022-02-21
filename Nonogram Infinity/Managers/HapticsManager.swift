//
//  HapticsManager.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/14/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import Foundation
import CoreHaptics
import UIKit

final class HapticsManager {

    static let impactGenerator = UIImpactFeedbackGenerator()
    static let hapticEngine = try? CHHapticEngine()

    static let scoreEvent = CHHapticEvent(
        eventType: .hapticContinuous,
        parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)
        ],
        relativeTime: 0,
        duration: 0.2
    )

    static let missEvent = CHHapticEvent(
        eventType: .hapticContinuous,
        parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
        ],
        relativeTime: 0,
        duration: 0.3
    )

    static let completeEvent = CHHapticEvent(
        eventType: .hapticContinuous,
        parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        ],
        relativeTime: 0,
        duration: 0.5
    )

    class func playTapEvent() {
        impactGenerator.impactOccurred(intensity: 1.0)
    }

    class func playScoreEvent() {
        try? hapticEngine?.start()
        let player = try? hapticEngine?.makePlayer(with: CHHapticPattern(events: [scoreEvent], parameters: []))
        try? player?.start(atTime: CHHapticTimeImmediate)
        hapticEngine?.notifyWhenPlayersFinished { _ in
            return .stopEngine
        }
    }

    class func playMissEvent() {
        try? hapticEngine?.start()
        let player = try? hapticEngine?.makePlayer(with: CHHapticPattern(events: [missEvent], parameters: []))
        try? player?.start(atTime: CHHapticTimeImmediate)
        hapticEngine?.notifyWhenPlayersFinished { _ in
            return .stopEngine
        }
    }

    class func playCompleteEvent() {
        try? hapticEngine?.start()
        let player = try? hapticEngine?.makePlayer(with: CHHapticPattern(events: [completeEvent], parameters: []))
        try? player?.start(atTime: CHHapticTimeImmediate)
        hapticEngine?.notifyWhenPlayersFinished { _ in
            return .stopEngine
        }
    }

}
