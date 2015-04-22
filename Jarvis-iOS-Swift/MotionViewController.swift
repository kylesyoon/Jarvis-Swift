//
//  MotionViewController.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MotionViewController: BaseViewController {

    @IBOutlet weak var connectionLabel: UILabel!
    
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
    
    func changeViewForState(state: MCSessionState, peer peerID: MCPeerID?) {
        switch state {
        case MCSessionState.Connected:
            if let peer = peerID {
                self.connectionLabel.text = peer.displayName
            }
        case MCSessionState.Connecting:
            self.connectionLabel.text = "Connecting"
        case MCSessionState.NotConnected:
            self.connectionLabel.text = "Not Connected"
        }
    }
    
}
