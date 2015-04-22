//
//  TouchViewController.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class TouchViewController: BaseViewController {
   
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet var swipeUpGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var swipeDownGestureRecognizer: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeViewForState(self.multipeerController.session.currentState, peer: self.multipeerController.browser.currentPeer)
    }
    
    override func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession) {
        self.changeViewForState(state, peer: peerID)
    }
    // I know currentState always has a value, so force unwrap.
    func changeViewForState(state: MCSessionState, peer peerID: MCPeerID?) {
        switch state {
        case MCSessionState.Connected:
            if let peer = peerID {
                self.connectionLabel.text = "Connected to \(peer.displayName)"
            }
        case MCSessionState.Connecting:
            self.connectionLabel.text = "Connecting"
        case MCSessionState.NotConnected:
            self.connectionLabel.text = "Not Connected"
        }
    }
    
    // MARK: IBActions

    @IBAction func didSwipe(swipe: UISwipeGestureRecognizer) {
        if swipe.state == UIGestureRecognizerState.Ended {
            switch swipe.direction {
            case UISwipeGestureRecognizerDirection.Up:
                println("Swiped up")
                self.multipeerController.sendMessage(MessagePayload.Next)
            case UISwipeGestureRecognizerDirection.Down:
                println("Swiped down")
                self.multipeerController.sendMessage(MessagePayload.Back)
            default:
                println("Unrecognized swipe direction")
            }
            self.showAnimationForSwipeGestureDirection(swipe.direction)
        }
    }

    @IBAction func pressedPresent() {
        self.multipeerController.sendMessage(MessagePayload.Present)
    }
    
    @IBAction func pressedESC() {
        self.multipeerController.sendMessage(MessagePayload.ESC)
    }
    
    // MARK: Animation
    
    func showAnimationForSwipeGestureDirection(direction: UISwipeGestureRecognizerDirection!) {
        var transitionText: String?
        var animationOption: UIViewAnimationOptions?
        
        switch direction {
        case UISwipeGestureRecognizerDirection.Up:
            transitionText = "NEXT"
            animationOption = UIViewAnimationOptions.TransitionFlipFromTop
        case UISwipeGestureRecognizerDirection.Down:
            transitionText = "BACK"
            animationOption = UIViewAnimationOptions.TransitionFlipFromBottom
        default:
            println("Unidentified swipe gesture direction!")
        }
        
        if let transitionText = transitionText, animationOption = animationOption {
            self.swipeDownGestureRecognizer.enabled = false
            self.swipeUpGestureRecognizer.enabled = false
            
            UIView.transitionWithView(self.swipeLabel, duration: 0.3, options: animationOption | UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.swipeLabel.transform = CGAffineTransformMakeScale(2.0, 2.0)
                self.swipeLabel.text = transitionText
            }, completion: { (finished) -> Void in
                UIView.transitionWithView(self.swipeLabel, duration: 0.15, options: animationOption | UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.swipeLabel.transform = CGAffineTransformIdentity
                    self.swipeLabel.text = "SWIPE"
                    
                    self.swipeDownGestureRecognizer.enabled = true
                    self.swipeUpGestureRecognizer.enabled = true
                }, completion:nil)
            })
        }
    }

    
}
