//
//  LinkedList.swift
//
//
//  Created by Matt Dailey on 12/7/23.
//

import Foundation

public class LinkedList<Value> {

  public var head: Node<Value>?
  public var tail: Node<Value>?
  
  public init() {}

  var isEmpty: Bool {
    head == nil
  }
  
  public func push(_ value: Value) {
    head = Node(value: value, next: head)
    if tail == nil {
      tail = head
    }
  }
  
  public func append(_ value: Value) {
    guard !isEmpty else {
      push(value)
      return
    }

    tail?.next = Node(value: value)
    tail = tail?.next
  }
}
