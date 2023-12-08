//  Day07.swift
//
//
//  Created by Matt Dailey on 12/07/23.
//

import ArgumentParser
import AdventOfCodeShared
import Foundation

struct Day07: AdventOfCodeDay, AsyncParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Advent of Code - December 07, 2023 - Camel Cards")
  
  func run() async throws {
    print("Part 1: \(part1(""))")
    print("Part 2: \(part2(""))")
  }
  
  func part1(_ input: String) -> CustomStringConvertible {
    input
      .components(separatedBy: .newlines)
      .compactMap { Hand($0) }
      .sorted()
      .enumerated()
      .map { index, hand in (index+1) * hand.bid }
      .reduce(0, +)
  }
  
  func part2(_ input: String) -> CustomStringConvertible {
    input
      .components(separatedBy: .newlines)
      .compactMap { Hand($0, jValue: 0) }
      .sorted()
      .enumerated()
      .map { index, hand in (index+1) * hand.bid }
      .reduce(0, +)
  }
}

fileprivate struct Hand: Comparable {
  static func < (lhs: Hand, rhs: Hand) -> Bool {
    guard lhs.type.rawValue == rhs.type.rawValue else {
      return lhs.type.rawValue < rhs.type.rawValue
    }
    
    for index in 0..<lhs.cards.count {
      if lhs.cards[index] == rhs.cards[index] {
        continue
      } else {
        return lhs.cards[index] < rhs.cards[index]
      }
    }
    
    return lhs.type.rawValue < rhs.type.rawValue
  }
  
  let cards: [Int]
  let bid: Int
  let type: HandType
  private let jValue: Int
  
  init?(_ input: String, jValue: Int = 11) {
    let Cards: [Character: Int] = [
      "2": 2,
      "3": 3,
      "4": 4,
      "5": 5,
      "6": 6,
      "7": 7,
      "8": 8,
      "9": 9,
      "T": 10,
      "J": jValue,
      "Q": 12,
      "K": 13,
      "A": 14
    ]
    
    let components = input.components(separatedBy: .whitespaces)
    
    guard components.count == 2, let cardsComponent = components.first, let bid = Int(components.last ?? "") else {
      return nil
    }
    
    let cards = cardsComponent
      .compactMap { Cards[$0] }
    
    guard cards.count == 5 else {
      return nil
    }
    
    self.cards = cards
    self.bid = bid
    self.type = bestHand(cards, jValue: jValue)
    self.jValue = jValue
  }
}

fileprivate func bestHand(_ cards: [Int], jValue: Int) -> HandType {
  guard jValue == 0 else {
    return HandType(cards, jValue: jValue)
  }
  
  var cardCounts: [Int: Int] = [:]
  for card in cards {
    cardCounts[card] = (cardCounts[card] ?? 0) + 1
  }

  let jCount = cardCounts[jValue] ?? 0
  
  guard jCount != 0 else {
    return HandType(cards, jValue: jValue)
  }
  
  let nonJs = cards.filter { $0 != 0 }
  
  var handTypes: [HandType] = []
  
  guard !nonJs.isEmpty else {
    return HandType(cards, jValue: jValue)
  }
  
  for nonJ in nonJs {
    let modifiedCards = cards
      .map { card in
        guard card == 0 else {
          return card
        }
        
        return nonJ
      }
    
    handTypes.append(HandType(modifiedCards, jValue: jValue))
  }
  
  return handTypes.max(by: { lhs, rhs in lhs.rawValue < rhs.rawValue })!
}

fileprivate enum HandType: Int {
  case FiveOfAKind = 7
  case FourOfAKind = 6
  case FullHouse = 5
  case ThreeOfAKind = 4
  case TwoPair = 3
  case OnePair = 2
  case HighCard = 1
  
  init(_ cards: [Int], jValue: Int) {
    var cardCounts: [Int: Int] = [:]
    for card in cards {
      cardCounts[card] = (cardCounts[card] ?? 0) + 1
    }

    switch cardCounts.count {
    case 1:
      self = .FiveOfAKind
    case 2:
      self = if cardCounts.contains(where: { $0.value == 4  }) {
        .FourOfAKind
      } else {
        .FullHouse
      }
    case 3:
      self = if cardCounts.contains(where: { $0.value == 3  }) {
        .ThreeOfAKind
      } else {
        .TwoPair
      }
    case 4:
      self = .OnePair
    case 5:
      self = .HighCard
    default:
      // This should never happen
      self = .HighCard
    }
  }
}
