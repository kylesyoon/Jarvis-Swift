//
//  MotionController.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import CoreMotion

protocol MotionDelegate {
    func detectedMotionWithPayload(payload: String)
}

class MotionController: NSObject {
    
    let deviceMotionUpdateInterval = 0.1
    let rollErrorThreshold = 30.0
    let rollTriggerThreshold = 75.0
    let motionTriggeredDelay = 0.5
    let motionManager = CMMotionManager()
    var previousAttitude: CMAttitude?
    var delegate: MotionDelegate?
    
    func startGettingDeviceMotionUpdates() {
        if self.motionManager.deviceMotionAvailable && !self.motionManager.deviceMotionActive {
            self.motionManager.deviceMotionUpdateInterval = deviceMotionUpdateInterval
            println("Starting device motion updates")
            self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (motion, error) -> Void in
                if (error != nil) {
                    // TODO: Error handling
                }
            })
        }
    }
    
    func analyzeMotion(motion: CMDeviceMotion!) {
        if let previousAttitude = self.previousAttitude {
            previousAttitude.multiplyByInverseOfAttitude(motion.attitude)
            
            var roll = self.getDegreesFromRadians(previousAttitude.roll)
            var pitch = self.getDegreesFromRadians(previousAttitude.pitch)
            var yaw = self.getDegreesFromRadians(previousAttitude.yaw)
            
            if fabs(pitch) < rollErrorThreshold && fabs(yaw) < rollErrorThreshold {
                if roll > rollTriggerThreshold {
                    self.delegate?.detectedMotionWithPayload(MessagePayload.Back)
                    self.restartMotionDeviceUpdatesAfterDelay(motionTriggeredDelay)
                } else if roll < -rollTriggerThreshold {
                    self.delegate?.detectedMotionWithPayload(MessagePayload.Next)
                    self.restartMotionDeviceUpdatesAfterDelay(motionTriggeredDelay)
                }
            }
        }
        self.previousAttitude = motion.attitude
    }
    
    func getDegreesFromRadians(radians: Double) -> Double {
        return radians * 180.0 / M_PI
    }
    
    func restartMotionDeviceUpdatesAfterDelay(delay: Double) {
        self.motionManager.stopDeviceMotionUpdates()

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.startGettingDeviceMotionUpdates()
        }
    }
    
}
