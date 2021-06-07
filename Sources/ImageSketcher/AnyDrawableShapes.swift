//
//  AnyDrawableShapes.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import CoreGraphics
import UIKit



@available(iOS 10.0, *)
struct AnyDrawableShapes{
    
    let drawableShapes: [(shape: Drawable, mode: DrawingMode)]
    
    init(_ drawableShapes: [(Drawable,DrawingMode )]) {
        self.drawableShapes = drawableShapes
    }
    
    
    func getInstructions() -> ImageRendererContextModification{
        
        return {(context) in
            
            var oldContext = context
            
            for shape in drawableShapes{
                
                let newContext =  shape.shape.draw(mode: shape.mode)(oldContext)
                
                oldContext = newContext
            }
            
            return context}
    }
    
    
    
}

