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
      Day01.self,
      Day02.self,
      Day04.self
    ]
  )
}
