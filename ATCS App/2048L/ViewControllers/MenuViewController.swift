//
//  MenuViewController.swift
//  2048L
//
//  Created by John Kim and Teddy Liang on 2/26/19.
//  Copyright © 2019 squad. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, SettingsViewControllerDelegate
{
    func SettingsViewControllerGoHome(_ controller:SettingsViewController)
    {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        MusicPlayer.shared.playBackgroundMusic(backgroundMusicFileName: "epicsaxguy")
        if UserDefaults.standard.bool(forKey: "musicStatus") == true
        {
            MusicPlayer.shared.unmuteBackgroundMusic()
        }
        else
        {
            MusicPlayer.shared.muteBackgroundMusic()
        }
    }
}

