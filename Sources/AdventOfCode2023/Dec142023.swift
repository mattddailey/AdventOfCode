//
//  Day14.swift
//
//
//  Created by Matt Dailey on 12/09/23.
//

import ArgumentParser
import AdventOfCodeShared
import AOCDay
import Foundation

@AOCDay(name: "Parabolic Reflector Dish")
struct Dec142023: AdventOfCodeDay, AsyncParsableCommand {
  private typealias Map = [[Character]]

  func part1(_ input: String) throws -> CustomStringConvertible {
    load(
      for: tilt(
        map: createMap(input),
        direction: .north
      )
    )
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    var map = createMap(input)
    let cycles = 1000000000
    var cache = [Map : Int]()
    
    for cycle in 1...cycles {
      map = tiltCycle(map: map)
      
      if let prevCycle = cache[map] {
        let length = cycle - prevCycle
        let remainingCycles = (cycles - cycle) % length
        
        for _ in 0..<remainingCycles {
          map = tiltCycle(map: map)
        }
        
        return load(for: map)
      }
      
      cache[map] = cycle
    }
    
    return load(for: map)
  }
  
  private func tiltCycle(map: Map) -> Map {
    let directions: [Direction] = [.north, .west, .south, .east]
    var map = map
    
    for direction in directions {
      map = tilt(map: map, direction: direction)
    }
    
    return map
  }
  
  private func createMap(_ input: String) -> Map {
    input
      .components(separatedBy: .newlines)
      .map(\.asArray)
  }
  
  private func load(for map: Map) -> Int {
    let numberOfRows = map.count
    var load = 0
    
    for (y, row) in map.enumerated() {
      let rowLoad = numberOfRows - y
      
      for location in row {
        load += location == "O" ? rowLoad : 0
      }
    }
    
    return load
  }
  
  private func tilt(map: Map, direction: Direction) -> Map {
    var map = map
    
    guard let first = map.first else {
      fatalError()
    }
    
    switch direction {
    case .north:
      for x in first.indices {
        var obstacle = -1
        for y in map.indices {
          if map[y][x] == "#" {
            obstacle = y
          } else if map[y][x] == "O" {
            map[y][x] = "."
            obstacle += 1
            map[obstacle][x] = "O"
          }
        }
      }
    case .south:
      for x in first.indices {
        var obstacle = map.count
        for y in map.indices.reversed() {
          if map[y][x] == "#" {
            obstacle = y
          } else if map[y][x] == "O" {
            map[y][x] = "."
            obstacle -= 1
            map[obstacle][x] = "O"
          }
        }
      }
    case .east:
      for y in map.indices {
        var obstacle = first.count
        for x in first.indices.reversed() {
          if map[y][x] == "#" {
            obstacle = x
          } else if map[y][x] == "O" {
            map[y][x] = "."
            obstacle -= 1
            map[y][obstacle] = "O"
          }
        }
      }
    case .west:
      for y in map.indices {
        var obstacle = -1
        for x in first.indices {
          if map[y][x] == "#" {
            obstacle = x
          } else if map[y][x] == "O" {
            map[y][x] = "."
            obstacle += 1
            map[y][obstacle] = "O"
          }
        }
      }
    }
    return map
  }
}
