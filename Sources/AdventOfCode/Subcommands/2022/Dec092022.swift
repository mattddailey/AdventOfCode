import ArgumentParser

struct Dec092022: ParsableCommand, AOCDayProtocol {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - Rope Bridge", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec092022.txt"

    // MARK: - Data Structures

    enum Direction: String {
        case right = "R"
        case left = "L"
        case up = "U"
        case down = "D"
    }

    struct Coordinates: Hashable {
        var x: Int = 0
        var y: Int = 0
    }

    class Knot {
        var coordinates = Coordinates()
        var prev: Knot? = nil
        
        func move(_ direction: Direction) {
            switch direction {
            case .right: coordinates.x += 1
            case .left:  coordinates.x -= 1
            case .up:    coordinates.y += 1
            case .down:  coordinates.y -= 1
            }
        }
        
        var tail: Knot {
            var knot = self
            while knot.prev != nil {
                if let prev = knot.prev {
                    knot = prev
                }
            }
            return knot
        }
    }

    struct Move {
        let direction: Direction
        let amount: Int
        
        init?(_ move: [String]) {
            guard let direction = Direction(rawValue: move[0]), let amount = Int(move[1]) else { return nil }
            self.direction = direction
            self.amount = amount
        }
    }


    struct RopeSimulator {
        let head: Knot
        var tailLocations: Set<Coordinates> = [Coordinates()]
        
        mutating func processMoves(_ moves: [Move]) {
            // move head
            for move in moves {
                for _ in 1...move.amount {
                    // move head
                    head.move(move.direction)
                    
                    // move remaining knot(s)
                    var current = head.prev
                    var next = head
                    while let knot = current {
                        moveKnotIfNeeded(knot, next)
                        next = knot
                        current = next.prev
                    }
                    
                    // store tail location if it is new
                    tailLocations.insert(head.tail.coordinates)
                }
            }
        }

        private func moveKnotIfNeeded(_ knot: Knot, _ next: Knot) {
            let xChange = next.coordinates.x - knot.coordinates.x
            let yChange = next.coordinates.y - knot.coordinates.y
            let moveX = abs(xChange) > 1 || (abs(xChange) > 0 && abs(yChange) > 1)
            let moveY = abs(yChange) > 1 || (abs(yChange) > 0 && abs(xChange) > 1)
            
            if moveX {
                let direction: Direction = xChange < 0 ? .left : .right
                knot.move(direction)
            }
            if moveY {
                let direction: Direction = yChange < 0 ? .down : .up
                knot.move(direction)
            }
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
        let moves = lines
            .map { $0.components(separatedBy: .whitespaces) }
            .compactMap(Move.init)
        
        let head = Knot()
        let tail = Knot()
        head.prev = tail
        
        var ropeSimulator = RopeSimulator(head: head)
        ropeSimulator.processMoves(moves)
        
        return ropeSimulator.tailLocations.count
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        let moves = lines
            .map { $0.components(separatedBy: .whitespaces) }
            .compactMap(Move.init)

        let head = Knot()
        var current = head
        for _ in 1...9 {
            let knot = Knot()
            current.prev = knot
            current = knot
        }
        
        var ropeSimulator = RopeSimulator(head: head)
        ropeSimulator.processMoves(moves)

        return ropeSimulator.tailLocations.count
    }
}
