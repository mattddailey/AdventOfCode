import ArgumentParser

struct Dec172022: ParsableCommand, AOCDayProtocol {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - Pyroclastic Flow", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec172022.txt"

    // MARK: - Data Structures

    enum Direction: String {
        case left = "<"
        case right = ">"
    }

    struct State: Hashable {
        let directionIndex: Int
        let left: Int
        let right: Int
        let rock: Rock
    }

    enum Rock: Int {
        case horizontal
        case cross
        case corner
        case vertical
        case square

        var next: Rock {
            switch self {
            case .horizontal: return .cross
            case .cross: return .corner
            case .corner: return .vertical
            case .vertical: return .square
            case .square: return .horizontal
            }
        }

        // startY will be the bottom of the shape (3 units above current highest rock)
        func points(startY: Int) -> Set<Point> { 
            switch self {
            case .horizontal: return Set([Point(x: 3, y: startY), Point(x: 4, y: startY), Point(x: 5, y: startY), Point(x: 6, y: startY)])
            case .cross: return Set([Point(x: 4, y: startY + 2), Point(x: 3, y: startY + 1), Point(x: 4, y: startY + 1), Point(x: 5, y: startY + 1),
                                     Point(x: 4, y: startY)
                                    ])
            case .corner: return Set([Point(x: 3, y: startY), Point(x: 4, y: startY), Point(x: 5, y: startY),
                                      Point(x: 5, y: startY + 1), Point(x: 5, y: startY + 2)
                                    ])
            case .vertical: return Set([Point(x: 3, y: startY), Point(x: 3, y: startY + 1), Point(x: 3, y: startY + 2), Point(x: 3, y: startY + 3)])
            case .square: return Set([Point(x: 3, y: startY), Point(x: 3, y: startY + 1), Point(x: 4, y: startY), Point(x: 4, y: startY + 1)])
            }
        }
    }

    class Chamber {
        // to keep tally of current settled rocks, and height of the tower
        var maxHeight = 0
        var occupied = Set<Point>([Point(x: 1, y: 0), Point(x: 2, y: 0), Point(x: 3, y: 0), Point(x: 4, y: 0),
                                                                  Point(x: 5, y: 0), Point(x: 6, y: 0), Point(x: 7, y: 0)
                                  ])

        // constants defining the edges of the chamber
        let leftEdge = 0
        let rightEdge = 8

        let numberOfRocksToDrop: Int
        var rockCounter = 0
        var directionCounter = 0

        // State maps to (rock count, height)
        var seen: [State: (Int, Int)] = [:]

        init(count: Int) {
            self.numberOfRocksToDrop = count
        }

        func dropRocks(for directions: [Direction]) -> Int {
            var advanced = false
            var heightOffset = 0
            var rock = Rock.horizontal
            var points = rock.points(startY: maxHeight + 4)

            while rockCounter < numberOfRocksToDrop {
                // move horizontal according to direction (if possible)
                guard let direction = directions[circular: directionCounter] else { continue }

                // move left / right as needed
                let shifted = horizontalShift(points, direction)
                if occupied.isDisjoint(with: shifted) {
                    points = shifted
                }

                // can drop if disjoint
                let dropped = points.dropped(points)
                if occupied.isDisjoint(with: dropped) {
                    points = dropped
                // came to rest
                } else {
                    occupied = occupied.union(points)
                    rockCounter += 1
                    maxHeight = max(maxHeight, points.maxHeight)
                    
                    let state = State(directionIndex: directionCounter % directions.count, left: points.left, right: points.right, rock: rock)
                    if let (rockCount, height) = seen[state],!advanced {
                        // duplicate state found; need to determine an offset, and advance rockCounter as much as possible
                        let remainingRocks = numberOfRocksToDrop - rockCounter
                        let repeatedRocksCount = rockCounter - rockCount
                        let numberOfRepeatedCyclesRemaining = remainingRocks / repeatedRocksCount

                        heightOffset = numberOfRepeatedCyclesRemaining * (maxHeight - height)
                        rockCounter += (repeatedRocksCount * numberOfRepeatedCyclesRemaining)
                        advanced = true
                    }

                    // cache value, for finding a duplicate pattern
                    seen[state] = (rockCounter, maxHeight)

                    //advance to next rock, get new points
                    rock = rock.next
                    points = rock.points(startY: maxHeight + 4)
                }
                directionCounter += 1
            }

            return maxHeight + heightOffset
        }

        private func horizontalShift(_ points: Set<Point>, _ direction: Direction) -> Set<Point> {
            let mutablePoints = Set<Point>(points.compactMap { point in
                    var temp = point
                    temp.x = direction == .left ? temp.x - 1 : temp.x + 1
                    guard (leftEdge+1...rightEdge-1).contains(temp.x) else { return nil }
                    return temp
                })
            // nils above (if we hit edge) will cause count to be different, so return points
            return mutablePoints.count == points.count ? mutablePoints : points
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
        let directions = lines[0].compactMap { Direction(rawValue: String($0)) }
        let chamber = Chamber(count: 2022)
        return chamber.dropRocks(for: directions)
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        let directions = lines[0].compactMap { Direction(rawValue: String($0)) }
        let chamber = Chamber(count: 1000000000000)
        return chamber.dropRocks(for: directions)
    }
}

// Extensions:

fileprivate extension Array {
	subscript(circular index: Int) -> Element? {
		guard index >= 0 && !isEmpty else { return nil }
		guard index >= count else { return self[index] }
		return self[index % count]
	}
}

fileprivate extension Set where Element == Point {
    var left: Int {
        var left = Int.max
        self.forEach { left = Swift.min(left, $0.x) }
        return left
    }

    var right: Int {
        var right = -1
        self.forEach { right = Swift.max(right, $0.x) }
        return right
    }

    var maxHeight: Int {
        var maxHeight = 0
        self.forEach { maxHeight = Swift.max(maxHeight, $0.y) }
        return maxHeight
    }

    func dropped(_ points: Set<Point>) -> Set<Point> {
        Set<Point>(points.map { point in
            var temp = point
            temp.y -= 1
            return temp
        })
    }
}
