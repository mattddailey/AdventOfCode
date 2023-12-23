//  Day08.swift
//
//
//  Created by Matt Dailey on 12/08/23.
//

import ArgumentParser
import AdventOfCodeShared
import Foundation

struct Day08: AdventOfCodeDay, AsyncParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Advent of Code - December 08, 2023 - Haunted Wasteland")
  
  func run() async throws {
    print("Part 1: \(try part1(""))")
    print("Part 2: \(try part2(""))")
  }
  
  func part1(_ input: String) throws -> CustomStringConvertible {
    try processInstructions(createInstructions(input), for: createNodes(input), startingAt: "AAA", part2: false)
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    let (instructions, nodes) = (createInstructions(input), createNodes(input))
    let startingNodes = nodes.filter { $0.key.contains(/[A-Za-z0-9]+A/) }
    
    return try startingNodes
      .map { try processInstructions(instructions, for: nodes, startingAt: $0.key, part2: true) }
      .leastCommonMultiple
  }
  
  
  func createInstructions(_ input: String) -> [Bool] {
    input
      .components(separatedBy: "\n\n")
      .first
      .map { $0.map { $0 == "L" } }
    ?? []
  }
  
  private func createNodes(_ input: String) -> Nodes {
    let nodesLines = input
      .components(separatedBy: "\n\n")
      .last?
      .components(separatedBy: .newlines)
    ?? []
    
    var nodes: [String: Children] = [:]
    for nodeLine in nodesLines {
      guard let nodeMatch = nodeLine.firstMatch(of: /([A-Za-z0-9]+) = \(([A-Za-z0-9]+), ([A-Za-z0-9]+)\)/) else {
        continue
      }
      
      nodes[String(nodeMatch.1)] = Children(left: String(nodeMatch.2), right: String(nodeMatch.3))
    }
    
    return nodes
  }
  
  func processInstructions(_ instructions: [Bool], for nodes: Nodes, startingAt location: String, part2: Bool) throws -> Int {
    var location = location
    var index = 0
    var steps = 0
    
    while true {
      if !part2 {
        guard location != "ZZZ" else {
          return steps
        }
      } else {
        guard !location.contains(/[A-Za-z0-9]+Z/) else {
          return steps
        }
      }

      guard let newLocation = nodes[location] else {
        throw AdventOfCodeError("Could not map current node to a destination node")
      }
      
      location = instructions[index] ? newLocation.left : newLocation.right
      steps += 1
      
      index = if index == instructions.count - 1 {
        0
      } else {
        index + 1
      }
    }
  }

  struct Children {
    let left: String
    let right: String
  }
  
  typealias Nodes = [String: Children]
}
