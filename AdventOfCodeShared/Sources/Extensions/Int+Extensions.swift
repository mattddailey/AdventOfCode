//
//  Int+Extensions.swift
//
//
//  Created by Matt Dailey on 12/8/23.
//

import Foundation

public extension Array where Element == Int {
  public var leastCommonMultiple: Int {
    self.reduce(1, leastCommonMultiple)
  }
  
  private func greatestCommonDenominator(_ a: Int, _ b: Int) -> Int {
    let r = a % b
    if r != 0 {
      return greatestCommonDenominator(b, r)
    } else {
      return b
    }
  }
  
  private func leastCommonMultiple(_ a: Int, _ b: Int) -> Int {
    return a * b / greatestCommonDenominator(a, b)
  }
}
