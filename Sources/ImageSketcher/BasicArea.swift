//
//  BasicArea.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import CoreGraphics

@available(iOS 10.0, *)
open class BasicArea<Shape:Drawable & RectCalculatable>: OnShapeDrawable{

    public var piece: CanvasPiece
    public var drawableShapes:[(shape: Shape, mode: DrawingMode)] {return internalShapes}
    var internalShapes = [(shape: Shape, mode: DrawingMode)]()

    public init(area: CanvasPiece){
        self.piece = area
    }
    
    @discardableResult
    public func removeLastShape() ->  (shape: Shape, mode: DrawingMode)?{
       return internalShapes.popLast()
    }
    
    public func removeAllShapes(){
        
        internalShapes.removeAll()
    }

    
    public func onDrawShape(shape: Shape, mode: DrawingMode){
        
        internalShapes.append((shape, mode))

    }
    
    public func adjustSizeToLastDrawable(size: CGFloat) where Shape: AdjustableSize{
        internalShapes[internalShapes.endIndex-1].shape.adjustSize(newSize: size)
        
    }
    
    public func getLastDrawable()->Shape?{
        
        return drawableShapes.last?.shape
    }
    
    
}
