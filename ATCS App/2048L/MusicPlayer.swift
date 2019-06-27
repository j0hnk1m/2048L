//
//  MusicPlayer.swift
//  2048L
//
//  Created by John Kim and Teddy Liang on 4/18/19.
//  Copyright © 2019 squad. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer {
    static let shared = MusicPlayer()
    var musicPlayer: AVAudioPlayer?
    
    func playBackgroundMusic(backgroundMusicFileName: String) {
        musicPlayer?.volume = 0.5
        if let bundle = Bundle.main.path(forResource: backgroundMusicFileName, ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                musicPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = musicPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func unmuteBackgroundMusic() {
        musicPlayer?.play()
    }
    
    func muteBackgroundMusic() {
        musicPlayer?.pause()
    }
}
