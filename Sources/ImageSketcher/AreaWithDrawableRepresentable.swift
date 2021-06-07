//
//  AreaWithDrawableRepresentable.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import CoreGraphics


@available(iOS 10.0, *)
open class AreaWithDrawableRepresentable<Shape:DrawableRepresentable>: OnShapeDrawable, AreaOrientationChangable, AreaSource{
    
    
    public var piece: CanvasPiece
    public var drawableShapes:[(shape: Shape, mode: DrawingMode)] {return internalShapes}
    var internalShapes = [(shape: Shape, mode: DrawingMode)]()
    
    public init(area: CanvasPiece){
        self.piece = area
    }
    
    public func getArea() -> CGRect {
        return piece.boundingBox
    }
    
    @discardableResult
    public func removeLastShape() ->  (shape: Shape, mode: DrawingMode)?{
        return internalShapes.popLast()
    }
    
    public func removeAllShapes(){
        
        internalShapes.removeAll()
    }
    
    
    public func onDrawShape(shape: Shape, mode: DrawingMode){
        
        internalShapes.append((shape,mode))
    }
    
    
}
