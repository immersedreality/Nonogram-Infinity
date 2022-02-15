//
//  AudioManager.swift
//  Nonogram Infinity
//
//  Created by Jeffrey Eugene Hoch on 2/14/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import AVKit

class AudioManager {

    static var bgmPlayer = AVAudioPlayer()
    static var completePlayer = AVAudioPlayer()
    static var missPlayer = AVAudioPlayer()
    static var scorePlayer = AVAudioPlayer()

    static var hitEngine = AVAudioEngine()
    static var hitPitchControl = AVAudioUnitTimePitch()
    static var hitPlayer = AVAudioPlayerNode()

    class func configurePlayers() {
        guard let bgmURL = Bundle.main.url(forResource: "BGM", withExtension: "wav") else { return }
        guard let musicPlayer = try? AVAudioPlayer(contentsOf: bgmURL) else { return }
        musicPlayer.volume = 0.5
        self.bgmPlayer = musicPlayer

        SoundEffect.allCases.forEach { soundEffect in
            guard let effectURL = Bundle.main.url(forResource: soundEffect.fileName, withExtension: soundEffect.fileType) else { return }

            switch soundEffect {
            case .complete:
                guard let completePlayer = try? AVAudioPlayer(contentsOf: effectURL) else { return }
                completePlayer.volume = soundEffect.volume
                self.completePlayer = completePlayer
            case .hit:
                hitPlayer.volume = soundEffect.volume
                configureHitEngine()
            case .miss:
                guard let missPlayer = try? AVAudioPlayer(contentsOf: effectURL) else { return }
                missPlayer.volume = soundEffect.volume
                self.missPlayer = missPlayer
            case .score:
                guard let scorePlayer = try? AVAudioPlayer(contentsOf: effectURL) else { return }
                scorePlayer.volume = soundEffect.volume
                self.scorePlayer = scorePlayer
            }
        }

    }

    private class func configureHitEngine() {
        hitEngine.attach(hitPlayer)
        hitEngine.attach(hitPitchControl)
        hitEngine.connect(hitPlayer, to: hitPitchControl, format: nil)
        hitEngine.connect(hitPitchControl, to: hitEngine.mainMixerNode, format: nil)
        hitEngine.mainMixerNode.outputVolume = 1.0
        try? hitEngine.start()
    }

    class func startBackgroundMusic() {
        bgmPlayer.currentTime = 0
        bgmPlayer.numberOfLoops = -1
        bgmPlayer.play()
    }

    class func stopBackgroundMusic() {
        bgmPlayer.stop()
    }

    class func play(soundEffect: SoundEffect) {
        switch soundEffect {
        case .complete:
            completePlayer.play()
        case .hit:
            guard let effectURL = Bundle.main.url(forResource: soundEffect.fileName, withExtension: soundEffect.fileType) else { return }
            guard let hitFile = try? AVAudioFile(forReading: effectURL) else { return }
            hitPlayer.scheduleFile(hitFile, at: nil)
            hitPlayer.play()
            hitPitchControl.pitch += 100
        case .miss:
            missPlayer.currentTime = 0
            missPlayer.play()
        case .score:
            AudioManager.resetHitEngine()
            scorePlayer.currentTime = 0
            scorePlayer.play()
        }
    }

    class func resetHitEngine() {
        hitEngine.reset()
        configureHitEngine()
    }

    class func resetHitPitch() {
        hitPitchControl.pitch = 0.0
    }

}

enum SoundEffect {
    case complete, hit, miss, score

    static let allCases = [SoundEffect.complete, SoundEffect.hit, SoundEffect.miss, SoundEffect.score]

    var fileName: String {
        switch self {
        case .complete:
            return "Complete"
        case .hit:
            return "Hit"
        case .miss:
            return "Miss"
        case .score:
            return "Score"
        }
    }

    var fileType: String {
        return "wav"
    }

    var volume: Float {
        switch self {
        case .complete:
            return 0.1
        case .hit:
            return 0.1
        case .miss:
            return 0.1
        case .score:
            return 0.12
        }
    }

}
