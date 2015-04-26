//
//  MotionViewController.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MotionViewController: BaseViewController, MotionDelegate {
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var touchButton: UIButton!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet var crossFadeViews: Array<UIView>! // TODO: Might not need this.
    let motionController = MotionController()
    let showMotionDetectedAnimationDuration = 0.25
    let hideMotionDetectedAnimationDuration = 0.5
    let connectedAnimationDuration = 0.5
    var connectedGradientView: ConnectedGradientView?
    var motionDetectedGradientView: MotionDetectedGradientView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.motionController.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
            if let peer = peerID {
                self.connectionLabel.text = peer.displayName
                self.connectionLabel.textColor = UIColor.jarvis_gunMetal()
            }
            self.motionController.startGettingDeviceMotionUpdates()
            self.showConnectedGradient()
            
            self.motionDetectedGradientView = MotionDetectedGradientView(frame: self.view.bounds)
            self.motionDetectedGradientView?.alpha = 0.0
            if let motionDetectedGradientView = self.motionDetectedGradientView {
                self.view.addSubview(motionDetectedGradientView)
            }
        case MCSessionState.Connecting:
            self.connectionLabel.text = "Connecting"
            self.connectionLabel.textColor = UIColor.jarvis_lightBlue()
        case MCSessionState.NotConnected:
            self.connectionLabel.text = "Not Connected"
            self.connectionLabel.textColor = UIColor.jarvis_lightBlue()
            self.motionController.motionManager.stopDeviceMotionUpdates()
            self.motionDetectedGradientView?.removeFromSuperview()
        }
    }
    
    // MARK: MultipeerDelegate
    
    override func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession) {
        self.updateViewControllerForSessionState(state, peer: peerID)
    }
    
    // MARK: MotionDelegate
    
    func detectedMotionWithPayload(payload: String) {
        self.multipeerController.sendMessage(payload)
    }
    
    // MARK: Animations
    
    func showConnectedGradient() {
        self.connectedGradientView = ConnectedGradientView(frame: self.view.bounds)
        self.connectedGradientView?.alpha = 0.0
        
        if let connectedGradientView = self.connectedGradientView {
            self.view.addSubview(connectedGradientView)
        }
        
        UIView.animateWithDuration(self.connectedAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.connectedGradientView?.alpha = 1.0
            }, completion: nil)
    }
    
    func hideConnectedGradient() {
        UIView.animateWithDuration(self.connectedAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.connectedGradientView?.alpha = 0.0
            }) { (finished) -> Void in
                self.connectedGradientView?.removeFromSuperview()
        }
    }
    
    func showAndHideMotionDetectedGradien() {
        UIView.animateWithDuration(self.showMotionDetectedAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.motionDetectedGradientView?.alpha = 1.0
            }) { (finished) -> Void in
                UIView.animateWithDuration(self.hideMotionDetectedAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.motionDetectedGradientView?.alpha = 0.0
                    }, completion: nil)
        }
    }
    
}
