//
//  Line.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import CoreGraphics


struct Line: Hashable{
    
    let slope: CGFloat
    let b: CGFloat
    
    
    init(point1: CGPoint, point2: CGPoint){
        
        if point1.x == point2.x {
            self.slope = 0
        }else {
            self.slope = (point2.y - point1.y) /  (point2.x - point1.x)
        }
        
        self.b = point1.y - slope*point1.x
    }
    
    func findXCoordinate(y: CGFloat)->CGFloat?{
        
        guard slope != 0 else {return nil}
        
        return (y - b)/slope
    }
    
    func findYCoordinate(x: CGFloat)->CGFloat{
        
        return slope*x + b
    }
    
    func containsCGPoint(contatains point: CGPoint, roundToDecimalPlaces places: Int) -> Bool{
        
        let lhs = point.y.round(toDecimalPlaces: places)
        
        let rhs = (slope * point.x + b).round(toDecimalPlaces: places)
        
        return lhs  == rhs
        
    }
    
}
