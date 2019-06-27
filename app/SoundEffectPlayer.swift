//
//  SoundEffectPlayer.swift
//  2048L
//
//  Created by John Kim and Teddy Liang on 4/18/19.
//  Copyright © 2019 squad. All rights reserved.
//

import Foundation
import AVFoundation

class SoundEffectPlayer {
    static let shared = SoundEffectPlayer()
    var soundEffectPlayer: AVAudioPlayer?
    
    func playSoundEffect(soundEffect: String) {
        soundEffectPlayer?.volume = 0
        if let bundle = Bundle.main.path(forResource: soundEffect, ofType: "mp3") {
            let soundEffectUrl = NSURL(fileURLWithPath: bundle)
            do {
                soundEffectPlayer = try AVAudioPlayer(contentsOf:soundEffectUrl as URL)
                guard let audioPlayer = soundEffectPlayer else { return }
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func unmuteSoundEffect() {
        print("unmuted")
        soundEffectPlayer?.volume = 1.0
    }
    
    func muteSoundEffect() {
        print("muted")
        soundEffectPlayer?.volume = 0.0
    }
}
