//
//  JarvisMultipeerConnectivityTests.swift
//  Jarvis-iOS-Swift
//
//  Created by Sejin Yoon on 4/26/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import XCTest
import MultipeerConnectivity

class JarvisMultipeerConnectivityTests: JarvisBaseTests {

    var multipeerController = JARMultipeerController.sharedInstance

    func testBrowserValidServiceType() {
        XCTAssertEqual(self.multipeerController.jarvisServiceType, "yoonapps-jarvis")
    }
    
    func testLocalPeerIDDisplayNameIsDeviceName() {
        if let displayName = self.multipeerController.browser.mcBrowser?.myPeerID.displayName {
            XCTAssertEqual(displayName, UIDevice.currentDevice().name)
        }
    }
    
    func testSendingMessageFailsWithNoCurrentPeer() {
        self.multipeerController.session.currentState = MCSessionState.Connected
        self.multipeerController.browser.currentPeer = nil
        let isQueued = self.multipeerController.sendMessage(JARMessagePayload.Next)
        XCTAssertFalse(isQueued)
    }
    
    func testSendingMessageWithCurrentPeer() {
        self.multipeerController.session.currentState = MCSessionState.Connected
        self.multipeerController.browser.currentPeer = MCPeerID(displayName: "Tester")
        let isQueued = self.multipeerController.sendMessage(JARMessagePayload.Next)
        XCTAssert(isQueued)
    }
    
}
