//
//  Random.swift
//  Flappy Frog
//
//  Created by Quincy on 12/11/16.
//  Copyright © 2016 RuiZou. All rights reserved.
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
