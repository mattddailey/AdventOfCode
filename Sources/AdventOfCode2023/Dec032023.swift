//
//  Day03.swift
//
//
//  Created by Matt Dailey on 12/03/23.
//

import ArgumentParser
import AdventOfCodeShared
import AOCDay
import Foundation

@AOCDay(name: "Gear Ratios")
struct Dec032023: AdventOfCodeDay, AsyncParsableCommand {
  func part1(_ input: String) throws -> CustomStringConvertible {
    let map = input.asTwoDimArray
    let (potentialParts, symbols) = findPartsAndSymbols(in: map)
    
    return potentialParts
      .filter { isActualPart($0, symbols: symbols) }
      .map(\.number)
      .reduce(0, +)
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    let map = input.asTwoDimArray
    let (potentialParts, symbols) = findPartsAndSymbols(in: map)
    
    return symbols
      .filter { $0.character == "*" }
      .compactMap { partsAdjacentTo($0, parts: potentialParts) }
      .filter { $0.count == 2 }
      .map { $0.reduce(1, *) }
      .reduce(0, +)
  }
  
  private func findPartsAndSymbols(in map: [[Character]]) -> (Set<Part>, Set<Symbol>) {
    var parts = Set<Part>()
    var symbols = Set<Symbol>()
    var tempString = ""
    var tempLocations = Set<TwoDimensionalCoordinates>()
    
    for (y, row) in map.enumerated() {
      for (x, char) in row.enumerated() {
        if char.isWholeNumber {
          tempString += String(char)
          tempLocations.insert(TwoDimensionalCoordinates(x: x, y: y))
          
          if x == row.count - 1 || String(row[x + 1]).contains(/[^0-9]/) {
            parts.insert(
              Part(
                number: Int(tempString) ?? 0,
                location: tempLocations
              )
            )
            
            tempString = ""
            tempLocations = []
          }
        } else if String(row[x]).contains(/[^.]/) {
          symbols.insert(
            Symbol(
              character: char,
              location: TwoDimensionalCoordinates(x: x, y: y)
            )
          )
        }
      }
    }
    
    return (parts, symbols)
  }
  
  private func isActualPart(_ part: Part, symbols: Set<Symbol>) -> Bool {
    !part.location
      .filter { !$0.surroundingCoordinates.intersection(symbols.map(\.location)).isEmpty }
      .isEmpty
  }
  
  private func partsAdjacentTo(_ symbol: Symbol, parts: Set<Part>) -> [Int]? {
    parts
      .filter { !$0.location.intersection(symbol.location.surroundingCoordinates).isEmpty }
      .map(\.number)
  }
}

fileprivate struct Part: Hashable {
  let number: Int
  let location: Set<TwoDimensionalCoordinates>
}

fileprivate struct Symbol: Hashable {
  let character: Character
  let location: TwoDimensionalCoordinates
}
