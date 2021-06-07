//
//  Canvas.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//


import CoreGraphics

struct Canvas{
    
    
    //MARK: Private Properties
    
    private (set) var pieces: Set<CanvasPiece>?
    private (set) var boundingBox: CGRect
    private (set) var noMargins = false
    
    //MARK: Inits
    
    init?(bounds: CGRect, xMargin: CGFloat, yMargin: CGFloat) {
        
        self.init(bounds: bounds)
        guard let calculatedAreas = calculateAreas(xMargin: xMargin, yMargin: yMargin) else { return nil }
        self.pieces = calculatedAreas
        noMargins = true
    }
    
    init?(bounds: CGRect) {
        
        guard bounds != CGRect.zero else {return nil}
        
        self.boundingBox = bounds
        
    }
    
    // MARK: - API
    
    func getPieces() -> Set<CanvasPiece>?{
        
        return pieces
    }
    
    func getPiece(location: CanvasPart) -> CanvasPiece?{
        
        guard let pieces = pieces else {return nil}
        guard let piece = pieces.first(where: {$0.canvasLocation == location}) else {return nil}
        
        
        return piece
        
    }
    
    
    func mergedTwoPieces(location1: CanvasPart, location2: CanvasPart) ->CGRect?{
        
        guard let pieces = pieces else {return nil}
        
        guard let piece1 = pieces.first(where: {$0.canvasLocation == location1}) else {return nil}
        guard let piece2 = pieces.first(where: {$0.canvasLocation == location2}) else {return nil}
        
        
        let location1Position = piece1.canvasLocation.rawValue
        let location2Position = piece2.canvasLocation.rawValue
        
        
        guard (abs(location1Position.column - location2Position.column) == 1) ^ (abs(location1Position.row - location2Position.row) == 1) else {return nil}
        
        return piece1.boundingBox.union(piece2.boundingBox)
    }
    
    
    mutating func recalculatePieces(xMargin: CGFloat, yMargin: CGFloat){
        
        self.pieces = nil
        self.pieces = calculateAreas(xMargin: xMargin, yMargin: yMargin)
    }
    
    //MARK: Private methods
    private func calculateAreas(xMargin: CGFloat, yMargin: CGFloat) -> Set<CanvasPiece>?{
        
        
        var temp: Set<CanvasPiece>?
        
        if xMargin > 0 && xMargin < self.boundingBox.width && yMargin > 0 && yMargin < self.boundingBox.height{
            
            temp = Set<CanvasPiece>()
            
            temp!.insert(CanvasPiece(canvasLocation: .middle, boundingBox: boundingBox.insetBy(dx: xMargin, dy: yMargin)))
            
        } else if xMargin == 0 && yMargin == 0{
            
            temp = Set<CanvasPiece>()
            temp!.insert(CanvasPiece(canvasLocation: .total, boundingBox: self.boundingBox))
            
            return temp
            
        }else{
            
            return nil
        }
        
        
        
        let firstCut = boundingBox.divided(atDistance: xMargin, from: .minXEdge)
        let secondCut = firstCut.slice.divided(atDistance: yMargin, from: .minYEdge)
        
        //left top corner
        temp!.insert(CanvasPiece(canvasLocation: .topLeftCorner, boundingBox: secondCut.slice))
        
        
        let thirdCut = secondCut.remainder.divided(atDistance: boundingBox.height - 2*yMargin, from: .minYEdge)
        
        //left
        temp!.insert(CanvasPiece(canvasLocation: .left, boundingBox: thirdCut.slice))
        
        //left bottom corner
        
        temp!.insert(CanvasPiece(canvasLocation: .bottomLeftCorner, boundingBox: thirdCut.remainder))
        
        let fourthCut = firstCut.remainder.divided(atDistance:  boundingBox.width - 2*xMargin, from: .minXEdge)
        
        let fifthCut = fourthCut.slice.divided(atDistance: yMargin, from: .minYEdge)
        
        //middle top
        temp!.insert(CanvasPiece(canvasLocation: .topMiddle, boundingBox: fifthCut.slice))
        
        let sixthCut = fifthCut.remainder.divided(atDistance: boundingBox.height - 2*yMargin, from: .minYEdge)
        
        //middle bottom
        
        temp!.insert(CanvasPiece(canvasLocation: .bottomMiddle, boundingBox: sixthCut.remainder))
        
        let seventhCut = fourthCut.remainder.divided(atDistance: yMargin, from: .minYEdge)
        
        //right top corner
        
        temp!.insert(CanvasPiece(canvasLocation: .topRightCorner, boundingBox:seventhCut.slice))
        
        
        let eightCut = seventhCut.remainder.divided(atDistance: boundingBox.height - 2*yMargin, from: .minYEdge)
        
        //right
        
        temp!.insert(CanvasPiece(canvasLocation: .right, boundingBox:eightCut.slice))
        
        //right bottom corner
        
        temp!.insert(CanvasPiece(canvasLocation: .bottomRightCorner, boundingBox: eightCut.remainder))
        
        return temp
    }
    
}
