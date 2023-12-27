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
  func part1(_ input: String) throws -> CustomStringConvertible {
    let twoDimGrid = TwoDimensionalGrid(input)
    
    guard let start = twoDimGrid.start else {
      fatalError("Unable to find start in input")
    }

    let cycleLength = cycleLength(
      twoDimGrid,
      current: start,
      last: start,
      visited: []
    )
    
    return cycleLength / 2
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    0
  }

  private func cycleLength(
    _ twoDimGrid: TwoDimensionalGrid,
    current: TwoDimensionalCoordinates,
    last: TwoDimensionalCoordinates,
    visited: Set<TwoDimensionalCoordinates>
  ) -> Int {
    if visited.contains(current) {
      // cycle found
      return visited.count
    }
    
    var visited = visited
    visited.insert(current)
    
    let neighbors = neighbors(of: current, in: twoDimGrid)
    var maxCycleLength = 0
    
    for neighbor in neighbors where neighbor != last {
      let cycleLength = cycleLength(
        twoDimGrid,
        current: neighbor,
        last: current,
        visited: visited
      )
      
      maxCycleLength = max(maxCycleLength, cycleLength)
    }
    
    return maxCycleLength 
  }
  
  private func neighbors(
    of current: TwoDimensionalCoordinates,
    in twoDimGrid: TwoDimensionalGrid
  ) -> Set<TwoDimensionalCoordinates> {
    var neighbors: Set<TwoDimensionalCoordinates> = []
    
    switch twoDimGrid.value[current.y][current.x] {
    case "S":
      neighbors = current.perpendicularCoordinates
    case "|":
      neighbors = [
        TwoDimensionalCoordinates(x: current.x, y: current.y - 1),
        TwoDimensionalCoordinates(x: current.x, y: current.y + 1)
      ]
    case "-":
      neighbors = [
        TwoDimensionalCoordinates(x: current.x - 1, y: current.y),
        TwoDimensionalCoordinates(x: current.x + 1, y: current.y)
      ]
    case "L":
      neighbors = [
        TwoDimensionalCoordinates(x: current.x + 1, y: current.y),
        TwoDimensionalCoordinates(x: current.x, y: current.y - 1)
      ]
    case "J":
      neighbors = [
        TwoDimensionalCoordinates(x: current.x - 1, y: current.y),
        TwoDimensionalCoordinates(x: current.x, y: current.y - 1)
      ]
    case "7":
      neighbors = [
        TwoDimensionalCoordinates(x: current.x - 1, y: current.y),
        TwoDimensionalCoordinates(x: current.x, y: current.y + 1)
      ]
    case "F":
      neighbors = [
        TwoDimensionalCoordinates(x: current.x + 1, y: current.y),
        TwoDimensionalCoordinates(x: current.x, y: current.y + 1)
      ]
    default:
      break
    }
    
    return neighbors
      .filter { twoDimGrid.contains(coordinates: $0) }
      .filter { twoDimGrid.value[$0.y][$0.x] != "." }
  }
}

fileprivate extension TwoDimensionalGrid {
  var start: TwoDimensionalCoordinates? {
    guard let y = value.firstIndex(where: { !$0.filter({ $0 == "S" }).isEmpty }) else {
      return nil
    }
    
    guard let x = value[y].firstIndex(where: { $0 == "S" }) else {
      return nil
    }
    
    return TwoDimensionalCoordinates(x: x, y: y)
  }
}
  
