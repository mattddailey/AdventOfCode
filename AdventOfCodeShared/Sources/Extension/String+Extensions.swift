//
//  String+Extensions.swift
//
//
//  Created by Matt Dailey on 12/4/23.
//

import Foundation

public extension String {
  var asArray: [Character] {
    self.map { $0 }
  }
  
  var asInt: Int {
    Int(
      self.replacingOccurrences(
        of: "[^0-9]+",
        with: "",
        options: .regularExpression
      )
    ) ?? 0
  }
}

public extension String {
  var length: Int {
      return count
  }
  
  subscript (i: Int) -> String {
    self[i ..< i + 1]
  }
  
  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                        upper: min(length, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }
}
