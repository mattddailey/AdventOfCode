//  Day05.swift
//
//
//  Created by Matt Dailey on 12/06/23.
//

import ArgumentParser
import AdventOfCodeShared
import AOCDay
import Foundation

@AOCDay(name: "Wait For It")
struct Dec062023: AdventOfCodeDay, AsyncParsableCommand {
  func part1(_ input: String) throws -> CustomStringConvertible {
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
  
  func part2(_ input: String) throws -> CustomStringConvertible {
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
