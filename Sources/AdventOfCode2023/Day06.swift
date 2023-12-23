//  Day05.swift
//
//
//  Created by Matt Dailey on 12/06/23.
//

import ArgumentParser
import AdventOfCodeShared
import Foundation

struct Day06: AdventOfCodeDay, AsyncParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Advent of Code - December 06, 2023 - You Give A Seed A Fertilizer")
  
  func run() async throws {
    print("Part 1: \(part1(""))")
    print("Part 2: \(part2(""))")
  }
  
  func part1(_ input: String) -> CustomStringConvertible {
    let lines = input
      .components(separatedBy: .newlines)
      .map {
        $0
          .components(separatedBy: .whitespaces)
          .compactMap { Int($0) }
      }

    return createRaces(lines)
      .map(numberOfWaysToWin)
      .reduce(1, *)
  }
  
  func part2(_ input: String) -> CustomStringConvertible {
    let lines = input
      .components(separatedBy: .newlines)
      .map { $0.filter { $0.isWholeNumber } }
      .map { [$0.asInt] }
    
    return createRaces(lines)
      .map(numberOfWaysToWin)
      .reduce(1, *)
  }
  
  func createRaces(_ lines: [[Int]]) -> [Race] {
    var races: [Race] = []
    
    guard 
      let times = lines.first,
      let distances = lines.last,
      times.count == distances.count
    else {
      return []
    }
    
    for (index, time) in times.enumerated() {
      races.append(Race(time: time, distance: distances[index]))
    }
    
    return races
  }
  
  func numberOfWaysToWin(race: Race) -> Int {
    var waysToWin: Int = 0
    
    for throttleTime in 0..<race.time {
      let speed = throttleTime
      let travelTime = race.time - throttleTime
      let distanceTraveled = speed * travelTime
      
      if distanceTraveled > race.distance {
        waysToWin += 1
      }
    }
    
    return waysToWin
  }
}

struct Race {
  let time: Int
  let distance: Int
}
