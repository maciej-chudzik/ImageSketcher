//
//  CanvasPiece.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import CoreGraphics

public struct CanvasPiece: Hashable{
    
    let canvasLocation: CanvasPart
    public var boundingBox: CGRect

}

extension CanvasPiece: OrientationChangable{
    
}
