//
//  ViewController.swift
//  coreMotionStarter
//
//  Created by Rod Woodman on 6/10/15.
//  Copyright (c) 2015 Rod Woodman. All rights reserved.
//

import UIKit
import CoreMotion
class ViewController: UIViewController {
    
    @IBOutlet weak var objectiveLabel: UILabel!

    @IBOutlet weak var rollLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var yawLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var rollDiffLabel: UILabel!
    @IBOutlet weak var pitchDiffLabel: UILabel!
    @IBOutlet weak var yawDiffLabel: UILabel!
    @IBOutlet weak var startButtonLabel: UIButton!
    @IBOutlet weak var resetButtonLabel: UIButton!
    @IBOutlet var mainView: UIView!
    
    var targetRoll = 0.0
    var targetPitch = 0.0
    var targetYaw = 0.0
    
    let motionManager: CMMotionManager = CMMotionManager()
    
    // TIMER? 
    
    // We are generating two solutions each for roll, yaw, and pitch. Should we keep it this way for now?
    
    
    
    // ------ current: ------
    
    // git it!
    
    // add pictures? more colors?
    
    
    // nice to haves: //
    
    // add difficulty scale?
    
    // Create an option to do just two dimensions? (easy mode)
    
    // FREEZE ORIENTATION
    
    // DARK BACKGROUND?
    
    

    
    // We could put Diff and R/Y/P displays on separate labels to make them easier to read
    
//            if self.resetButtonLabel.hidden == false {
//                self.resetButtonLabel.text = "Reset"
//            }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        
        self.rollLabel.hidden = true
        self.yawLabel.hidden = true
        self.pitchLabel.hidden = true
        self.rollDiffLabel.hidden = true
        self.pitchDiffLabel.hidden = true
        self.yawDiffLabel.hidden = true
        
