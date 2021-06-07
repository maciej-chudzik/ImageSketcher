//
//  Node.swift
//
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation

 public class Node<T> {
    
  public var value: T
  public var next: Node?
  public weak var previous: Node?

    init(value: T) {
        self.value = value
  }
}
