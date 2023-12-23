//
//  Dec122023.swift
//
//
//  Created by Matt Dailey on 12/12/23.
//

import ArgumentParser
import AdventOfCodeShared
import AOCDay
import Foundation

@AOCDay(name: "Hot Springs")
struct Dec122023: AdventOfCodeDay, AsyncParsableCommand {
  private typealias Cache = [Row : Int]
  
  func part1(_ input: String) throws -> CustomStringConvertible {
    let rows = input
      .components(separatedBy: .newlines)
      .compactMap(row)
    
    var cache = Cache()
    
    return rows
      .map { possibleArrangements(springs: $0.springs, groups: $0.groups, cache: &cache) }
      .reduce(0, +)
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    let rows = input
      .components(separatedBy: .newlines)
      .compactMap(row)
      .map(unfold)
    
    var cache = Cache()
    
    return rows
      .map { possibleArrangements(springs: $0.springs, groups: $0.groups, cache: &cache) }
      .reduce(0, +)
  }
  
  private func row(_ line: String) -> Row? {
    let components = line.components(separatedBy: .whitespaces)
    
    return Row(
      springs: components.first?.compactMap { SpringKind(rawValue: $0) } ?? [],
      groups: components.last?.components(separatedBy: ",").map(\.asInt) ?? []
    )
  }
  
  private func unfold(_ row: Row) -> Row {
    Row(
      springs: [[SpringKind]](repeating: row.springs + [.unknown], count: 5).flatMap{ $0 }.dropLast(),
      groups: [[Int]](repeating: row.groups, count: 5).flatMap{ $0 }
    )
  }
  
  private func possibleArrangements(springs: [SpringKind], groups: [Int], cache: inout Cache) -> Int {
    guard let group = groups.first else {
      return springs.contains { $0 == .damaged } ? 0 : 1
    }
    
    guard let spring = springs.first else {
      return groups.isEmpty ? 1 : 0
    }
    
    if let count = cache[Row(springs: springs, groups: groups)] {
      return count
    }
    
    var count = 0
    
    // treat unknown as operational, move on
    if spring == .operational || spring == .unknown {
      count += possibleArrangements(springs: springs.tail, groups: groups, cache: &cache)
    }
    
    // treat unknowns & damaged (up to the group number) as damaged, and move to next group.
    if (spring == .unknown || spring == .damaged)
        && group <= springs.count
        && !springs.prefix(group).contains(.operational)
        && (group == springs.count || springs[group] != .damaged)
    {
      count += possibleArrangements(springs: Array(springs.dropFirst(group + 1)), groups: groups.tail, cache: &cache)
    }
    
    cache[Row(springs: springs, groups: groups)] = count
    return count
  }
}

fileprivate struct Row: Hashable {
  let springs: [SpringKind]
  let groups: [Int]
}

fileprivate enum SpringKind: Character {
  case operational = "."
  case damaged = "#"
  case unknown = "?"
}
