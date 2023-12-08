//
//  Node.swift
//
//
//  Created by Matt Dailey on 12/7/23.
//

import Foundation


public class Node<Value>: Equatable {
  public static func == (lhs: Node<Value>, rhs: Node<Value>) -> Bool {
    lhs.id == rhs.id
  }
  
  public var value: Value
  var next: Node?
  var prev: Node?

  private var id = UUID()
  
  public init(value: Value, next: Node? = nil, prev: Node? = nil) {
    self.value = value
    self.next = next
    self.prev = prev
  }
}
