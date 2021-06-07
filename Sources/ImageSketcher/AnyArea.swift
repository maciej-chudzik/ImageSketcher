//
//  AnyArea.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation

@available(iOS 10.0, *)
struct AnyArea{
    
    let passShapes: () -> AnyDrawableShapes
    
    init<T: OnShapeDrawable>(_ area: T)  {
        
        self.passShapes = {return AnyDrawableShapes(area.drawableShapes)}
        
    }
    
}
