//
//  ImageSketcher.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit


@available(iOS 10.0, *)
open class ImageSketcher{
    
    private let canvas: Canvas
    private var drawingInstructions = [ImageRendererContextModification]()
    private var areas = [AnyArea]()
    private var currentPiece: CanvasPiece?
    
    private var renderer: UIGraphicsImageRenderer{
        
        return UIGraphicsImageRenderer(bounds: canvas.boundingBox)
    }
    
    public enum AreasOption{
        
        case withAdditionalAreas(xMargin: CGFloat, yMargin: CGFloat)
        case withoutAdditionalAreas
        
    }
    
    public enum PieceRotation{
        
        case flip
        case rotateClockwise
        case rotateCounterClockwise
    }
    
    public init?(drawOn bounds: CGRect, option: AreasOption){
        
        switch option {
        case .withAdditionalAreas(let xMargin, let yMargin):
            guard let canvas = Canvas(bounds: bounds, xMargin: xMargin, yMargin: yMargin) else { return nil}
            self.canvas = canvas
        case .withoutAdditionalAreas:
            guard let canvas = Canvas(bounds: bounds) else { return nil}
            self.canvas = canvas
        }
        
    }
    public func resetDrawingInstructions(){
        
        drawingInstructions.removeAll()
    }
    
    public func resetAreas(){
        
        areas.removeAll()
    }
    
    public func scheduleInstruction( instruction: @escaping ImageRendererContextModification){
        drawingInstructions.append(instruction)
    }
    
    @discardableResult
    public func scheduleInstruction<Area>(with area:  Area) -> Self? where Area: OnShapeDrawable{
        
        areas.append(AnyArea(area))
        return self
        
    }
    
    
    
    
    public func getCanvasPiece(part: CanvasPart, withRotation: PieceRotation? = nil)->CanvasPiece?{
        
        var piece =  canvas.getPiece(location: part)
        
        if let withRotation = withRotation{
            
            switch withRotation {
            case .flip:
                piece?.flip()
            case .rotateClockwise:
                piece?.rotateClockwise()
            case .rotateCounterClockwise:
                piece?.rotateCounterClockwise()
            }
            
        }
        return piece
    }
    
    
    
    open func renderImage()-> UIImage? {
        
        if areas.isEmpty && drawingInstructions.isEmpty {return nil}
        
        areas.forEach { (area) in
            drawingInstructions.append(area.passShapes().getInstructions())
            
        }
        
        let image = renderer.image(actions: { (context) in
            
            
            for instruction in self.drawingInstructions{
                
                let _ = instruction(context)
            }
            
        })
        
        return image
        
    }
    
}
