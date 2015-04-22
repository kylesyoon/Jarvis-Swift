//
//  BaseViewController.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class BaseViewController: UIViewController, MultipeerDelegate {
    
    let multipeerController = MultipeerController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.multipeerController.startBrowsing()
        self.multipeerController.delegate = self
    }
    
    func didFoundPeer(peerID: MCPeerID, forSession session: MCSession) {
        var foundPeerAlert = UIAlertController(title: "Found Peer", message: "Found peer \(peerID)", preferredStyle: .Alert)
        
        foundPeerAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
            foundPeerAlert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        foundPeerAlert.addAction(UIAlertAction(title: "Connect", style: .Default, handler: { (alert:UIAlertAction!) -> Void in
            self.multipeerController.browser.mcBrowser?.invitePeer(peerID, toSession: self.multipeerController.session.mcSession, withContext: nil, timeout: 30)
            self.multipeerController.browser.currentPeer = peerID
        }))
        
        self.presentViewController(foundPeerAlert, animated: true, completion: nil)
    }
    
    func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession) {
        // Implmentation done down at subclass.
    }
    
    @IBAction func pressedRefresh() {
        self.multipeerController.sendMessage(MessagePayload.Restart)
    }
    
}
