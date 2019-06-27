//
//  SpeedProportionalViewController.swift
//  2048L
//
//  Created by John Kim and Teddy Liang on 3/7/19.
//  Copyright © 2019 squad. All rights reserved.
//

import Foundation
import UIKit

var speedFastestTime = UserDefaults.standard.integer(forKey: "speedFastestTime")
var speedFinished = false

class SpeedProportionalViewController: UIViewController {
    @IBOutlet weak var highscoreLabel: UILabel!
    
    override func viewDidLoad()
    {
        highscoreLabel.text = "Fastest Time: " + String(UserDefaults.standard.integer(forKey: "speedFastestTime")) + "s"
        super.viewDidLoad()
    }
    
    @IBAction func startgame(_ sender: Any)
    {
        SoundEffectPlayer.shared.playSoundEffect(soundEffect: "click")
        let game = SpeedGameViewController(dimension: 4, threshold: 2048)
        self.present(game, animated: true, completion: endGame)
    }
    
    func endGame() {
        checkingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkSpeed), userInfo: nil, repeats: true)
    }
    
    @objc func checkSpeed()
    {
        if speedFinished == true {
            self.dismiss(animated: true, completion: nil)
            viewDidLoad()
            checkingTimer!.invalidate()
            speedFinished = false
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
