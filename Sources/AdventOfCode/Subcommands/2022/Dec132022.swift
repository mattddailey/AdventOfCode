import ArgumentParser

struct Dec132022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - 2022 December 13", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec132022.txt"

    // MARK: - Data Structures

    // MARK: - Lifecycle

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        return 0
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        return 0
    }
}