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
      Dec052023.self,
      Dec062023.self,
      Dec072023.self,
      Dec082023.self,
      Dec092023.self,
      Dec112023.self,
      Dec122023.self,
      Dec142023.self
    ]
  )
}
