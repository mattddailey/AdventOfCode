//
//  TwoDimArray.swift
//
//
//  Created by Matt Dailey on 12/26/23.
//

import Foundation

public struct TwoDimensionalGrid {
  public let value: [[Character]]
  
  var xRange: ClosedRange<Int> {
    guard let first = value.first else {
      return 0...0
    }
    
    return 0...first.count
  }
  
  var yRange: ClosedRange<Int> {
    0...value.count
  }
  
  public init(_ input: String) {
    self.value = input.components(separatedBy: .newlines)
      .map(\.asArray)
  }
  
  public func contains(coordinates: TwoDimensionalCoordinates) -> Bool {
    xRange ~= coordinates.x && yRange ~= coordinates.y
  }
}
