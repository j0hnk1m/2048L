//
//  NormalViewController.swift
//  2048L
//
//  Created by John Kim and Teddy Liang on 4/21/19.
//  Copyright © 2019 squad. All rights reserved.
//

import Foundation
import UIKit

var normalHighscore = UserDefaults.standard.integer(forKey: "normalHighscore")
var normalFinished = false

class NormalViewController: UIViewController {
    @IBOutlet var highscoreLabel: UILabel!
    
    override func viewDidLoad() {
        highscoreLabel.text = "Highscore: " + String(UserDefaults.standard.integer(forKey: "normalHighscore"))
        super.viewDidLoad()
    }
    
    @IBAction func startGame(_ sender : UIButton) {
        SoundEffectPlayer.shared.playSoundEffect(soundEffect: "click")
        let game = NormalGameViewController(dimension: 4, threshold: 2048)
        self.present(game, animated: true, completion: nil)
    }
    
    func endGame() {
        checkingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkTimed), userInfo: nil, repeats: true)
    }
    
    @objc func checkTimed()
    {
        if normalFinished == true {
            self.dismiss(animated: true, completion: nil)
            viewDidLoad()
            checkingTimer!.invalidate()
            normalFinished = false
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
