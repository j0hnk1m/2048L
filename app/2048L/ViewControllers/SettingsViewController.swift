//
//  SettingsViewController.swift
//  2048L
//
//  Created by John Kim and Teddy Liang on 3/7/19.
//  Copyright © 2019 squad. All rights reserved.
//

import Foundation
import UIKit

var musicStatus = UserDefaults.standard.bool(forKey: "musicStatus")

protocol SettingsViewControllerDelegate: class
{
    func SettingsViewControllerGoHome(_ controller:SettingsViewController)
}

class SettingsViewController: UIViewController
{
    weak var delegate: SettingsViewControllerDelegate?
    @IBOutlet weak var musicSwitch: UISwitch!
    
    @IBAction func saveSwitchState(_ sender: UISwitch) {
        UserDefaults.standard.set(musicSwitch.isOn, forKey: "musicStatus")
        
        if UserDefaults.standard.bool(forKey: "musicStatus") == true
        {
            MusicPlayer.shared.unmuteBackgroundMusic()
        }
        else
        {
            MusicPlayer.shared.muteBackgroundMusic()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        musicSwitch.isOn =  UserDefaults.standard.bool(forKey: "musicStatus")
    }
    
    @IBAction func helpAndSupport()
    {
        SoundEffectPlayer.shared.playSoundEffect(soundEffect: "click")
        let alert = UIAlertController(title: "Help and Support", message: "Son, don't rely on other people, be independent son!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK Mom", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    
    @IBAction func credits()
    {
        SoundEffectPlayer.shared.playSoundEffect(soundEffect: "click")
        let alert = UIAlertController(title: "Credits", message: "Made by John Kim and Teddy Liang", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cool!", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
}

