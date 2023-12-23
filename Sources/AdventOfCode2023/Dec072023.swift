//  Dec072023.swift
//
//
//  Created by Matt Dailey on 12/07/23.
//

import ArgumentParser
import AdventOfCodeShared
import AOCDay
import Foundation

@AOCDay(name: "Camel Cards")
struct Dec072023: AdventOfCodeDay, AsyncParsableCommand {
  func part1(_ input: String) throws -> CustomStringConvertible {
    determineWinnings(input, part2: false)
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
    determineWinnings(input, part2: true)
  }
  
  private func determineWinnings(_ input: String, part2: Bool) -> Int {
    input
      .components(separatedBy: .newlines)
      .compactMap { hand($0, part2: part2) }
      .sorted()
      .enumerated()
      .map { index, hand in (index+1) * hand.bid }
      .reduce(0, +)
  }
  
  private func hand(_ input: String, part2: Bool) -> Hand? {
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
      "J": part2 ? 0 : 11,
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
    
    return Hand(cards: cards, bid: bid, type: bestHand(cards, part2: part2))
  }
  
  private func bestHand(_ cards: [Int], part2: Bool) -> HandType {
    var cardCounts: [Int: Int] = [:]
    for card in cards {
      cardCounts[card] = (cardCounts[card] ?? 0) + 1
    }
    
    let nonJs = cards.filter { $0 != 0 }
    
    guard part2, cardCounts[0] != nil, !nonJs.isEmpty else {
      return HandType(cards)
    }

    var handTypes: [HandType] = []
    
    for nonJ in nonJs {
      let modifiedCards = cards
        .map { card in
          guard card == 0 else {
            return card
          }
          
          return nonJ
        }
      
      handTypes.append(HandType(modifiedCards))
    }
    
    return handTypes.max(by: { lhs, rhs in lhs.rawValue < rhs.rawValue })!
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
}

fileprivate enum HandType: Int {
  case FiveOfAKind = 7
  case FourOfAKind = 6
  case FullHouse = 5
  case ThreeOfAKind = 4
  case TwoPair = 3
  case OnePair = 2
  case HighCard = 1
  
  init(_ cards: [Int]) {
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
