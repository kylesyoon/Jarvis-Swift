//
//  JARCrossFadeSegue.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/22/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit

class JARCrossFadeSegue: UIStoryboardSegue {
    
    override func perform() {
        if let destinationViewController = self.destinationViewController as? UIViewController, sourceViewController = self.sourceViewController as? UIViewController {
            let destinationSubviewsArray = destinationViewController.view.subviews
            let allSubviewsArray = sourceViewController.view.subviews + destinationSubviewsArray
            // Fade out both source and destination views
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                for view in allSubviewsArray {
                    (view as! UIView).alpha = 0.0
                }
                }, completion: { (finished) -> Void in
                    // Fade in destination views
                    self.sourceViewController.presentViewController(destinationViewController, animated: false, completion: { () -> Void in
                        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                            for view in destinationSubviewsArray {
                                (view as! UIView).alpha = 1.0
                            }
                            }, completion: nil)
                    })
            })
            
        }
    }
    
}
