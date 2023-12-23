//  Day05.swift
//
//
//  Created by Matt Dailey on 12/05/23.
//

import ArgumentParser
import AdventOfCodeShared
import AOCDay
import Foundation

@AOCDay(name: "You Give A Seed A Fertilizer")
struct Dec052023: AdventOfCodeDay, AsyncParsableCommand {
  func part1(_ input: String) throws -> CustomStringConvertible {
    let almanac = createAlmanac(input)
    return determineLowestLocation(for: almanac)
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    let almanac = createAlmanac(input, part2: true)
    return determineLowestLocation(for: almanac)
  }
  
  private func determineLowestLocation(for almanac: Almanac) -> Int {
    var lowestLocation = Int.max
    
    for seed in almanac.seeds {
      for seedLocation in seed.start..<seed.end {
        var temp = seedLocation
        
        for maps in almanac.maps {
          for map in maps {
            if (map.sourceRange).contains(temp) {
              temp = map.destinationStart + map.sourceOffset(from: temp)
              break
            }
          }
        }
        
        lowestLocation = min(temp, lowestLocation)
      }
    }
    
    return lowestLocation
  }
  
  private func createAlmanac(_ input: String, part2: Bool = false) -> Almanac {
    let almanacComponents = input.components(separatedBy: "\n\n")
    let seeds = createSeeds(almanacComponents, part2: part2)
    
    let maps = almanacComponents
      .dropFirst()
      .array
      .map(createMaps)
    
    return Almanac(seeds: seeds, maps: maps)
  }
  
  private func createSeeds(_ input: [String], part2: Bool = false) -> [Seed] {
    let seedsArray = input
      .first?
      .components(separatedBy: .whitespaces)
      .dropFirst()
      .map(\.asInt)
    
    guard let seedsArray else {
      return []
    }
    
    if !part2 {
      return seedsArray.map { Seed(start: $0, end: $0+1) }
    } else {
      var seeds: [Seed] = []
      for (index, seed) in seedsArray.enumerated() {
        guard index % 2 == 0 else {
          continue
        }
        
        seeds.append(
          Seed(start: seed, end: seed + seedsArray[index+1])
        )
      }

      return seeds
    }
  }
  
  private func createMaps(_ input: String) -> [Map] {
    input
      .components(separatedBy: .newlines)
      .dropFirst()
      .array
      .compactMap(createMap)
  }
    
  private func createMap(_ input: String) -> Map? {
    let mapComponents = input
      .components(separatedBy: .whitespaces)
      .map(\.asInt)
    
    guard mapComponents.count == 3 else {
      return nil
    }
    
    return Map(
      destinationStart: mapComponents[0],
      sourceStart: mapComponents[1],
      range: mapComponents[2]
    )
  }
}

extension ArraySlice<String>.SubSequence {
  var array: [Element] {
    Array(self)
  }
}

fileprivate struct Almanac {
  let seeds: [Seed]
  let maps: [[Map]]
}

fileprivate struct Seed {
  let start: Int
  let end: Int
}

fileprivate struct Map {
  let destinationStart: Int
  let sourceStart: Int
  let range: Int
  
  var sourceRange: ClosedRange<Int> {
    (sourceStart...sourceStart+range)
  }
  
  func sourceOffset(from seed: Int) -> Int {
    seed - sourceStart
  }
}
