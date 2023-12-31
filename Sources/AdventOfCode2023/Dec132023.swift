//
//  Dec132023.swift
//
//
//  Created by Matt Dailey on 12/31/23.
//

import ArgumentParser
import AdventOfCodeShared
import AOCDay
import Foundation

@AOCDay(name: "Point of Incidence")
struct Dec132023: AdventOfCodeDay, AsyncParsableCommand {
  func part1(_ input: String) throws -> CustomStringConvertible {
    input
      .components(separatedBy: "\n\n")
      .map { $0.components(separatedBy: .newlines) }
      .map { score(of: $0) }
      .reduce(0, +)
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    input
      .components(separatedBy: "\n\n")
      .map { $0.components(separatedBy: .newlines) }
      .map { score(of: $0, hasSmudge: true) }
      .reduce(0, +)
  }
  
  private func score(of map: [String], hasSmudge: Bool = false) -> Int {
    // look for horizontal reflection
    if let horizontalLineOfReflection = lineOfReflection(in: map, hasSmudge: hasSmudge) {
      return 100 * horizontalLineOfReflection
    }
    
    // look for veritical line of reflection
    let transposedMap = map
      .map(Array.init)
      .transposed()
      .map { String($0) }
    
    if let verticalLineOfReflection = lineOfReflection(in: transposedMap, hasSmudge: hasSmudge) {
      return verticalLineOfReflection
    }
    
    fatalError("Unable to find line of reflection")
  }
    
  private func lineOfReflection(in map: [String], hasSmudge: Bool) -> Int? {
    var map = map
    let mutableMapAsTwoDimArray = map.map(Array.init)
    
    if hasSmudge {
      var originalLineOfReflection: Int?
      for index in 1..<map.count {
        let reflectionLength = min(index, map.count - index)
        let first = map[(index-reflectionLength)..<index]
        let second = map[index..<(index+reflectionLength)].reversed()
        
        if Array(first) == Array(second) {
          originalLineOfReflection = index
        }
      }
      
      for (y, row) in map.enumerated() {
        for (x, _ ) in row.enumerated() {
          var modifiedMap = mutableMapAsTwoDimArray
          modifiedMap[y][x] = modifiedMap[y][x] == "#" ? "." : "#"
          map = modifiedMap.map { String($0) }
          
          for index in 1..<map.count {
            let reflectionLength = min(index, map.count - index)
            let first = map[(index-reflectionLength)..<index]
            let second = map[index..<(index+reflectionLength)].reversed()
            
            if Array(first) == Array(second), index != originalLineOfReflection {
              return index
            }
          }
        }
      }
    } else {
      for index in 1..<map.count {
        let reflectionLength = min(index, map.count - index)
        let first = map[(index-reflectionLength)..<index]
        let second = map[index..<(index+reflectionLength)].reversed()
        
        if Array(first) == Array(second) {
          return index
        }
      }
    }

    return nil
  }
}
