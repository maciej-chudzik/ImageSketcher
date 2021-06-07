//
//  PolygonalChain.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//


import Foundation
import CoreGraphics


public struct PolygonalChain{
    
    private (set) var skeleton: LinkedList<CGPoint>
    private (set) var segments: LinkedList<LineSegment>
    
    
    public init?(points: [CGPoint]){
        
        guard points.count > 1 else {return nil}
        self.skeleton = LinkedList(elements: points)
        
        let tempLineSegments = LinkedList<LineSegment>()
        
        for pointElement in LinkedList(elements: points){
            
            if pointElement.next == nil{
                break
            }
            
            let lineSegment = LineSegment(endPointA: pointElement.value, endPointB: pointElement.next!.value)
            tempLineSegments.append(value: lineSegment)
        }
        
        self.segments = tempLineSegments
    }
    
    
    
}

@available(iOS 10.0, *)
extension PolygonalChain: Drawable{
    public func draw(mode: DrawingMode) -> ImageRendererContextModification{
    
        return {(context) in
        
        for segment in segments{
        
            let _ = segment.value.draw(mode: mode)(context)
            
        }
        
          return context}
    }
}
