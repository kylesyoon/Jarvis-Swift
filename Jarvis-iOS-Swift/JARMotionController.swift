//
//  JARMotionController.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import CoreMotion

protocol JARMotionDelegate {
    func detectedMotionWithPayload(payload: String)
}

class JARMotionController: NSObject {
    
    let deviceMotionUpdateInterval = 0.1
    let rollErrorThreshold = 30.0
    let rollTriggerThreshold = 75.0
    let motionTriggeredDelay = 0.5
    let motionManager = CMMotionManager()
    var previousAttitude: CMAttitude?
    var delegate: JARMotionDelegate?
    
    func startGettingDeviceMotionUpdates() {
        if self.motionManager.deviceMotionAvailable && !self.motionManager.deviceMotionActive {
            self.motionManager.deviceMotionUpdateInterval = deviceMotionUpdateInterval
            println("Starting device motion updates")
            self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (motion, error) -> Void in
                if error != nil {
                    // TODO: Error handling
                } else {
                    self.analyzeMotion(motion)
                }
            })
        }
    }
    
    func analyzeMotion(motion: CMDeviceMotion!) {
        // If we have previous attitude then analyze
        if let previousAttitude = self.previousAttitude {
            // Get difference in attitude
            previousAttitude.multiplyByInverseOfAttitude(motion.attitude)
            
            var roll = self.getDegreesFromRadians(previousAttitude.roll)
            var pitch = self.getDegreesFromRadians(previousAttitude.pitch)
            var yaw = self.getDegreesFromRadians(previousAttitude.yaw)
            // Trigger message if motion satisfies these conditions
            if fabs(pitch) < rollErrorThreshold && fabs(yaw) < rollErrorThreshold {
                if roll > rollTriggerThreshold {
                    self.delegate?.detectedMotionWithPayload(JARMessagePayload.Back)
                    self.restartMotionDeviceUpdatesAfterDelay(motionTriggeredDelay)
                } else if roll < -rollTriggerThreshold {
                    self.delegate?.detectedMotionWithPayload(JARMessagePayload.Next)
                    self.restartMotionDeviceUpdatesAfterDelay(motionTriggeredDelay)
                }
            }
        }
        // Now make this attitude the previous attitude
        self.previousAttitude = motion.attitude
    }
    
    // This prevents the user's unintentional motion follow-through from sending message
    func restartMotionDeviceUpdatesAfterDelay(delay: Double) {
        self.motionManager.stopDeviceMotionUpdates()

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.startGettingDeviceMotionUpdates()
        }
    }
    
    // MARK: Convenience
    
    func getDegreesFromRadians(radians: Double) -> Double {
        return radians * 180.0 / M_PI
    }
    
}
