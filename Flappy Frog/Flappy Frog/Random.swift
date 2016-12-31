//
//  Random.swift
//  Flappy Frog
//
//  Created by Mnady Zhao on 12/11/16.
//  Copyright © 2016 MnadyZhao. All rights reserved.
//

import Foundation
import CoreGraphics

public class Random {
    
    
    public static func gen() -> CGFloat{
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func gen(min : CGFloat, max : CGFloat) -> CGFloat{
        
        return gen() * (max - min) + min
    }
    
    
}
