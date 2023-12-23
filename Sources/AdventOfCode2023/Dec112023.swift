//
//  Day11.swift
//
//
//  Created by Matt Dailey on 12/11/23.
//

import ArgumentParser
import AdventOfCodeShared
import AOCDay
import Foundation

@AOCDay(name: "Cosmic Expansion")
struct Dec112023: AdventOfCodeDay, AsyncParsableCommand {
  func part1(_ input: String) throws -> CustomStringConvertible {
    let rows = input
      .components(separatedBy: .newlines)
  
    let galaxies = galaxyLocations(forRows: rows, multiplier: 2)
    return galaxyDistancesSum(for: galaxies)
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    let rows = input
      .components(separatedBy: .newlines)
  
    let galaxies = galaxyLocations(forRows: rows, multiplier: 1000000)
    return galaxyDistancesSum(for: galaxies)
  }
  
  func galaxyLocations(forRows rows: [String], multiplier: Int) -> [TwoDimensionalCoordinates] {
    var galaxies: [TwoDimensionalCoordinates] = []
    var yOffset = 0
    var xOffset = 0

    for (y, row) in rows.enumerated() {
      if row.firstMatch(of: /#/) == nil {
        yOffset += (multiplier - 1)
      }
      
      xOffset = 0
      for (x, value) in row.enumerated() {
        if (rows.map { $0[x] }.filter { $0 == "#" }.isEmpty) {
          xOffset += (multiplier - 1)
        }
        
        if value == "#" {
          galaxies.append(TwoDimensionalCoordinates(x: x + xOffset, y: y + yOffset))
        }
      }
    }
    
    return galaxies
  }
  
  func galaxyDistancesSum(for galaxies: [TwoDimensionalCoordinates]) -> Int {
    var distances: [Int] = []
    
    for (index, galaxyOne) in galaxies.enumerated() {
      for galaxyTwo in galaxies[index+1..<galaxies.count] {
        distances.append(galaxyOne.distance(to: galaxyTwo))
      }
    }
    
    return distances.reduce(0, +)
  }
}

fileprivate extension TwoDimensionalCoordinates {
  func distance(to coordinates: TwoDimensionalCoordinates) -> Int {
    abs(self.x - coordinates.x) + abs(self.y - coordinates.y)
  }
}
