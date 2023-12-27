//
//  Dec102023.swift
//
//
//  Created by Matt Dailey on 12/09/23.
//

import ArgumentParser
import AdventOfCodeShared
import AOCDay
import Foundation

@AOCDay(name: "Name")
struct Dec102023: AdventOfCodeDay, AsyncParsableCommand {
  typealias Map = [[Character]]
  
  private var directions: [Character: Set<Direction>] {
    [
      "|": [.north, .south],
      "-": [.east, .west],
      "L": [.north, .east],
      "J": [.north, .west],
      "7": [.south, .west],
      "F": [.south, .east]
    ]
  }
  
  func part1(_ input: String) throws -> CustomStringConvertible {
    let map = input.asTwoDimArray
    let startCoordinates = startCoordinates(forMap: map)
    
    let adjustedMap = mapWithStartPipeReplaced(
      originalMap: map,
      startCoordinates: startCoordinates
    )
    
    guard let startingDirection = (directions[adjustedMap[startCoordinates.y][startCoordinates.x]] ?? []).first else {
      fatalError("Unable to determine starting location")
    }
    
    return determineLoop(
      from: startCoordinates,
      withStartingDirection: startingDirection,
      for: adjustedMap
    ).count / 2
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    let map = input.asTwoDimArray
    let startCoordinates = startCoordinates(forMap: map)
    
    let adjustedMap = mapWithStartPipeReplaced(
      originalMap: map,
      startCoordinates: startCoordinates
    )
    
    guard let startingDirection = (directions[adjustedMap[startCoordinates.y][startCoordinates.x]] ?? []).first else {
      fatalError("Unable to determine starting location")
    }
    
    let loop = determineLoop(
      from: startCoordinates,
      withStartingDirection: startingDirection,
      for: adjustedMap
    )
    
    return enclosedPoints(
      by: loop,
      in: adjustedMap
    )
  }
  
  private func enclosedPoints(
    by loop: Set<TwoDimensionalCoordinates>,
    in map: Map
  ) -> Int {
    var count = 0
    
    for (y, row) in map.enumerated() {
      var edgeCount = 0
      for (x, _) in row.enumerated() {
        if 
          loop.contains(.init(x: x, y: y))
        {
          if "|JL".contains(map[y][x]) {
            // point is IN loop; increment edgeCount, only for pipes that go north
            edgeCount += 1
          }
        } else if edgeCount % 2 != 0 {
          // even odd theory
          count += 1
        }
      }
    }
    
    return count
  }
  
  private func startCoordinates(forMap map: Map) -> TwoDimensionalCoordinates {
    for (y, row) in map.enumerated() {
      for (x, char) in row.enumerated() {
        if char == "S" {
          return TwoDimensionalCoordinates(x: x, y: y)
        }
      }
    }
    
    fatalError("Did not find S in map")
  }
  
  private func mapWithStartPipeReplaced(
    originalMap map: Map,
    startCoordinates: TwoDimensionalCoordinates
  ) -> Map {
    var map = map
    
    let startDirections = Direction.allCases
      .filter { move in
        let nextCoordinates = startCoordinates + move.offset
        
        guard nextCoordinates.x >= 0, nextCoordinates.y >= 0 else {
          return false
        }
        
        let nextValue = map[nextCoordinates.y][nextCoordinates.x]
        
        return (directions[nextValue] ?? [])
          .map { $0.opposite }
          .contains { $0 == move }
      }
    
    if let startPipe = directions.first(where: { $0.value == Set(startDirections) }) {
      map[startCoordinates.y][startCoordinates.x] = startPipe.key
    }

    return map
  }
  
  private func nextDirection(
    for character: Character,
    fromDirection lastDirection: Direction
  ) -> Direction {
    switch character {
    case "|":
      return lastDirection == .south ? .north : .south
    default:
      fatalError("Encountered unexpected characeter while trying to determine next direction")
    }
  }
  
  private func determineLoop(
    from startCoordinates: TwoDimensionalCoordinates,
    withStartingDirection startingDirection: Direction,
    for map: Map
  ) -> Set<TwoDimensionalCoordinates> {
    var current = startCoordinates
    var direction = startingDirection
    var loop = Set<TwoDimensionalCoordinates>()
    
    repeat {
      loop.insert(current)
      current = current.moved(direction: direction)
      direction = directions[map[current.y][current.x]]!
        .symmetricDifference([direction.opposite])
        .first!
    } while current != startCoordinates
    
    
    return loop
  }
}
  
