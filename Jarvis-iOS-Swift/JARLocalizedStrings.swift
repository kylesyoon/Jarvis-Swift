//
//  JARLocalizedStrings.swift
//  Jarvis-iOS-Swift
//
//  Created by Sejin Yoon on 4/25/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import Foundation

struct JARLocalizedStrings {
    static func foundPeerAlertTitle() -> String {
        return NSLocalizedString("Connection Available", comment: "Title for alert when peer is found")
    }
    
    static func foundPeerAlertMessageWithPeerName(peerName: String) -> String {
        return NSLocalizedString("Would you like to connect to \(peerName)", comment: "Message for alert when peer is found. Format expects peer display name string.")
    }
    
    static func connect() -> String {
        return NSLocalizedString("Connect", comment: "Connected")
    }
    
    static func connectedFormatWithPeerName(peerName: String) -> String {
        return NSLocalizedString("Connected to \(peerName)", comment: "Connected text with format expecting peer display name string")
    }
    
    static func cancel() -> String {
        return NSLocalizedString("Cancel", comment: "Cancel")
    }
    
    static func connecting() -> String {
        return NSLocalizedString("Connecting", comment: "Connecting")
    }
    
    static func connectingFormatWithPeerName(peerName: String) -> String {
        return NSLocalizedString("Connecting to \(peerName)", comment: "Connecting text with format expecting peer display name string")
    }
    
    static func notConnected() -> String {
        return NSLocalizedString("Not Connected", comment: "Not Connected")
    }
    
    static func next() -> String {
        return NSLocalizedString("Next", comment: "Next")
    }
    
    static func back() -> String {
        return NSLocalizedString("Back", comment: "Back")
    }
    
    static func swipe() -> String {
        return NSLocalizedString("Swipe", comment: "Swipe")
    }
    
}