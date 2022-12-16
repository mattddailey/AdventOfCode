import ArgumentParser
import Foundation

struct Adventofcode: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Advent of Code 2022", subcommands: [
        Dec162022.self
    ])

    init() {}
}

Adventofcode.main()
