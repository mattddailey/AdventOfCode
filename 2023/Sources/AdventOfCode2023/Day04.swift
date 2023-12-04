//  Day04.swift
//
//
//  Created by Matt Dailey on 11/30/23.
//

import ArgumentParser
import Foundation

struct Day04: AOCDay, AsyncParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Advent of Code - December 04, 2023 - Scratchcards")
  
  func run() async throws {
    print("Part 1: \(part1(""))")
    print("Part 2: \(part2(""))")
  }
  
  func part1(_ input: String) -> CustomStringConvertible {
    input
      .components(separatedBy: .newlines)
      .compactMap(asCard)
      .map(determineScore)
      .reduce(0, +)
  }
  
  func part2(_ input: String) -> CustomStringConvertible {
    let cards = input
      .components(separatedBy: .newlines)
      .compactMap(asCard)
    
    var cardCounts = [Int](repeating: 0, count: cards.count)
    
    for (index, card) in cards.enumerated() {
      cardCounts[index] += 1
      
      for _ in 0..<cardCounts[index] {
        let numberOfWinners = numberOfWinners(card)
        
        guard numberOfWinners >= 1 else {
          break
        }
        
        for offset in 1...numberOfWinners {
          let copyIndex = index+offset
          
          guard copyIndex < cards.count else {
            break
          }
          
          cardCounts[index+offset] += 1
        }
      }
    }
    
    return cardCounts.reduce(0, +)
  }
  
  private func asCard(_ input: String) -> Card? {
    let sets = input
      .components(separatedBy: "|")
      .map {
        $0.replacingOccurrences(
          of: "Card\\s+\\d+:",
          with: "",
          options: .regularExpression
        )
      }
      .map(asSet)
    
    guard let winners = sets.first,
          let myNumbers = sets.last,
          sets.count == 2
    else {
      return nil
    }
    
    return Card(
      winners: winners,
      myNumbers: myNumbers
    )
  }
  
  private func asSet(_ input: String) -> Set<Int> {
    let ints = input
      .components(separatedBy: .whitespaces)
      .compactMap(Int.init)
    
    return Set(ints)
  }
  
  private func numberOfWinners(_ card: Card) -> Int {
    card
      .winners
      .intersection(card.myNumbers)
      .count
  }
  
  private func determineScore(_ card: Card) -> Int {
    let count = numberOfWinners(card)
    return Int(pow(Double(2), Double(count-1)))
  }
}

fileprivate struct Card {
  let winners: Set<Int>
  let myNumbers: Set<Int>
}
