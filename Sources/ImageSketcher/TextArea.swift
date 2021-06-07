//
//  TextArea.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import CoreGraphics

@available(iOS 10.0, *)
public class TextArea: BasicArea<Text>{
    
    public func drawText(text: String, mode: DrawingMode, centerVertically: Bool = false) -> TextArea?{
        
        let text = Text(in: piece.boundingBox, text: NSString(string: text))
        
        if centerVertically{
            text.centerVerticallyIfNeeded()
        }
        
        onDrawShape(shape: text, mode: mode)
        
        
        return self
        
    }
    
    public func getLastText() -> Text?{
        
        return getLastDrawable()
    }
    
    public func setNewFontSize(size: CGFloat){
        
        adjustSizeToLastDrawable(size: size)
    }
    
}
