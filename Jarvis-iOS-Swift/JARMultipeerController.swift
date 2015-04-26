//
//  JARJARMultipeerController.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol JARMultipeerDelegate {
    func didFoundPeer(peerID: MCPeerID, forSession session: MCSession)
    func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession)
}

class JARMultipeerController: JARSessionDelegate, JARBrowserDelegate {
    
    let displayName: String = UIDevice.currentDevice().name
    let jarvisServiceType = "yoonapps-jarvis"
    let session: JARSession
    let browser: JARBrowser
    var delegate: JARMultipeerDelegate?
    
    // Singleton via Struct
    
    class var sharedInstance: JARMultipeerController {
        struct Singleton {
            static let instance = JARMultipeerController()
        }
        
        return Singleton.instance
    }
    
    init() {
        session = JARSession(displayName: displayName, delegate: nil)
        browser = JARBrowser(mcSession: session.mcSession, delegate: nil)
        session.delegate = self
        browser.delegate = self
    }
    
    func startBrowsing() {
        browser.startBrowsing(jarvisServiceType)
    }
    
    func stopBrowsing() {
        browser.stopBrowsing()
    }
    
    func restartBrowsing() {
        self.stopBrowsing()
        self.startBrowsing()
    }
    
    // MARK: JARSessionDelegate
    
    func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession) {
        self.delegate?.didChangeState(state, peer: peerID, forSession: session)
        self.setIdleTimerForState(state)
        if state == MCSessionState.NotConnected {
            self.browser.currentPeer = nil
        }
    }
    
    // MARK: JARBrowserDelegate
    
    func foundPeer(peerID: MCPeerID) {
        self.delegate?.didFoundPeer(peerID, forSession: session.mcSession)
    }
    
    // MARK: Message Sending

    func sendMessage(message: String) -> Bool {
        var isQueued = false
        if session.currentState == .Connected && browser.currentPeer != nil {
            // Faking successful queue of data
            if JARTestHelper.sharedInstance.isUnitTesting {
                isQueued = true
                return isQueued
            }
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
