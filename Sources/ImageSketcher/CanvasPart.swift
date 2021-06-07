//
//  CanvasPart.swift
//  ImageSketcher
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation

public enum CanvasPart{
    
    case total
    case topLeftCorner
    case left
    case bottomLeftCorner
    case topMiddle
    case middle
    case bottomMiddle
    case topRightCorner
    case right
    case bottomRightCorner
    
    
}

extension CanvasPart: RawRepresentable{
    
    public typealias RawValue = (row: Int, column: Int)
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case (row: 0, column: 0): self = .total
        case (row: 1, column: 0): self = .topLeftCorner
        case (row: 2, column: 0): self = .left
        case (row: 3, column: 0): self = .bottomLeftCorner
        case (row: 1, column: 2): self = .topMiddle
        case (row: 2, column: 2): self = .middle
        case (row: 3, column: 2): self = .bottomMiddle
        case (row: 1, column: 3): self = .topRightCorner
        case (row: 2, column: 3): self = .right
        case (row: 3, column: 3): self = .bottomRightCorner
            
        case (_, _):
            return nil
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .total : return (row: 0, column: 0)
        case .topLeftCorner : return (row: 1, column: 0)
        case .left : return (row: 2, column: 0)
        case .bottomLeftCorner : return (row: 3, column: 0)
        case .topMiddle : return (row: 1, column: 2)
        case .middle : return (row: 2, column: 2)
        case .bottomMiddle : return (row: 3, column: 2)
        case .topRightCorner : return (row: 1, column: 3)
        case .right : return (row: 2, column: 3)
        case .bottomRightCorner : return (row: 3, column: 3)
        }
    }
    
    
    
}
