//
//  LinkedList.swift
//
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation

public class LinkedList<T> {

    private var head: Node<T>?
    
    public var last: Node<T>? {
        guard var node = head else {
          return nil
        }
      
        while let next = node.next {
          node = next
        }
        return node
    }
    
    
    public var count: Int {
        guard var node = head else {
          return 0
        }
      
        var count = 1
        while let next = node.next {
          node = next
          count += 1
        }
        return count
      }

    public var isEmpty: Bool {
        return head == nil
      }
    
    public init(){
        
        self.head = nil
    }
    
    public init(elements: [T]){
        for element in elements{
            
            self.append(value: element)
        }
        
    }
    
    public func modifyBackwards(modification: (T) -> ()){
    
            var countDown = self.count
            
            while countDown > 0 {
                
                let element = self[countDown - 1]
                
                modification(element.value)
            
                countDown -= 1
            }
            

    }
    
    public func append(value: T) {
        let newNode = Node(value: value)
        if let lastNode = last {
          newNode.previous = lastNode
          lastNode.next = newNode
        } else {
          head = newNode
        }
      }
    
    public func node(atIndex index: Int) -> Node<T> {
        if index == 0 {
            return head!
        } else {
            var node = head!.next
            for _ in 1..<index {
                node = node?.next
                if node == nil {
                    break
                }
            }
            return node!
        }
    }
    
    public func insert(value: T, atIndex index: Int) {
       let newNode = Node(value: value)
       if index == 0 {
           newNode.next = head
           head?.previous = newNode
           head = newNode
       } else {
           let previousNode = self.node(atIndex: index-1)
           let nextNode = previousNode.next

           newNode.previous = previousNode
           newNode.next = nextNode
        
           previousNode.next = newNode
           nextNode?.previous = newNode
       }
    }
    
    public func remove(node: Node<T>) -> T {
        let previousNode = node.previous
        let nextNode = node.next

        if let previousNode = previousNode {
            previousNode.next = nextNode
        } else {
            head = nextNode
        }
        nextNode?.previous = previousNode

        node.previous = nil
        node.next = nil
        return node.value
    }
    public func removeAt(_ index: Int) -> T {
        let nodeToRemove = node(atIndex: index)
        return remove(node: nodeToRemove)
    }
    
    
}

extension LinkedList: Sequence{
    
    public typealias Iterator = LinkedListIterator<T>

    public typealias Element = Node<T>
    

    
    public func makeIterator() -> LinkedListIterator<T> {
        return LinkedListIterator(currentNode: self.head)
       }
   
}

 public struct LinkedListIterator<T>: IteratorProtocol {

    var currentNode: Node<T>?

    public mutating func next() -> Node<T>? {
        
        var temp: Node<T>?
    
        temp =  currentNode
            
        currentNode = currentNode?.next
        
        return temp
        
    
    }
    
}

extension LinkedList: Collection{

    public var startIndex: Int { return 0 }
    public var endIndex: Int { return self.count - 1 }
    
    public func index(after i: Int) -> Int {
    precondition(i >= startIndex && i < endIndex, "Index out of bounds")
        return i+1
    }
    
    public subscript(position: Int) -> Element {
        precondition((startIndex...endIndex).contains(position), "Index out of bounds")

        if position == 0 {
            return head!
        } else {
            var node = head!.next
            for _ in 1..<position {
                node = node?.next
                if node == nil {
                    break
                }
            }
            return node!
        }
        
        
        
    }
}