        self.resultLabel.hidden = true
        self.startButtonLabel.hidden = false
        sender.setTitle("Reset", forState: UIControlState.Normal)
        targetRoll = Double(arc4random_uniform(UInt32(360)))-180.0
        targetYaw = Double(arc4random_uniform(UInt32(360)))-180.0
        targetPitch = Double(arc4random_uniform(UInt32(180)))-90.0
        if motionManager.deviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    @IBAction func startButtonPressed(sender: UIButton) {
        
        self.rollLabel.hidden = false
        self.yawLabel.hidden = false
        self.pitchLabel.hidden = false
        self.rollDiffLabel.hidden = false
        self.pitchDiffLabel.hidden = false
        self.yawDiffLabel.hidden = false
        
        self.resetButtonLabel.setTitle("Stop", forState: UIControlState.Normal)
        self.resultLabel.hidden = true
        sender.hidden = true
        println("Game begins!")
        var winMargin = 3.0
        var closeMargin = 15.0
        targetRoll = Double(arc4random_uniform(UInt32(360)))-180.0
        targetYaw = Double(arc4random_uniform(UInt32(360)))-180.0
        targetPitch = Double(arc4random_uniform(UInt32(180)))-90.0
        
        if motionManager.deviceMotionAvailable {
            
            var mainQueue = NSOperationQueue.mainQueue()
            
            motionManager.startDeviceMotionUpdatesToQueue(mainQueue) {
                (motion, error) in
                
                var roll = motion.attitude.roll
                var rollDegrees = roll * 180 / M_PI
//                var rollDiff = self.targetRoll - abs(rollDegrees)
                
                // -------------------------------- Roll Diff Test ----------------------------- //
                var rollDiff: Double
                if self.targetRoll < 0 {
                    println("If: 360 - Target")
                    // look at the console to see the current target values
                    println("Targets: Roll = \(self.targetRoll), Yaw = \(self.targetYaw), Pitch = \(self.targetPitch)")
                    var diffTest1 = 360 + self.targetRoll - abs(rollDegrees)
                    var diffTest2 = abs(self.targetRoll) - abs(rollDegrees)
                    if diffTest1 < diffTest2 {
                        println("rolldiff = test1")
                        rollDiff = diffTest1
                    } else {
                        rollDiff = diffTest2
                        println("rolldiff = test2")
                    }
                } else {
                    println("Target - abs")
                    // look at the console to see the current target values
                    println("Targets: Roll = \(self.targetRoll), Yaw = \(self.targetYaw), Pitch = \(self.targetPitch)")
                    rollDiff = self.targetRoll - abs(rollDegrees)
                }
                // ------------------------------------ end test --------------------------------------- //
                
                if abs(rollDiff) <= winMargin {
                    self.rollLabel.textColor = UIColor.greenColor()
                }
                else if abs(rollDiff) <= closeMargin {
                    self.rollLabel.textColor = UIColor.yellowColor()
                }
                else {
                    self.rollLabel.textColor = UIColor.whiteColor()
                }
                
                var yaw = motion.attitude.yaw
                var yawDegrees = yaw * 180 / M_PI
//                var yawDiff = self.targetYaw - abs(yawDegrees)
                
                // -------------------------------- Yaw Diff Test ----------------------------- //
                var yawDiff: Double
                if self.targetYaw < 0 {
                    println("If: 360 - Target")
                    // look at the console to see the current target values
                    println("Targets: Roll = \(self.targetRoll), Yaw = \(self.targetYaw), Pitch = \(self.targetPitch)")
                    var diffTest1 = 360 + self.targetYaw - abs(yawDegrees)
                    var diffTest2 = abs(self.targetYaw) - abs(yawDegrees)
                    if diffTest1 < diffTest2 {
                        println("yawdiff = test1")
                        yawDiff = diffTest1
                    } else {
                        yawDiff = diffTest2
                        println("yawdiff = test2")
                    }
                } else {
                    println("Target - abs")
                    // look at the console to see the current target values
                    println("Targets: Roll = \(self.targetRoll), Yaw = \(self.targetYaw), Pitch = \(self.targetPitch)")
                    yawDiff = self.targetYaw - abs(yawDegrees)
                }
                // ---------------------------------- end test ----------------------------------------- //
                
                if abs(yawDiff) <= winMargin {
                    self.yawLabel.textColor = UIColor.greenColor()
                }
                else if abs(yawDiff) <= closeMargin {
                    self.yawLabel.textColor = UIColor.yellowColor()
                }
                else {
                    self.yawLabel.textColor = UIColor.whiteColor()
                }
                
                // ======== PITCH ======== //
                
                var pitch = motion.attitude.pitch
                var pitchDegrees = pitch * 180 / M_PI
//                var pitchDiff = self.targetPitch - abs(pitchDegrees)
                
                // -------------------------------- Pitch Diff Test ----------------------------- //
                var pitchDiff: Double
                if self.targetPitch < 0 {
                    println("If: 360 - Target")
                    // look at the console to see the current target values
                    println("Targets: Roll = \(self.targetRoll), Yaw = \(self.targetYaw), Pitch = \(self.targetPitch)")
                    var diffTest1 = 360 + self.targetPitch - abs(pitchDegrees)
                    var diffTest2 = abs(self.targetPitch) - abs(pitchDegrees)
                    if diffTest1 < diffTest2 {
                        println("pitchdiff = test1")
                        pitchDiff = diffTest1
                    } else {
                        pitchDiff = diffTest2
                        println("pitchdiff = test2")
                    }
                } else {
                    println("Target - abs")
                    // look at the console to see the current target values
                    println("Targets: Roll = \(self.targetRoll), Yaw = \(self.targetYaw), Pitch = \(self.targetPitch)")
                    pitchDiff = self.targetPitch - abs(pitchDegrees)
                }
                // ----------------------------------- end test ---------------------------------------- //
                
                if abs(pitchDiff) <= winMargin {
                    self.pitchLabel.textColor = UIColor.greenColor()
                }
                else if abs(pitchDiff) <= closeMargin {
                    self.pitchLabel.textColor = UIColor.orangeColor()
                }
                else {
                    self.pitchLabel.textColor = UIColor.whiteColor()
                }
                
                self.rollLabel.text = String(format: "Roll: %.0f\u{00B0}", rollDegrees)
                self.rollDiffLabel.text = String(format: "Diff: %.0f\u{00B0}", rollDiff)
                
                self.yawLabel.text = String(format: "Yaw: %.0f\u{00B0}", yawDegrees)
                self.yawDiffLabel.text = String(format: "Diff: %.0f\u{00B0}", yawDiff)
                
                self.pitchLabel.text = String(format: "Pitch: %.0f\u{00B0}", pitchDegrees)
                self.pitchDiffLabel.text = String(format: "Diff: %.0f\u{00B0}", pitchDiff)
                
                if (abs(rollDiff) <= winMargin) && (abs(yawDiff) <= winMargin) && (abs(pitchDiff) <= winMargin) {
                    self.resultLabel.text = "You Won!"
                    self.resultLabel.hidden = false
                    self.motionManager.stopDeviceMotionUpdates()
                }
                

            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rollLabel.textColor = UIColor.whiteColor()
        pitchLabel.textColor = UIColor.whiteColor()
        yawLabel.textColor = UIColor.whiteColor()
        rollDiffLabel.textColor = UIColor.yellowColor()
        pitchDiffLabel.textColor = UIColor.yellowColor()
        yawDiffLabel.textColor = UIColor.yellowColor()
        resultLabel.textColor = UIColor.greenColor()
        mainView.backgroundColor = UIColor.blackColor()
        
        rollDiffLabel.hidden = true
        pitchDiffLabel.hidden = true
        yawDiffLabel.hidden = true
        resultLabel.hidden = true
        rollLabel.hidden = true
        yawLabel.hidden = true
        pitchLabel.hidden = true

    }
    
}