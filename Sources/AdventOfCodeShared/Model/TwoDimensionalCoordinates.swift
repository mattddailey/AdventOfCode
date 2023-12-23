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
  var surroundingCoordinates: Set<TwoDimensionalCoordinates> {
    var surroundingCoordinates = Set<TwoDimensionalCoordinates>()
    
    for y in (self.y - 1)...(self.y + 1) {
      for x in (self.x - 1)...(self.x + 1) {
        surroundingCoordinates.insert(TwoDimensionalCoordinates(x: x, y: y))
      }
    }
    
    return surroundingCoordinates
  }
}
