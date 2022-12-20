import ArgumentParser
import Foundation

struct Adventofcode: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Advent of Code 2022", subcommands: [
        Dec012022.self, Dec022022.self, Dec032022.self, Dec042022.self, Dec052022.self, Dec062022.self, Dec072022.self, Dec082022.self,
        Dec092022.self, Dec102022.self, Dec112022.self, Dec122022.self, Dec132022.self, Dec142022.self, Dec152022.self, Dec162022.self,
        Dec172022.self, Dec182022.self, Dec192022.self, Dec202022.self, Dec212022.self, Dec222022.self, Dec232022.self, Dec242022.self,
        Dec252022.self
    ])

    init() {}
}

Adventofcode.main()
