import ArgumentParser

struct Dec222022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - Monkey Map", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec222022.txt"

    // MARK: - Data Structures

    enum Move {
        case amount(Int)
        case left
        case right
    }

    class MonkeyMap {
        let tiles: Set<Point>
        let walls: Set<Point>
        let moves: [Move]

        init(_ lines: [String]) {
            // Build sets for walls and tiles points
            var movesIndex: Int = 0
            var walls = Set<Point>()
            var tiles = Set<Point>()
            for (y, line) in lines.enumerated() {
                guard !line.isEmpty else { 
                    movesIndex = y + 1
                    break 
                }

                for (x, char) in line.enumerated() {
                    if char == "#" {
                        walls.insert(Point(x: x + 1, y: y + 1))
                    } else if char == "." {
                        tiles.insert(Point(x: x + 1, y: y + 1))
                    }
                }
            }
            self.tiles = tiles
            self.walls = walls

            // Build list of moves
            var moves: [Move] = []
            let numbers = lines[movesIndex].components(separatedBy: .decimalDigits.inverted)
            let directions = lines[movesIndex].components(separatedBy: .decimalDigits).filter { !$0.isEmpty }
            for (index, number) in numbers.enumerated() {
                if let number = Int(number) {
                    moves.append(.amount(number))
                }

                if index != numbers.count - 1 {
                    directions[index] == "L" ? moves.append(.left) : moves.append(.right)
                }
            }
            self.moves = moves
        }
    }

    // MARK: - Lifecycle

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        let monkeyMap = MonkeyMap(lines)
        return 0
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        return 0
    }
}