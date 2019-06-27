//
//  SpeedGameViewController.swift
//  2048L
//
//  Created by John Kim and Teddy Liang on 3/15/19.
//  Copyright © 2019 squad. All rights reserved.
//

import UIKit
import CoreMotion

////////////////////////////////////////////////////////////////////////////////////////////
//
// A view controller for the speed shaking game mode
//
////////////////////////////////////////////////////////////////////////////////////////////

class SpeedGameViewController : UIViewController, GameModelProtocol {
    
    var motionManager = CMMotionManager()
    // How many tiles in both directions the gameboard contains
    var dimension: Int
    // The value of the winning tile
    var threshold: Int
    
    var board: GameboardView?
    var model: GameModel?
    
    var scoreView: ScoreViewProtocol?
    
    // Width of the gameboard
    let boardWidth: CGFloat = 230.0
    // How much padding to place between the tiles
    let thinPadding: CGFloat = 3.0
    let thickPadding: CGFloat = 6.0
    
    // Amount of space to place between the different component views (gameboard, etc)
    let viewPadding: CGFloat = 10.0
    
    // Amount that the vertical alignment of the component views should differ from if they were centered
    let verticalViewOffset: CGFloat = 0.0
    
    init(dimension d: Int, threshold t: Int) {
        dimension = d > 2 ? d : 2
        threshold = t > 8 ? t : 8
        super.init(nibName: nil, bundle: nil)
        model = GameModel(dimension: dimension, threshold: threshold, delegate: self)
        view.backgroundColor = UIColor.white
//        setupSwipeControls()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // View Controller
    var stopwatch = Timer()
    var stopwatchIsOn = false
    var counter = 0
    var stopwatchLabel: UILabel!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        setupGame()
        
        stopwatchLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 325, height: 50))
        stopwatchLabel.center = CGPoint(x: 190, y: 140)
        stopwatchLabel.font = stopwatchLabel.font.withSize(40)
        stopwatchLabel.textAlignment = .center
        setupTimer()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        motionManager.accelerometerUpdateInterval = 0.4
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {(data, error) in
            if let phonedata = data
            {
                let absoluteacceleration = abs(phonedata.acceleration.x) + abs(phonedata.acceleration.y) + abs(phonedata.acceleration.z)
                let direction1 = Int.random(in:1..<5)
                let direction2 = Int.random(in:1..<5)
                let direction3 = Int.random(in:1..<5)
                if absoluteacceleration >= 6
                {
                    print("accelerration >= 6")
                    self.shakeCommand(direction: direction1)
                    self.shakeCommand(direction: direction2)
                    self.shakeCommand(direction: direction3)

                }
                else if absoluteacceleration >= 4
                {
                    print("acceleration >= 4")
                    self.shakeCommand(direction: direction1)
                    self.shakeCommand(direction: direction2)
                }
                else if absoluteacceleration >= 2
                {
                    print("acceleration >= 2")
                    self.shakeCommand(direction: direction1)
                }
            }
        }
    }
    
    func setupTimer() {
        stopwatch = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        stopwatchIsOn = true
        
        stopwatchLabel.text = "START SHAKING!"
        self.view.addSubview(stopwatchLabel)
    }
    
    @objc func updateTime() {
        counter += 1
        SoundEffectPlayer.shared.playSoundEffect(soundEffect: "tick")
        stopwatchLabel.text = "\(timeFormatted(counter))"
    }
    
    func setSpeedFinishedToTrue(alert: UIAlertAction!) {
        speedFinished = true
    }
    
    func reset(alert: UIAlertAction!) {
        assert(board != nil && model != nil)
        let b = board!
        let m = model!
        b.reset()
        m.reset()
        m.insertTileAtRandomLocation(withValue: 2)
        m.insertTileAtRandomLocation(withValue: 2)
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func setupGame() {
        let vcHeight = view.bounds.size.height
        let vcWidth = view.bounds.size.width
        
        // This nested function provides the x-position for a component view
        func xPositionToCenterView(_ v: UIView) -> CGFloat {
            let viewWidth = v.bounds.size.width
            let tentativeX = 0.5*(vcWidth - viewWidth)
            return tentativeX >= 0 ? tentativeX : 0
        }
        // This nested function provides the y-position for a component view
        func yPositionForViewAtPosition(_ order: Int, views: [UIView]) -> CGFloat {
            assert(views.count > 0)
            assert(order >= 0 && order < views.count)
            //      let viewHeight = views[order].bounds.size.height
            let totalHeight = CGFloat(views.count - 1)*viewPadding + views.map({ $0.bounds.size.height }).reduce(verticalViewOffset, { $0 + $1 })
            let viewsTop = 0.5*(vcHeight - totalHeight) >= 0 ? 0.5*(vcHeight - totalHeight) : 0
            
            // Not sure how to slice an array yet
            var acc: CGFloat = 0
            for i in 0..<order {
                acc += viewPadding + views[i].bounds.size.height
            }
            return viewsTop + acc
        }
        
        // Create the score view
        let scoreView = ScoreView(backgroundColor: UIColor.black,
                                  textColor: UIColor.white,
                                  font: UIFont(name: "HelveticaNeue-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0),
                                  radius: 6)
        scoreView.score = 0
        
        // Create the gameboard
        let padding: CGFloat = dimension > 5 ? thinPadding : thickPadding
        let v1 = boardWidth - padding*(CGFloat(dimension + 1))
        let width: CGFloat = CGFloat(floorf(CFloat(v1)))/CGFloat(dimension)
        let gameboard = GameboardView(dimension: dimension,
                                      tileWidth: width,
                                      tilePadding: padding,
                                      cornerRadius: 6,
                                      backgroundColor: UIColor.black,
                                      foregroundColor: UIColor.darkGray)
        
        // Set up the frames
        let views = [scoreView, gameboard]
        
        var f = scoreView.frame
        f.origin.x = xPositionToCenterView(scoreView)
        f.origin.y = yPositionForViewAtPosition(0, views: views)
        scoreView.frame = f
        
        f = gameboard.frame
        f.origin.x = xPositionToCenterView(gameboard)
        f.origin.y = yPositionForViewAtPosition(1, views: views)
        gameboard.frame = f
        
        
        // Add to game state
        view.addSubview(gameboard)
        board = gameboard
//        view.addSubview(scoreView)
//        self.scoreView = scoreView
        
        assert(model != nil)
        let m = model!
        m.insertTileAtRandomLocation(withValue: 2)
        m.insertTileAtRandomLocation(withValue: 2)
    }
    
    // Misc
    func followUp() {
        assert(model != nil)
        let m = model!
        
        // Now, insert more tiles
        let randomVal = Int(arc4random_uniform(10))
        m.insertTileAtRandomLocation(withValue: randomVal == 1 ? 4 : 2)
        
        // At this point, the user may lose
        if m.userHasLost() {
            stopwatch.invalidate()
            stopwatchIsOn = false
            
            if counter < UserDefaults.standard.integer(forKey: "speedFastestTime") || UserDefaults.standard.integer(forKey: "speedFastestTime") == 0 {
                UserDefaults.standard.set(counter, forKey: "speedFastestTime")
            }
            
            SoundEffectPlayer.shared.playSoundEffect(soundEffect: "tada")
            let alert = UIAlertController(title: "Finished!", message: "Play again?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: setSpeedFinishedToTrue))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: reset))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Commands
    func shakeCommand(direction: Int)
    {
        assert(self.model != nil)
        let m = self.model!
        if direction == 1
        {
            m.queueMove(direction: MoveDirection.up,
                    onCompletion: { (changed: Bool) -> () in
                        if changed {
                            self.followUp()
                        }
        
            })
        }
        if direction == 2
        {
            m.queueMove(direction: MoveDirection.down,
                        onCompletion: { (changed: Bool) -> () in
                            if changed {
                                self.followUp()
                            }
                            
            })
        }
        if direction == 3
        {
            m.queueMove(direction: MoveDirection.left,
                        onCompletion: { (changed: Bool) -> () in
                            if changed {
                                self.followUp()
                            }
                            
            })
        }
        if direction == 4
        {
            m.queueMove(direction: MoveDirection.right,
                        onCompletion: { (changed: Bool) -> () in
                            if changed {
                                self.followUp()
                            }
                            
            })
        }
    }
    
    func scoreChanged(to score: Int) {
        
    }
    
    func moveOneTile(from: (Int, Int), to: (Int, Int), value: Int) {
        assert(board != nil)
        let b = board!
        b.moveOneTile(from: from, to: to, value: value)
    }
    
    func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int) {
        assert(board != nil)
        let b = board!
        b.moveTwoTiles(from: from, to: to, value: value)
    }
    
    func insertTile(at location: (Int, Int), withValue value: Int) {
        assert(board != nil)
        let b = board!
        b.insertTile(at: location, value: value)
    }
}


