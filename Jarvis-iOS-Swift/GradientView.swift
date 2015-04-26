//
//  GradientView.swift
//  Jarvis-iOS-Swift
//
//  Created by Kyle Yoon on 4/22/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var locations: [CGFloat] = []
    var colors: CFArray = []
    var radius: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let contextRef = UIGraphicsGetCurrentContext()
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let gradientRef = CGGradientCreateWithColors(colorSpaceRef, self.colors, self.locations)
        CGContextDrawRadialGradient(contextRef, gradientRef, self.center, 0, self.center, self.radius, 0)
        
        UIGraphicsEndImageContext()
    }
}

class ConnectedGradientView: GradientView {
    
    override func drawRect(rect: CGRect) {
        self.colors = [UIColor.whiteColor().CGColor, UIColor.whiteColor().CGColor, UIColor.jarvis_lightBlue().CGColor, UIColor.jarvis_gunMetal().CGColor]
        self.locations = [0.0, 0.2, 0.4, 1.0]
        self.radius = sqrt(pow(self.frame.size.width / 2, 2) + pow(self.frame.size.height / 2, 2))
        super.drawRect(rect)
    }
    
}

class MotionDetectedGradientView: GradientView {
    
    override func drawRect(rect: CGRect) {
        self.colors = [UIColor.whiteColor().CGColor, UIColor.whiteColor().CGColor, UIColor.jarvis_lightBlue().CGColor, UIColor.whiteColor().CGColor]
        self.locations = [0.0, 0.6, 0.75, 1.0]
        self.radius = sqrt(pow(self.frame.size.width / 2, 2) + pow(self.frame.size.height / 2, 2))
        super.drawRect(rect)
    }
    
}