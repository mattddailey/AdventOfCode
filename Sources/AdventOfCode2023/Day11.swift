//
//  Day11.swift
//
//
//  Created by Matt Dailey on 12/11/23.
//

import ArgumentParser
import AdventOfCodeShared
import Foundation

struct Day11: AdventOfCodeDay, AsyncParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Advent of Code - December 11, 2023 - ")
  
  func run() async throws {
    print("Part 1: \(try part1(""))")
    print("Part 2: \(try part2(""))")
  }
 
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
