//
//  JARMotionViewController.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class JARMotionViewController: JARBaseViewController, JARMotionDelegate {
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var touchButton: UIButton!
    @IBOutlet weak var connectionLabel: UILabel!
    let motionController = JARMotionController()
    let showMotionDetectedAnimationDuration = 0.25
    let hideMotionDetectedAnimationDuration = 0.5
    let connectedAnimationDuration = 0.5
    var connectedGradientView: JARConnectedGradientView?
    var motionDetectedGradientView: JARMotionDetectedGradientView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.motionController.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Keep these in front
        self.view.bringSubviewToFront(self.connectionLabel)
        self.view.bringSubviewToFront(self.refreshButton)
        self.view.bringSubviewToFront(self.touchButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateViewControllerForSessionState(self.multipeerController.session.currentState, peer: self.multipeerController.browser.currentPeer)
    }
    
    func updateViewControllerForSessionState(state: MCSessionState, peer peerID: MCPeerID?) {
        switch state {
        case MCSessionState.Connected:
            // Update views
            // Make sure peerID isn't nil
            if let peerID = peerID {
                self.connectionLabel.text = peerID.displayName
                self.connectionLabel.textColor = UIColor.jarvis_gunMetal()
            }
            self.showConnectedGradient()
            //Start up motion updates
            self.motionController.startGettingDeviceMotionUpdates()
            // Add motion detected gradient view for
            self.motionDetectedGradientView = JARMotionDetectedGradientView(frame: self.view.bounds)
            self.motionDetectedGradientView?.alpha = 0.0
            if let motionDetectedGradientView = self.motionDetectedGradientView {
                self.view.addSubview(motionDetectedGradientView)
            }
        case MCSessionState.Connecting:
            // Update views
            self.connectionLabel.text = JARLocalizedStrings.connecting()
            self.connectionLabel.textColor = UIColor.jarvis_lightBlue()
        case MCSessionState.NotConnected:
            // Update views
            self.connectionLabel.text = JARLocalizedStrings.notConnected()
            self.connectionLabel.textColor = UIColor.jarvis_lightBlue()
            self.hideConnectedGradient()
            // Stop motion updates
            self.motionController.motionManager.stopDeviceMotionUpdates()
            self.motionDetectedGradientView?.removeFromSuperview()
        }
    }
    
    // MARK: JARMultipeerDelegate
    
    override func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession) {
        self.updateViewControllerForSessionState(state, peer: peerID)
    }
    
    // MARK: JARMotionDelegate
    
    func detectedMotionWithPayload(payload: String) {
        self.multipeerController.sendMessage(payload)
    }
    
    // MARK: Animations
    
    func showConnectedGradient() {
        // Show that connection is made
        self.connectedGradientView = JARConnectedGradientView(frame: self.view.bounds)
        self.connectedGradientView?.alpha = 0.0
        
        if let connectedGradientView = self.connectedGradientView {
            self.view.addSubview(connectedGradientView)
        }
        // Animate it
        UIView.animateWithDuration(self.connectedAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.connectedGradientView?.alpha = 1.0
            }, completion: nil)
    }
    
    func hideConnectedGradient() {
        // Show there is no connection
        UIView.animateWithDuration(self.connectedAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.connectedGradientView?.alpha = 0.0
            }) { (finished) -> Void in
                self.connectedGradientView?.removeFromSuperview()
        }
    }
    
    func showAndHideMotionDetectedGradien() {
        // Create a flash effect with the gradient view
        UIView.animateWithDuration(self.showMotionDetectedAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.motionDetectedGradientView?.alpha = 1.0
            }) { (finished) -> Void in
                UIView.animateWithDuration(self.hideMotionDetectedAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.motionDetectedGradientView?.alpha = 0.0
                    }, completion: nil)
        }
    }
    
}
