//
//  DrawingMode.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

@available(iOS 10.0, *)

public enum DrawingMode{
    
    case stroke(color: UIColor, width: CGFloat)
    case strokeAndFill (strokecolor: UIColor, fillcolor: UIColor, width: CGFloat)
    case dashedStroke(strokecolor: UIColor, width: CGFloat, phase: CGFloat, pattern: [CGFloat] )
    
    public var apply: ImageRendererContextModification{
        
        switch self{
        
        case .stroke( let color, let width):
            
            return self.stroke(strokecolor: color, width: width)
            
            
        case .strokeAndFill( let strokecolor, let fillcolor, let width):
            
            return self.strokeAndFill(strokecolor: strokecolor, fillcolor: fillcolor , width: width)
            
            
        case .dashedStroke(let strokecolor, let width, let phase, let pattern):
            
            return self.dashedStroke(strokecolor: strokecolor, width: width, phase: phase, pattern: pattern)
            
        }
        
    }
    
    func stroke(strokecolor: UIColor, width: CGFloat)-> ImageRendererContextModification{
        
        return {(context) in
            
            context.cgContext.setStrokeColor(strokecolor.cgColor)
            context.cgContext.setLineWidth(width)
            
            return context}
        
    }
    
    func strokeAndFill(strokecolor: UIColor, fillcolor: UIColor ,width: CGFloat)-> ImageRendererContextModification{
        
        return {(context) in
            
            context.cgContext.setStrokeColor(strokecolor.cgColor)
            context.cgContext.setFillColor(fillcolor.cgColor)
            context.cgContext.setLineWidth(width)
            
            return context}
    }
    
    func dashedStroke(strokecolor: UIColor, width: CGFloat, phase: CGFloat, pattern: [CGFloat] )->ImageRendererContextModification{
        
        return {(context) in
            
            context.cgContext.setStrokeColor(strokecolor.cgColor)
            context.cgContext.setLineWidth(width)
            context.cgContext.setLineDash(phase: phase, lengths: pattern)
            
            return context}
    }
    
    
}
