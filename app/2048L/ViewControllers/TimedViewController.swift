//
//  TimedViewController.swift
//  2048L
//
//  Created by John Kim and Teddy Liang on 3/7/19.
//  Copyright © 2019 squad. All rights reserved.
//

import Foundation
import UIKit

var timedHighscore = UserDefaults.standard.integer(forKey: "timedHighscore")
var timedFinished = false

class TimedViewController: UIViewController {
    @IBOutlet var highscoreLabel: UILabel!
    
    override func viewDidLoad() {
        highscoreLabel.text = "Highscore: " + String(UserDefaults.standard.integer(forKey: "timedHighscore"))
        super.viewDidLoad()
    }
    
    @IBAction func startGame(_ sender : UIButton) {
        SoundEffectPlayer.shared.playSoundEffect(soundEffect: "click")
        let game = TimedGameViewController(dimension: 4, threshold: 2048)
        self.present(game, animated: true, completion: endGame)
    }
    
    func endGame() {
        checkingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkTimed), userInfo: nil, repeats: true)
    }
    
    @objc func checkTimed()
    {
        if timedFinished == true {
            self.dismiss(animated: true, completion: nil)
            viewDidLoad()
            checkingTimer!.invalidate()
            timedFinished = false
        }
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
