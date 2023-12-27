//
//  TwoDimensionalCoordinates.swift
//
//
//  Created by Matt Dailey on 12/11/23.
//

import Foundation

public struct TwoDimensionalCoordinates: Hashable {
  public let x: Int
  public let y: Int
  
  public init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

public extension TwoDimensionalCoordinates {
  var perpendicularCoordinates: Set<TwoDimensionalCoordinates> {
    [
      TwoDimensionalCoordinates(x: x - 1, y: y),
      TwoDimensionalCoordinates(x: x + 1, y: y),
      TwoDimensionalCoordinates(x: x, y: y - 1),
      TwoDimensionalCoordinates(x: x, y: y + 1),
    ]
  }
  
  var diagonalCoordinates: Set<TwoDimensionalCoordinates> {
    [
      TwoDimensionalCoordinates(x: x - 1, y: y - 1),
      TwoDimensionalCoordinates(x: x + 1, y: y + 1),
      TwoDimensionalCoordinates(x: x - 1, y: y + 1),
      TwoDimensionalCoordinates(x: x + 1, y: y - 1),
    ]
  }
  
  var surroundingCoordinates: Set<TwoDimensionalCoordinates> {
    perpendicularCoordinates.union(diagonalCoordinates)
  }
}
