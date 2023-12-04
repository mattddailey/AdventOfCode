//
//  Day02.swift
//
//
//  Created by Matt Dailey on 11/30/23.
//

import ArgumentParser
import Foundation

struct Day02: AOCDay, AsyncParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Advent of Code - December 02, 2023 - Cube Conundrum")
  
  func run() async throws {
    print("Part 1: \(part1(""))")
    print("Part 2: \(part2(""))")
  }
  
  func part1(_ input: String) -> CustomStringConvertible {
    input
      .components(separatedBy: .newlines)
      .map(createGame)
      .filter(isPossible)
      .map(\.id)
      .reduce(0, +)
  }
  
  func part2(_ input: String) -> CustomStringConvertible {
    input
      .components(separatedBy: .newlines)
      .map(createGame)
      .map(power)
      .reduce(0, +)
  }
  
  private func createGame(_ input: String) -> Game {
    let components = input
      .components(separatedBy: ":")
    
    return Game(
      id: (
        components
          .first?
          .asInt
      ) ?? 0,
      draws: (
        components
          .last?
          .components(separatedBy: ";")
          .map(createDraw)
      ) ?? []
    )
  }
  
  private func createDraw(_ input: String) -> Draw {
    var red: Int?
    var blue: Int?
    var green: Int?
    
    for colorDraw in input.components(separatedBy: ",") {
      let color = colorDraw
        .replacingOccurrences(
          of: "[0-9]+",
          with: "",
          options: .regularExpression
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
      
      let int = colorDraw.asInt
      
      switch color {
      case "red":
        red = int
      case "blue":
        blue = int
      case "green":
        green = int
      default:
        break
      }
    }

    return Draw(
      red: red ?? 0,
      blue: blue ?? 0,
      green: green ?? 0
    )
  }
  
  private func power(_ game: Game) -> Int {
    let red = game.draws.map(\.red).max() ?? 0
    let green = game.draws.map(\.green).max() ?? 0
    let blue = game.draws.map(\.blue).max() ?? 0
    
    return red * green * blue
  }
  
  private func isPossible(_ game: Game) -> Bool {
    let possible = game
      .draws
      .filter { draw in
        draw.red <= 12 &&
        draw.green <= 13 &&
        draw.blue <= 14
      }
    
    return possible.count == game.draws.count
  }
}

fileprivate struct Game {
  let id: Int
  let draws: [Draw]
}

fileprivate struct Draw {
  let red: Int
  let blue: Int
  let green: Int
}

