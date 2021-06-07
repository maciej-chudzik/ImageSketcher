//
//  Extensions.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

//XOR for Bool
public extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}


public extension CGRect{
    
    var orientation: OriginOrientation{
        
        if self.size.width > 0.0 && self.size.height > 0.0{
            
            return .topLefCorner
            
        }else if self.size.width < 0.0 && self.size.height < 0.0{
            
            return .bottomRightCorner
            
        }else if self.size.width < 0.0 && self.size.height > 0.0{
            
            return .topRightCorner
            
        }else if self.size.width > 0.0 && self.size.height < 0.0{
            
            return .bottomLeftCorner
            
        }
        
        return .topLefCorner
        
    }
    
    enum OriginOrientation{
        
        case topLefCorner
        case bottomRightCorner
        case topRightCorner
        case bottomLeftCorner
        
    }
    
    enum OriginRotationOrientationDestination{
        
        case opposite
        case neighbouringClockwise
        case neighbouringCounterClockwise
        
        
        
    }
    
    
    mutating func rotateOrigin(to direction: OriginRotationOrientationDestination){
        
        switch direction{
        
        case .opposite:
            
            
            switch self.orientation {
            
            case .topLefCorner:
                
                self.origin = CGPoint(x: self.origin.x + self.size.width, y: self.origin.y + self.size.height)
                self.size = CGSize(width: -self.size.width, height: -self.size.height)
                
                
            case .bottomRightCorner:
                
                self.origin = CGPoint(x: self.origin.x - self.standardized.width, y: self.origin.y - self.standardized.height)
                self.size = CGSize(width: -self.size.width, height: -self.size.height)
                
                
            case .topRightCorner:
                
                self.origin = CGPoint(x: self.origin.x - self.standardized.width, y: self.origin.y + self.standardized.height)
                
                self.size = CGSize(width: -self.size.width, height: -self.size.height)
                
                
            case .bottomLeftCorner:
                
                self.origin = CGPoint(x: self.origin.x + self.standardized.width, y: self.origin.y - self.standardized.height)
                
                self.size =  CGSize(width: -self.size.width, height: -self.size.height)
                
                
            }
            
            
        case .neighbouringClockwise:
            
            
            switch self.orientation {
            
            case .topLefCorner:
                
                self.origin = CGPoint(x: self.origin.x + self.size.width, y: self.origin.y)
                
                self.size = CGSize(width: -self.size.width, height: self.size.height)
                
                
            case .bottomRightCorner:
                
                self.origin = CGPoint(x: self.origin.x - self.standardized.width, y: self.standardized.height)
                
                self.size = CGSize(width: self.size.width, height: -self.size.height)
                
                
                
            case .topRightCorner:
                
                self.origin = CGPoint(x: self.origin.x, y: self.origin.y + self.standardized.height)
                
                self.size = CGSize(width: self.size.width, height: -self.size.height)
                
                
            case .bottomLeftCorner:
                
                self.origin =  CGPoint(x: self.origin.x, y: self.origin.y - self.standardized.height)
                
                self.size = CGSize(width: self.size.width, height: -self.size.height)
                
                
            }
            
        case .neighbouringCounterClockwise:
            
            switch self.orientation {
            
            case .topLefCorner:
                
                self.origin = CGPoint(x: self.origin.x, y: self.origin.y + self.standardized.height)
                
                self.size = CGSize(width: self.size.width, height: -self.size.height)
                
                
            case .bottomRightCorner:
                
                self.origin = CGPoint(x: self.origin.x, y: self.origin.y - self.standardized.height)
                
                self.size = CGSize(width: self.size.width, height: -self.size.height)
                
                
                
                
            case .topRightCorner:
                
                self.origin = CGPoint(x: self.origin.x - self.standardized.width, y: self.origin.y)
                
                self.size =  CGSize(width: -self.size.width, height: self.size.height)
                
                
                
            case .bottomLeftCorner:
                
                self.origin = CGPoint(x: self.origin.x + self.standardized.width, y: self.origin.y)
                
                self.size = CGSize(width: -self.size.width, height: self.size.height)
                
            }
        
        }
    
    }
    
}


extension CGRect: Hashable{
    
    
   public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
        hasher.combine(origin)
       
    }
    
}

public extension CGFloat{
    
    func round(toDecimalPlaces places: Int) -> CGFloat {
        
        let divisor = pow(10.0, CGFloat(places))
        let roundedMultiplication = (self * divisor).rounded()
        return roundedMultiplication  / divisor
    }
}

public extension CGFloat {
    
    func toRadians() -> CGFloat{
       return self * .pi / 180.0
        
    }
    
}

extension CGPoint{
    
    public func distanceSquared(toPoint to : CGPoint) -> CGFloat {

        return  (self.x - to.x) * (self.x - to.x) + (self.y - to.y) * (self.y - to.y)
    }
    
    public func distanceToPoint(toPoint to: CGPoint) -> CGFloat {
        return sqrt(distanceSquared(toPoint: to))
    }
    
    public func xDiff(fromPoint: CGPoint) -> CGFloat{
        
        return self.x - fromPoint.x
    }
    
    public func yDiff(fromPoint: CGPoint) -> CGFloat{
        
        return self.y - fromPoint.y
    }
    
}

extension CGPoint: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
