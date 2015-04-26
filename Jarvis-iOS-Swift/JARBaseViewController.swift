//
//  JARBaseViewController.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class JARBaseViewController: UIViewController, JARMultipeerDelegate {
    // Keep only one multipeer controller across the board
    let multipeerController = JARMultipeerController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start looking for connection as soon as view loads
        self.multipeerController.startBrowsing()
        self.multipeerController.delegate = self
    }
    
    // MARK: JARMultipeerDelegate
    // This call is started from JARBrowserDelegate
    func didFoundPeer(peerID: MCPeerID, forSession session: MCSession) {
        var foundPeerAlert = UIAlertController(title: JARLocalizedStrings.foundPeerAlertTitle(), message: JARLocalizedStrings.foundPeerAlertMessageWithPeerName(peerID.displayName), preferredStyle: .Alert)
        
        foundPeerAlert.addAction(UIAlertAction(title: JARLocalizedStrings.cancel(), style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
            foundPeerAlert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        foundPeerAlert.addAction(UIAlertAction(title: JARLocalizedStrings.connect(), style: .Default, handler: { (alert:UIAlertAction!) -> Void in
            self.multipeerController.browser.mcBrowser?.invitePeer(peerID, toSession: self.multipeerController.session.mcSession, withContext: nil, timeout: 30)
            self.multipeerController.browser.currentPeer = peerID
        }))
        
        self.presentViewController(foundPeerAlert, animated: true, completion: nil)
    }
    
    func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession) {
        // Implmentation done down at subclass.
    }
    
    @IBAction func pressedRefresh() {
        // Attempt to reestablish connection
        self.multipeerController.sendMessage(JARMessagePayload.Restart)
        self.multipeerController.restartBrowsing()
    }
    
}
