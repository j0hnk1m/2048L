//
//  LoseFirstViewController.swift
//  2048L
//
//  Created by John Kim and Teddy Liang on 2/26/19.
//  Copyright © 2019 squad. All rights reserved.
//

import UIKit

var loseLowestScore = UserDefaults.standard.integer(forKey: "loseLowestScore")
var loseFinished = false
var checkingTimer: Timer?

class LoseFirstViewController: UIViewController
{
    @IBOutlet weak var highscoreLabel: UILabel!
    
    override func viewDidLoad()
    {
        highscoreLabel.text = "Lowest Score: " + String(UserDefaults.standard.integer(forKey: "loseLowestScore"))
        super.viewDidLoad()
    }
    @IBAction func startGame(_ sender : UIButton)
    {
        SoundEffectPlayer.shared.playSoundEffect(soundEffect: "click")
        let game = LoseFirstGameViewController(dimension: 4, threshold: 2048)
        self.present(game, animated: true, completion: endGame)
    }

    func endGame() {
        checkingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkTimed), userInfo: nil, repeats: true)
    }
    
    @objc func checkTimed()
    {
        if loseFinished == true {
            self.dismiss(animated: true, completion: nil)
            viewDidLoad()
            checkingTimer!.invalidate()
            loseFinished = false
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

