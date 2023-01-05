import ArgumentParser

struct Dec222022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - Monkey Map", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec222022.txt"

    // MARK: - Data Structures

    enum Land {
        case tile
        case wall
        case whitespace
    }

    enum Move {
        case amount(Int)
        case left
        case right
    }

    // MARK: - Lifecycle

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        let (map, moves) = parseInput(lines)
        return determinePassword(map, moves)
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        let (map, moves) = parseInput(lines)
        return determinePassword(map, moves, is3D: true)
    }

    // MARK: Shared

    func determinePassword(_ map: [[Land]], _ moves: [Move], is3D: Bool = false) -> Int {
        guard let landOffset = map[0].leftMostLandIndex else { fatalError("Could not find non-whitespace land in first row of map") }

        var current = Point(x: landOffset, y: 0)
        var direction = Direction.east
        for move in moves {
            switch move {
            case .amount(var remaining):
                while remaining > 0  {
                    remaining -= 1
                    let next: Point
                    switch direction {
                        case .north: (next, direction) = map.northOf(current, is3D: is3D)
                        case .south: (next, direction) = map.southOf(current, is3D: is3D)
                        case .east:  (next, direction) = map.eastOf(current, is3D: is3D)
                        case .west:  (next, direction) = map.westOf(current, is3D: is3D)
                    }
                    guard map[safe: next.y]?[safe: next.x] != .wall else { 
                        break 
                    }
                    current = next
                }
            case .left:
                direction = direction.rotatedLeft
            case .right:
                direction = direction.rotatedRight
            }
        }

        return (1000 * (current.y + 1)) + (4 * (current.x + 1)) + direction.rawValue
    }

    func parseInput(_ lines: [String]) -> ([[Land]], [Move]) {
        guard let separatorIndex = lines.firstIndex(where: { $0.isEmpty}) else { fatalError("Input is not formatted as expected ")}

        // Build map
        var map: [[Land]] = []
        for line in lines {
            var row: [Land] = []
            guard !line.isEmpty else { break }

            for char in line {
                if char == "#" {
                    row.append(.wall)
                } else if char == "." {
                    row.append(.tile)
                } else {
                    row.append(.whitespace)
                }
            }
            map.append(row)
        }

        // Build list of moves
        var moves: [Move] = []
        let numbers = lines[separatorIndex + 1].components(separatedBy: .decimalDigits.inverted)
        let directions = lines[separatorIndex + 1].components(separatedBy: .decimalDigits).filter { !$0.isEmpty }
        for (index, number) in numbers.enumerated() {
            if let number = Int(number) {
                moves.append(.amount(number))
            }

            if index != numbers.count - 1 {
                directions[index] == "L" ? moves.append(.left) : moves.append(.right)
            }
        }
        return (map, moves)
    }

    
}

extension Array where Element == Dec222022.Land {
    var leftMostLandIndex: Int? {
        self.firstIndex(where: { $0 != .whitespace })
    }

    var rightMostLandIndex: Int? {
        self.count - 1
    }
}

extension Array where Element == [Dec222022.Land] {
    func northOf(_ point: Point, is3D: Bool) -> (Point, Direction) {
        let next = self[safe: point.y - 1]?[safe: point.x]
        if next != nil && next != .whitespace {
            return (Point(x: point.x, y: point.y - 1), .north)

        } else if is3D, (0...49).contains(point.x) {
            return (Point(x: 50, y: 50 + point.x), .east)

        } else if is3D, (50...99).contains(point.x) {
            return (Point(x: 0, y: point.x + 100), .east)
         
        } else if is3D, (100...149).contains(point.x) {  
            return (Point(x: point.x - 100, y: 199), .north)

        } else if let y = bottomMostLandIndex(column: point.x)   {
            return (Point(x: point.x, y: y), .north)
        } else {
            fatalError()
        }
    }

    func southOf(_ point: Point, is3D: Bool) -> (Point, Direction) {
        let next = self[safe: point.y + 1]?[safe: point.x]
        if next != nil && next != .whitespace {
            return (Point(x: point.x, y: point.y + 1), .south)

        } else if is3D, (0...49).contains(point.x) {
            return (Point(x: 100 + point.x, y: 0), .south)

        } else if is3D, (50...99).contains(point.x) {
            return (Point(x: 49, y: point.x + 100), .west)

        } else if is3D, (100...149).contains(point.x) {
            return (Point(x: 99, y: point.x - 50), .west)

        } else if let y = topMostLandIndex(column: point.x)   {
            return (Point(x: point.x, y: y), .south)
        } else {
            fatalError()
        }
    }

    func eastOf(_ point: Point, is3D: Bool) -> (Point, Direction) {
        let next = self[safe: point.y]?[safe: point.x + 1]
        if next != nil && next != .whitespace {
            return (Point(x: point.x + 1, y: point.y), .east)

        } else if is3D, (0...49).contains(point.y) {
            return (Point(x: 99, y: 149 - point.y), .west)

        } else if is3D, (50...99).contains(point.y) {
            return (Point(x: point.y + 50, y: 49), .north)

        } else if is3D, (100...149).contains(point.y) {
            return (Point(x: 149, y: 149 - point.y), .west)
        
        } else if is3D, (150...199).contains(point.y) {
            return (Point(x: point.y - 100, y: 149), .north)

        } else if let x = self[safe: point.y]?.leftMostLandIndex   {
            return (Point(x: x, y: point.y), .east)
        } else {
            fatalError()
        }
    }

    func westOf(_ point: Point, is3D: Bool) -> (Point, Direction) {
        let next = self[safe: point.y]?[safe: point.x - 1]
        if next != nil && next != .whitespace {
            return (Point(x: point.x - 1, y: point.y), .west)

        } else if is3D, (0...49).contains(point.y) {
            return (Point(x: 0, y: 149 - point.y), .east)

        } else if is3D, (50...99).contains(point.y) {
            return(Point(x: point.y - 50, y: 100), .south)

        } else if is3D, (100...149).contains(point.y) {
            return (Point(x: 50, y: 149 - point.y), .east)
        
        } else if is3D, (150...199).contains(point.y) {
            return (Point(x: point.y - 100, y: 0), .south)

        } else if let x = self[safe: point.y]?.rightMostLandIndex   {
            return (Point(x: x, y: point.y), .west)
        } else {
            fatalError()
        }
    }

    func topMostLandIndex(column x: Int) -> Int? {
        self.firstIndex(where: { 
            $0[safe: x] != nil && $0[safe: x] != .whitespace 
        })
    }

    func bottomMostLandIndex(column x: Int) -> Int? {
        let reversed = Array(self.reversed())
        if let index = reversed.firstIndex(where: { $0[safe: x] != nil && $0[safe: x] != .whitespace }) {
            return reversed.count - 1 - index
        }
        return nil
    }
}

extension Direction {
    var rotatedLeft: Direction {
        switch self {
            case .north: return .west
            case .east: return .north
            case .south: return .east
            case .west: return .south
        }
    }

    var rotatedRight: Direction {
        switch self {
            case .north: return .east
            case .east: return .south
            case .south: return .west
            case .west: return .north
        }
    }
}