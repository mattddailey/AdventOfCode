//
//  Day03.swift
//
//
//  Created by Matt Dailey on 12/03/23.
//

import ArgumentParser
import AdventOfCodeShared
import Foundation

struct Day03: AdventOfCodeDay, AsyncParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Advent of Code - December 03, 2023 - ")
  
  func run() async throws {
    print("Part 1: \(try part1(""))")
    print("Part 2: \(try part2(""))")
  }
 
  func part1(_ input: String) throws -> CustomStringConvertible {
    ""
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    ""
  }
}
