//
//  Direction.swift
//
//
//  Created by Matt Dailey on 12/16/23.
//

public enum Direction: CaseIterable {
  case north
  case south
  case east
  case west
  
  public var opposite: Direction {
    switch self {
    case .north:
      return .south
    case .south:
      return .north
    case .east:
      return .west
    case .west:
      return .east
    }
  }
  
  public var offset: TwoDimensionalCoordinates {
    switch self {
    case .north:
      return .init(x: 0, y: -1)
    case .south:
      return .init(x: 0, y: 1)
    case .east:
      return .init(x: 1, y: 0)
    case .west:
      return .init(x: -1, y: 0)
    }
  }
}
