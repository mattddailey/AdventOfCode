//
//  AdventOfCode2023.swift
//
//
//  Created by Matt Dailey on 11/30/23.
//

import ArgumentParser

@main
@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13, watchOS 6, *)
struct AdventOfCode2023: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "Advent of Code 2023",
    subcommands: [
      Dec012023.self,
      Dec022023.self,
      Dec032023.self,
      Dec042023.self,
      Day05.self,
      Day06.self,
      Day07.self,
      Day08.self,
      Day09.self,
      Day11.self,
      Day12.self,
      Day14.self
    ]
  )
}
