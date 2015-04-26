//
//  JARTestHelper.swift
//  Jarvis-iOS-Swift
//
//  Created by Sejin Yoon on 4/26/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit

class JARTestHelper: NSObject {
    
    var isUnitTesting: Bool
    
    class var sharedInstance: JARTestHelper {
        struct Singleton {
            static let instance = JARTestHelper()
        }
        
        return Singleton.instance
    }
    
    override init() {
        self.isUnitTesting = false
        super.init()
    }
    
}
