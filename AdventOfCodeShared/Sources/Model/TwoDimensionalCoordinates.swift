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
