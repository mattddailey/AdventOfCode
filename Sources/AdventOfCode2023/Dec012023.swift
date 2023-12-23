//
//  Day01.swift
//  
//
//  Created by Matt Dailey on 11/30/23.
//

import ArgumentParser
import AdventOfCodeShared
import AOCDay
import Foundation

@AOCDay(name: "Trebuchet?!")
struct Dec012023: AdventOfCodeDay, AsyncParsableCommand {
  func part1(_ input: String) throws -> CustomStringConvertible {
    input
      .filter { $0.isWholeNumber || $0.isNewline }
      .components(separatedBy: .newlines)
      .compactMap(calibrationValuePart1)
      .reduce(0, +)
  }
  
  func part2(_ input: String) throws -> CustomStringConvertible {
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
