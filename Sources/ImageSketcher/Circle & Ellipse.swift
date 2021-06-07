//
//  Circle & Ellipse.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import CoreGraphics

final public class Circle: Ellipse{
    
    public let radius: CGFloat
    
    public init?(radius: CGFloat, center: CGPoint){
        
        guard radius > 0 && center != CGPoint.zero else {return nil}
        self.radius = radius
        super.init(XHalfAxisLength: radius, YHalfAxisLength: radius, center: center)
        
        
    }

    public func findPointOnCircle(angle: CGFloat) -> CGPoint{
        
        return CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
    }
}


public class Ellipse{
    
    public let XHalfAxisLength: CGFloat
    public let YHalfAxisLength: CGFloat
    public let center: CGPoint
    
    
    public init?(XHalfAxisLength: CGFloat, YHalfAxisLength: CGFloat, center: CGPoint){
        
        guard  XHalfAxisLength > 0 && YHalfAxisLength > 0 else {return nil}
        
        self.XHalfAxisLength = XHalfAxisLength
        self.YHalfAxisLength = YHalfAxisLength
        self.center = center
        
    }
    
}

@available(iOS 10.0, *)
extension Ellipse: Drawable{
    
    public func draw(mode: DrawingMode) -> ImageRendererContextModification {
        
        return {(context) in
            
            context.cgContext.saveGState()
            
            let _ =  mode.apply(context)
            
            let areaOfEllipse = CGRect(origin: CGPoint(x: self.center.x - self.YHalfAxisLength, y: self.center.y - self.XHalfAxisLength), size: CGSize(width: self.YHalfAxisLength*2, height: self.XHalfAxisLength*2))
            
            context.cgContext.addEllipse(in: areaOfEllipse)
            
            switch mode {
            case .stroke(_, _):
                context.cgContext.drawPath(using: .stroke)
            case .strokeAndFill(_, _, _):
                context.cgContext.drawPath(using: .fillStroke)
            case .dashedStroke(strokecolor: _, width: _, phase: _, pattern: _):
                context.cgContext.drawPath(using: .stroke)
            }
            
            context.cgContext.restoreGState()
            
            return context}
    }
    
    
    
}
