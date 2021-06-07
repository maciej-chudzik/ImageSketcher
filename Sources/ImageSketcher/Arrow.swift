//
//  Arrow.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import CoreGraphics

public struct Arrow{
    
    public let startPoint: CGPoint
    public let angle: CGFloat
    public let endPoint: CGPoint
    public let wingLength: CGFloat
    
    
    public init?(start: CGPoint, end: CGPoint, angle: CGFloat, wingLength: CGFloat){
        
        guard wingLength < start.distanceToPoint(toPoint: end) && wingLength > 0  else {return nil}
        guard angle > 0.0 && angle < 90.0 else {return nil}
        
        self.startPoint = start
        self.endPoint = end
        self.angle = angle
        self.wingLength = wingLength
        
    }
    
    public var wings:(left: LineSegment, right: LineSegment)?{
        
        guard let left = coreLineSegment.adjacentLineSegment(angled: -angle, atDistance: wingLength) else {return nil}
        
        guard let right =  coreLineSegment.adjacentLineSegment(angled: angle, atDistance: wingLength) else {return nil}
        
        return (left: LineSegment(endPointA: left.endPointB, endPointB: self.endPoint), right: LineSegment(endPointA: self.endPoint, endPointB: right.endPointB))
        
    }
    
    public var coreLineSegment: LineSegment{
        return LineSegment(endPointA: startPoint, endPointB: endPoint)
        
    }
    
    
    //MARK: Drawable conformance
    @available(iOS 10.0, *)
    public func draw(mode:DrawingMode) -> ImageRendererContextModification{
        
        return { (context) in
            
            
            let _ = self.coreLineSegment.draw(mode: mode)(context)
            
            if let wings = self.wings{
                
                let _ = wings.left.draw(mode: mode)(context)
                
                let _ = wings.right.draw(mode: mode)(context)
                
                
            }
            return context}
    }
    
    
}

 
    
    
    
    
    
    
    
    
    
    
    
    
    
    

