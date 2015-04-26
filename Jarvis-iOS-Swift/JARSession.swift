//
//  JARSession.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol JARSessionDelegate {
    func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession)
}

class JARSession: NSObject, MCSessionDelegate {
    
    var myPeerID: MCPeerID
    var delegate: JARSessionDelegate?
    var mcSession: MCSession
    var currentState: MCSessionState!
    
    init(displayName: String, delegate: JARSessionDelegate? = nil) {
        self.myPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.delegate = delegate
        self.mcSession = MCSession(peer: myPeerID)
        self.currentState = MCSessionState.NotConnected
        super.init()
        self.mcSession.delegate = self;
    }
    
    // MARK: MCSessionDelegate
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.currentState = state
            self.delegate?.didChangeState(state, peer: peerID, forSession: session)
        })
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        // Unused
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        // Unused
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        // Unused
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        // Unused
    }
}
