//
//  LineSegment.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public struct LineSegment: Hashable{
    
    public let endPointA: CGPoint
    public let endPointB: CGPoint
    
    
    public enum Endpoints{
        case A
        case B
    }
    
    var associatedLine: Line{
        
        get{
            
            return Line(point1: endPointA, point2: endPointB)
        }
        
    }
    
    var length: CGFloat{
        get{
            return endPointA.distanceToPoint(toPoint: endPointB)
        }
    }
    
    
    
    
    public init(endPointA: CGPoint, endPointB: CGPoint){
        self.endPointA = endPointA
        self.endPointB = endPointB
        
    }
    
    
    public func isAdjacent(toLineSegment lineSegment: LineSegment) -> (own: Endpoints, other: Endpoints)?{
        
        
        
        if  self.endPointA == lineSegment.endPointA {
            
            return (own: Endpoints.A, other: Endpoints.A)
            
        }else if self.endPointA == lineSegment.endPointB{
            
            return (own: Endpoints.A, other: Endpoints.B)
            
        }else if self.endPointB == lineSegment.endPointA{
            
            return (own: Endpoints.B, other: Endpoints.A)
            
        }else if self.endPointB == lineSegment.endPointB{
            
            return (own: Endpoints.B, other: Endpoints.B)
            
        }else {
            
            return nil
        }
        
        
    }
    
    public func splitInHalf() -> (firstHalf: LineSegment, secondHalf: LineSegment){
        
        let ratioOfLength: CGFloat = 0.5
        
        let middlePointX = (1 - ratioOfLength) * self.endPointA.x + ratioOfLength * self.endPointB.x
        let middlePointY = (1 - ratioOfLength) * self.endPointA.y + ratioOfLength * self.endPointB.y
        
        let firstHalf = LineSegment(endPointA: self.endPointA, endPointB: CGPoint(x: middlePointX, y: middlePointY))
        let secondHalf = LineSegment(endPointA: CGPoint(x: middlePointX, y: middlePointY), endPointB: self.endPointB)
        
        return (firstHalf: firstHalf, secondHalf: secondHalf)
        
    }
    
    public func middlePoint() -> CGPoint{
        
        let ratioOfLength: CGFloat = 0.5
        
        let middlePointX = (1 - ratioOfLength) * self.endPointA.x + ratioOfLength * self.endPointB.x
        let middlePointY = (1 - ratioOfLength) * self.endPointA.y + ratioOfLength * self.endPointB.y
        
        return CGPoint(x: middlePointX, y: middlePointY)
    }
    
    
    public func pointsProjected(points: [CGPoint], horizontally: Bool) ->[CGPoint]?{
        
        guard !points.isEmpty else {return nil}
        
        var tempPoints = [CGPoint]()
        
        
        
        for point in points{
            
            
            if horizontally{
                
                if self.endPointA.x < self.endPointB.x{
                    
                    if point.x >= self.endPointA.x &&   point.x <= self.endPointB.x{
                        
                        tempPoints.append(CGPoint(x: point.x, y: self.associatedLine.findYCoordinate(x: point.x)))
                    }
                    
                    
                }else{
                    
                    if point.x >= self.endPointB.x &&   point.x <= self.endPointA.x{
                        
                        tempPoints.append(CGPoint(x: point.x, y: self.associatedLine.findYCoordinate(x: point.x)))
                        
                    }
                    
                    
                }
                
            }else{
                
                //vertically
                
                
                if self.endPointA.y < self.endPointB.y{
                    
                    if point.y >= self.endPointA.y && point.y <= self.endPointB.y{
                        
                        
                        if let x = self.associatedLine.findXCoordinate(y: point.y){
                            
                            tempPoints.append(CGPoint(x: x , y: point.y ))
                        }else{
                            
                            tempPoints.append(CGPoint(x: self.middlePoint().x , y: point.y ))
                            
                        }
                        
                        
                        
                    }
                    
                    
                }else if self.endPointB.y < self.endPointA.y{
                    
                    if point.y >= self.endPointB.y && point.y <= self.endPointA.y{
                        
                        if let x = self.associatedLine.findXCoordinate(y: point.y){
                            
                            tempPoints.append(CGPoint(x: x , y: point.y ))
                        }else{
                            
                            tempPoints.append(CGPoint(x: self.middlePoint().x , y: point.y ))
                            
                        }
                    }
                    
                    
                }
                
            }
        }
        
        
        return tempPoints

    }
    
    public func findPointsDividing(resolution: Int, starting from: Endpoints, includeEndpoints: (A: Bool, B: Bool)) -> [CGPoint]?{
        
        guard resolution > 0 else {return nil}
        
        var tempArray = [CGPoint]()
        
        if includeEndpoints.A{
            tempArray.append(self.endPointA)
        }
        
        for i in 1...resolution - 1{
            
            let space = self.length / CGFloat(resolution)
            
            if let point = self.findPointAtDistance(distance: CGFloat(i) * space, from: from){
                tempArray.append(point)
                
            }
        }
        
        if includeEndpoints.B{
            tempArray.append(self.endPointB)
        }
        
        return tempArray
    }
    
    
    public func findPointAtDistance(distance: CGFloat, from: Endpoints) -> CGPoint?{
        
        guard distance > 0 && (distance < self.length ||  distance == self.length )else {return nil}
        
        let ratioOfLength: CGFloat = distance / self.length
        var endpoint1: CGPoint
        var endpoint2: CGPoint
        
        
        switch from {
        case .A:
            endpoint1 = endPointA
            endpoint2 = endPointB
        case .B:
            endpoint1 = endPointB
            endpoint2 = endPointA
        }
        
        let x = (1 - ratioOfLength) * endpoint1.x + ratioOfLength * endpoint2.x
        let y = (1 - ratioOfLength) * endpoint1.y + ratioOfLength * endpoint2.y
        
        return CGPoint(x: x, y: y)
    }
    
    
    public func splitAtDistanceFrom(distance: CGFloat, from: Endpoints) -> (segment: LineSegment, remaningSegment: LineSegment)?{
        
        if let point = findPointAtDistance(distance: distance, from: from){
            
            let firstHalf = LineSegment(endPointA: self.endPointA, endPointB: CGPoint(x: point.x, y: point.y))
            let secondHalf = LineSegment(endPointA: CGPoint(x: point.x, y: point.y), endPointB: self.endPointB)
            
            return (segment: firstHalf, remaningSegment: secondHalf)
        }
        
        return nil
    }
    
    
    
    
    public func adjacentLineSegment(angled angle: CGFloat, atDistance: CGFloat) ->LineSegment?{
        
        guard atDistance > 0 else {
            return nil
        }
        
        guard angle >= -360.0 &&  angle <= 360.0 else {
            return nil
        }
        
        
        let startPoint = endPointA
        let endPoint = endPointB
        
        let refAngle = atan((endPoint.y - startPoint.y) / (endPoint.x - startPoint.x)) + ((endPoint.x - startPoint.x) < 0 ? CGFloat(Double.pi) : 0)
        
        let newEndpoint = CGPoint(x: endPoint.x + atDistance * cos(CGFloat(Double.pi) - refAngle + angle.toRadians()), y: endPoint.y - atDistance * sin(CGFloat(Double.pi) - refAngle + angle.toRadians()))
        
        return LineSegment(endPointA: endPoint, endPointB: newEndpoint)
        
    }
    
    
    public func perpendicularLineSegment(atDistance: CGFloat, anchor: CGPoint) -> LineSegment?{
        
        guard atDistance > 0 else {
            return nil
        }
        
        var endpoint = CGPoint()
        var otherEndpoint = CGPoint()
        
        if anchor == endPointA{
            endpoint = anchor
            otherEndpoint =  endPointB
            
        }else if anchor == endPointB{
            endpoint = anchor
            otherEndpoint =  endPointA
            
        }else{
            endpoint = anchor
            
            otherEndpoint =  endPointA
            
        }
        
        var dx: CGFloat = endpoint.xDiff(fromPoint: otherEndpoint)
        var dy: CGFloat = endpoint.yDiff(fromPoint: otherEndpoint)
        
        
        dx /= endpoint.distanceToPoint(toPoint: otherEndpoint)
        dy /= endpoint.distanceToPoint(toPoint: otherEndpoint)
        
        
        let lx: CGFloat = endpoint.x + (atDistance/2) * dy
        let ly: CGFloat = endpoint.y - (atDistance/2) * dx
        let rx: CGFloat = endpoint.x - (atDistance/2) * dy
        let ry: CGFloat = endpoint.y + (atDistance/2) * dx
        
        return LineSegment(endPointA: CGPoint(x: lx, y: ly), endPointB: CGPoint(x: rx, y: ry))
        
    }
}

extension LineSegment: CustomDebugStringConvertible{
    
    
    public var debugDescription: String{
        
        return "endPointA: " + endPointA.debugDescription + "endPointB: " + endPointB.debugDescription
    }
    
    
}


@available(iOS 10.0, *)
extension LineSegment: Drawable{
    
    
    public func draw(mode: DrawingMode) -> ImageRendererContextModification {
        return {(context) in
            
            context.cgContext.saveGState()
            
            
            let _ =  mode.apply(context)
            
            
            context.cgContext.move(to: endPointA)
            context.cgContext.addLine(to: endPointB)
            
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
