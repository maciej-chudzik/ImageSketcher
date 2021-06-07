//
//  Protocols.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics


@available(iOS 10.0, *)
public typealias ImageRendererContextModification = (UIGraphicsImageRendererContext) -> UIGraphicsImageRendererContext


public protocol AdjustableSize{
    
    func adjustSize(newSize: CGFloat)
 
}


@available(iOS 10.0, *)
public protocol Drawable{
    
   func draw(mode: DrawingMode) -> ImageRendererContextModification
 
}

@available(iOS 10.0, *)
public protocol DrawableRepresentable:AnyObject, Drawable{
    
    
    var drawableRepresentation: [Drawable]{get}
    var areaSource: AreaSource? {get set}

    
}

@available(iOS 10.0, *)
extension DrawableRepresentable{
    
    public func draw(mode: DrawingMode) -> ImageRendererContextModification {
        
        return {[weak self]
            (context) in
            
            if let self = self{
                
                for drawable in self.drawableRepresentation{
                    
                    let _ = drawable.draw(mode: mode)(context)
                }
                
            }
            
            return context
        }
        
    }
    
}

public protocol AreaSource: AnyObject{
    func getArea()-> CGRect
}

public protocol RectCalculatable{
    
    var boundingBox:CGRect {get set}
}

public protocol OrientationChangable : RectCalculatable  {

    mutating func flip()
    mutating func rotateClockwise()
    mutating func rotateCounterClockwise()
    
    
}

extension OrientationChangable{
    
    
    
    public mutating func flip() -> (){
        
        boundingBox.rotateOrigin(to: .opposite)
    }
    
    public mutating func rotateClockwise() -> (){
        
        boundingBox.rotateOrigin(to: .neighbouringClockwise)
    }
    
    public mutating func rotateCounterClockwise() -> (){
        
        boundingBox.rotateOrigin(to: .neighbouringCounterClockwise)
    }
    
}


@available(iOS 10.0, *)
public protocol OnShapeDrawable {
    associatedtype DrawableShape: Drawable
    func onDrawShape(shape: DrawableShape, mode: DrawingMode)
    func removeLastShape() ->  (shape: DrawableShape, mode: DrawingMode)?
    func removeAllShapes()
    var drawableShapes: [(shape: DrawableShape, mode: DrawingMode)] {get}
    var piece: CanvasPiece {get set}
    
}


@available(iOS 10.0, *)
public protocol AreaOrientationChangable : OnShapeDrawable  {
    
    
    mutating func flip()
    mutating func rotateClockwise()
    mutating func rotateCounterClockwise()
    
}

@available(iOS 10.0, *)
extension AreaOrientationChangable{
    
    public mutating func flip(){
        
        piece.boundingBox.rotateOrigin(to: .opposite)
    }
    
    public mutating func rotateClockwise(){
        
        piece.boundingBox.rotateOrigin(to: .neighbouringClockwise)
    }
    
    public mutating func rotateCounterClockwise(){
        
        piece.boundingBox.rotateOrigin(to: .neighbouringCounterClockwise)
    }
    
}

