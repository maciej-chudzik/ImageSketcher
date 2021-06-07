//
//  Text.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public class Text:OrientationChangable, RectCalculatable{
    
    //MARK: Stored Properties
    
    public var boundingBox: CGRect
    
    
    private var text: NSString
    private var attributes = [NSAttributedString.Key : Any]()
    private var textSize: CGFloat?
    private var fontName: String?
    private var horizontalAlignment: NSTextAlignment
    
    //MARK: Inits
    
    public init(in boundingBox: CGRect, text: NSString, horizontalAlignment: NSTextAlignment = .center, fontName: String? = nil) {
        self.boundingBox = boundingBox
        self.text = text
        self.fontName = fontName
        self.horizontalAlignment = horizontalAlignment
        
        self.setParagraphStyle()
        self.setFontWithSize()
        
    }

    //MARK: API
    
    
    public func getTextSize() -> CGFloat{
        
        return self.textSize!
    }
    
    public func getText() -> NSString{
        
        return self.text
    }
    
    public func changeCurrentFontsize(size: CGFloat){
        
        let font = attributes[NSAttributedString.Key.font] as! UIFont
    
        
        attributes[NSAttributedString.Key.font] = UIFont(descriptor: font.fontDescriptor, size: size)
        
        //CHECK IF NEEDED:
        // modifyFontSizeToFitSize(toFitIn: boundingBox.size)
    
        self.textSize = size
        
        centerVerticallyIfNeeded()
    }
    
    
    
    public func centerVerticallyIfNeeded(){
        
        let currentFont = attributes[NSAttributedString.Key.font] as! UIFont
        
        
        let currentBaseline = boundingBox.minY + currentFont.ascender;
        
        
        
        if currentBaseline - currentFont.xHeight / 2 < boundingBox.midY{
            
            attributes[NSAttributedString.Key.baselineOffset] = -(boundingBox.midY - currentBaseline + currentFont.xHeight / 2)
        }
        
        
    }
    
    public func changeHorizontalAlignment(alignment: NSTextAlignment){
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        
        paragraphStyle.alignment = alignment
        
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
    }
    
    
    
    
    //MARK: Private methods
    
    
    private func setParagraphStyle(){
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        
        paragraphStyle.alignment = self.horizontalAlignment
        
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
    }
    
    private func setFontWithSize(){
        
        
        let initialFontSize = boundingBox.height
        
        
        if let fontName = self.fontName{
            
            
            attributes[NSAttributedString.Key.font] = UIFont(name: fontName, size: initialFontSize)
            
        }else{
            
            attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: initialFontSize)
        }
        
        modifyFontSizeToFitSize(toFitIn: boundingBox.size)
        
        
        
        
    }
    
    
    
    
    private func adjustBoundingBox(){
        
        let displayedTextSize = text.size(withAttributes: attributes)
        
        if horizontalAlignment == .center{
            
            boundingBox =  boundingBox.insetBy(dx: (boundingBox.width - displayedTextSize.width) / 2, dy: (boundingBox.height - displayedTextSize.height) / 2)
            
            
        }
        
        
    }
    
    
    
    private func modifyFontSizeToFitSize(toFitIn size: CGSize){
        
        let font = attributes[NSAttributedString.Key.font] as! UIFont
        
        var fontPointSize = font.pointSize
        
        
        
        while size.height <= text.size(withAttributes: attributes).height {
            
            
            fontPointSize -= 1
            
            
            attributes[NSAttributedString.Key.font] = UIFont(descriptor: font.fontDescriptor, size: fontPointSize)
            
        }
        
        
        while size.width <= text.size(withAttributes: attributes).width {
            
            
            fontPointSize -= 1
            attributes[NSAttributedString.Key.font] = UIFont(descriptor: font.fontDescriptor, size: fontPointSize)
            
        }
        
        attributes[NSAttributedString.Key.font] = UIFont(descriptor: font.fontDescriptor, size: fontPointSize)
        
        
        textSize = fontPointSize
    }
    
    
}

extension Text: Drawable{
    
    @available(iOS 10.0, *)
    public func draw(mode: DrawingMode) -> ImageRendererContextModification{ return { [weak self](context) in
        
        context.cgContext.saveGState()
        
        if let self = self {
        
            switch mode{

            case .stroke(color: let color, width: _):

                    self.attributes[NSAttributedString.Key.strokeColor] = color
                    self.attributes[NSAttributedString.Key.backgroundColor] = UIColor.clear
                    self.attributes[NSAttributedString.Key.foregroundColor] = color

                case .strokeAndFill(strokecolor: let strokecolor, fillcolor: let fillcolor, width: let width):

                    self.attributes[NSAttributedString.Key.strokeColor] = strokecolor
                    self.attributes[NSAttributedString.Key.strokeWidth] = width
                    self.attributes[NSAttributedString.Key.backgroundColor] = UIColor.clear
                    self.attributes[NSAttributedString.Key.foregroundColor] = fillcolor

            case .dashedStroke(strokecolor:  let strokecolor, width:  let width, phase: _, pattern: _):

                    self.attributes[NSAttributedString.Key.strokeColor] = strokecolor
                    self.attributes[NSAttributedString.Key.strokeWidth] = width

            }
            
            self.text.draw(with: self.boundingBox, options: [.usesLineFragmentOrigin], attributes: self.attributes, context: nil)
            
        }
        
        context.cgContext.restoreGState()
        
        return context}
    }
    
}
    
    

extension Text:AdjustableSize{
    
    public func adjustSize(newSize: CGFloat) {
        changeCurrentFontsize(size: newSize)
    }

}

