//
//  JARBrowser.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol JARBrowserDelegate {
    func foundPeer(peerID: MCPeerID)
}

class JARBrowser: NSObject, MCNearbyServiceBrowserDelegate {
    
    let mcSession: MCSession
    var delegate: JARBrowserDelegate?
    var currentPeer: MCPeerID?
    
    init(mcSession: MCSession, delegate: JARBrowserDelegate? = nil) {
        self.mcSession = mcSession
        self.delegate = delegate
        super.init()
    }
    
    // MARK: MCNearbyServiceBrowserDelegate
    
    var mcBrowser: MCNearbyServiceBrowser?
   
    func startBrowsing(serviceType: String) {
        self.mcBrowser = MCNearbyServiceBrowser(peer: mcSession.myPeerID, serviceType: serviceType)
        self.mcBrowser?.delegate = self

        self.mcBrowser?.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        self.mcBrowser?.delegate = nil
        self.mcBrowser?.stopBrowsingForPeers()
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        if currentPeer != peerID {
            self.delegate?.foundPeer(peerID)
        }
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        // Unused
    }
    
}
