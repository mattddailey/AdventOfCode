//
//  Day01.swift
//  
//
//  Created by Matt Dailey on 11/30/23.
//

import ArgumentParser
import AdventOfCodeShared
import Foundation

struct Day01: AdventOfCodeDay, AsyncParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Advent of Code - December 01, 2023 - Trebuchet?!")
  
  func run() async throws {
    print("Part 1: \(part1(""))")
    print("Part 2: \(part2(""))")
  }
  
  func part1(_ input: String) -> CustomStringConvertible {
    input
      .filter { $0.isWholeNumber || $0.isNewline }
      .components(separatedBy: .newlines)
      .compactMap(calibrationValuePart1)
      .reduce(0, +)
  }
  
  func part2(_ input: String) -> CustomStringConvertible {
    input
      .components(separatedBy: .newlines)
      .compactMap(calibrationValuePart2)
      .reduce(0, +)
  }
  
  private func calibrationValuePart1(_ line: String) -> Int? {
    guard
      let first = line.first,
      let last = line.last
    else {
      return nil
    }
    
    return Int("\(first)\(last)")
  }
  
  private func calibrationValuePart2(_ line: String) -> Int? {
    var result = ""
    var temp = ""
    
    let numbers: [String: String] = [
      "zero": "0",
      "one": "1",
      "two": "2",
      "three": "3",
      "four": "4",
      "five": "5",
      "six": "6",
      "seven": "7",
      "eight": "8",
      "nine": "9"
    ]
    
    for character in line {
      if character.wholeNumberValue != nil {
        result.append(character)
      } else {
        temp.append(character)
        
        for number in numbers {
          if temp.contains(number.key) {
            result.append(number.value)
            temp = String(temp.last ?? Character(""))
          }
        }
      }
    }
    
    return calibrationValuePart1(result)
  }
}
