//
//  Collection+Extensions.swift
//
//
//  Created by Matt Dailey on 12/30/23.
//

import Foundation

public extension Collection where Self.Iterator.Element: RandomAccessCollection {
  // PRECONDITION: `self` must be rectangular, i.e. every row has equal size.
  func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
    guard let firstRow = self.first else { return [] }
    return firstRow.indices.map { index in
        self.map{ $0[index] }
    }
  }
}
