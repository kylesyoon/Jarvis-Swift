//
//  MultipeerController.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol MultipeerDelegate {
    func didFoundPeer(peerID: MCPeerID, forSession session: MCSession)
    func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession)
}

class MultipeerController: SessionDelegate, BrowserDelegate {
    
    let displayName: String = UIDevice.currentDevice().name
    let jarvisServiceType = "yoonapps-jarvis"
    let session: Session
    let browser: Browser
    var delegate: MultipeerDelegate?
    
    // Singleton via Struct
    
    class var sharedInstance: MultipeerController {
        struct Singleton {
            static let instance = MultipeerController()
        }
        
        return Singleton.instance
    }
    
    init() {
        session = Session(displayName: displayName, delegate: nil)
        browser = Browser(mcSession: session.mcSession, delegate: nil)
        session.delegate = self
        browser.delegate = self
    }
    
    func startBrowsing() {
        browser.startBrowsing(jarvisServiceType)
    }
    
    func stopBrowsing() {
        browser.stopBrowsing()
    }
    
    // MARK: SessionDelegate
    
    func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession) {
        self.delegate?.didChangeState(state, peer: peerID, forSession: session)
        self.setIdleTimerForState(state)
    }
    
    // MARK: BrowserDelegate
    
    func foundPeer(peerID: MCPeerID) {
        self.delegate?.didFoundPeer(peerID, forSession: session.mcSession)
    }
    
    // MARK: Message Sending

    func sendMessage(message: String) -> Bool {
        var isQueued = false
        if session.currentState == .Connected && browser.currentPeer != nil {
            // Since we checked that browser.currentPeer isn't nil, force unwrap.
            let currentPeer = browser.currentPeer!
            let payload = message.dataUsingEncoding(NSUTF8StringEncoding)
            var error: NSError?
            // If we got payload data, use it.
            if let payload = payload {
                isQueued = self.session.mcSession.sendData(payload, toPeers: [currentPeer], withMode: MCSessionSendDataMode.Reliable, error: &error)
                println("Sending data \(message)")
                // If we got error (not nil), then isQueued is false.
                if let error = error {
                    let errorDescription = error.userInfo
                    isQueued = false
                    println("Error sending data \(errorDescription)")
                }
            }
        }
        
        return isQueued
    }
    
    // MARK: Idle Timer
    
    func setIdleTimerForState(state: MCSessionState) {
        if state == MCSessionState.Connected {
            UIApplication.sharedApplication().idleTimerDisabled = true
        } else {
            UIApplication.sharedApplication().idleTimerDisabled = false
        }
    }
}
