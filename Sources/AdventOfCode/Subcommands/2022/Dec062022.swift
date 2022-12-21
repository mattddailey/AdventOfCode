import ArgumentParser

struct Dec062022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - 2022 December 06", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec062022.txt"

    // MARK: - Data Structures

    // MARK: - Lifecycle

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        return locateMarker(in: lines[0], markerSize: 4)
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        return locateMarker(in: lines[0], markerSize: 14)
    }

    func locateMarker(in dataStream: String, markerSize: Int) -> Int {
        var index = 0
        while index+markerSize < dataStream.count {
            let slidingGroup = dataStream[index..<index+markerSize]
            var marker = Set<Character>()
            let duplicates = slidingGroup.filter { !marker.insert($0).inserted }
            if duplicates.isEmpty {
                return index+markerSize
            }
            index += 1
        }
        return index+markerSize
    }   
}