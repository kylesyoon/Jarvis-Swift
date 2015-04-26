//
//  JarvisBaseTests.swift
//  Jarvis-iOS-Swift
//
//  Created by Sejin Yoon on 4/25/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import XCTest

class JarvisBaseTests: XCTestCase {

    override func setUp() {
        super.setUp()
        JARTestHelper.sharedInstance.isUnitTesting = true
    }
    
    override func tearDown() {
        JARTestHelper.sharedInstance.isUnitTesting = false
        super.tearDown()
    }

}
