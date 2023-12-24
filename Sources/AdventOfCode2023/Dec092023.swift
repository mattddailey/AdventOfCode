//
//  Dec092023.swift
//
//
//  Created by Matt Dailey on 12/09/23.
//

import Algorithms
import ArgumentParser
import AdventOfCodeShared
import AOCDay
import Foundation

@AOCDay(name: "Mirage Maintenance")
struct Dec092023: AdventOfCodeDay, AsyncParsableCommand {
  func part1(_ input: String) throws -> CustomStringConvertible {
    input
      .components(separatedBy: .newlines)
      .map { $0.components(separatedBy: .whitespaces).compactMap { Int($0) } }
      .map(nextValue)
      .reduce(0, +)
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    input
      .components(separatedBy: .newlines)
      .map { $0.components(separatedBy: .whitespaces).compactMap { Int($0) } }
      .map { $0.reversed() }
      .map(nextValue)
      .reduce(0, +)
  }
  
  private func nextValue(ofSequence sequence: [Int]) -> Int {
    guard !sequence.allSatisfy({ $0 == 0 }) else {
      return 0
    }
    
    return sequence.last! + nextValue(
      ofSequence: sequence
        .windows(ofCount: 2)
        .map { $0.last! - $0.first! }
      )
  }
}
  
