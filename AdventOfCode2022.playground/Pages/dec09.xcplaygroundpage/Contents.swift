import Foundation
import Darwin

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
    
    var head: Knot
    
    var tailLocations: Set<Coordinates> = [Coordinates()]
    
    mutating func processMoves(_ moves: [Move]) {
        // move head
        for move in moves {
            for _ in 1...move.amount {
                // move head
                switch move.direction {
                case .right:
                    head.coordinates.x += 1
                case .left:
                    head.coordinates.x -= 1
                case .up:
                    head.coordinates.y += 1
                case .down:
                    head.coordinates.y -= 1
                }
                
                // move remaining knot(s)
                var current = head.prev
                var next = head
                while current != nil {
                    if let nonOptionalCurrent = current {
                        moveKnotIfNeeded(nonOptionalCurrent, next)
                        next = nonOptionalCurrent
                        current = next.prev
                    }
                }
                
                // store tail location if it is new
                tailLocations.insert(head.tail.coordinates)
            }
        }
    }

    private mutating func moveKnotIfNeeded(_ knot: Knot, _ next: Knot) {
        // up two right one; up one right two; down one right two; down two right one;
        if (next.coordinates.y - knot.coordinates.y == 2) && (next.coordinates.x - knot.coordinates.x == 1) {
            knot.coordinates.x += 1
            knot.coordinates.y += 1
        } else if (next.coordinates.y - knot.coordinates.y == 1) && (next.coordinates.x - knot.coordinates.x == 2) {
            knot.coordinates.x += 1
            knot.coordinates.y += 1
        } else if (next.coordinates.y - knot.coordinates.y == -1) && (next.coordinates.x - knot.coordinates.x == 2) {
            knot.coordinates.x += 1
            knot.coordinates.y -= 1
        } else if (next.coordinates.y - knot.coordinates.y == -2) && (next.coordinates.x - knot.coordinates.x == 1) {
            knot.coordinates.x += 1
            knot.coordinates.y -= 1
        // up two left one; up one left two; down one left two; down two left one;
        } else if (next.coordinates.y - knot.coordinates.y == 2) && (next.coordinates.x - knot.coordinates.x == -1) {
            knot.coordinates.x -= 1
            knot.coordinates.y += 1
        } else if (next.coordinates.y - knot.coordinates.y == 1) && (next.coordinates.x - knot.coordinates.x == -2) {
            knot.coordinates.x -= 1
            knot.coordinates.y += 1
        } else if (next.coordinates.y - knot.coordinates.y == -1) && (next.coordinates.x - knot.coordinates.x == -2) {
            knot.coordinates.x -= 1
            knot.coordinates.y -= 1
        } else if (next.coordinates.y - knot.coordinates.y == -2) && (next.coordinates.x - knot.coordinates.x == -1) {
            knot.coordinates.x -= 1
            knot.coordinates.y -= 1
        // two steps up & right, up and left, down and right, down and left
        } else if (next.coordinates.y - knot.coordinates.y == 2) && (next.coordinates.x - knot.coordinates.x == 2) {
            knot.coordinates.x += 1
            knot.coordinates.y += 1
        } else if (next.coordinates.y - knot.coordinates.y == 2) && (next.coordinates.x - knot.coordinates.x == -2) {
            knot.coordinates.x -= 1
            knot.coordinates.y += 1
        } else if (next.coordinates.y - knot.coordinates.y == -2) && (next.coordinates.x - knot.coordinates.x == 2) {
            knot.coordinates.x += 1
            knot.coordinates.y -= 1
        } else if (next.coordinates.y - knot.coordinates.y == -2) && (next.coordinates.x - knot.coordinates.x == -2) {
            knot.coordinates.x -= 1
            knot.coordinates.y -= 1
        // two steps up down, left, right;
        } else if next.coordinates.y - knot.coordinates.y == 2 {
            knot.coordinates.y += 1
        } else if next.coordinates.y - knot.coordinates.y == -2 {
            knot.coordinates.y -= 1
        } else if next.coordinates.x - knot.coordinates.x == 2 {
            knot.coordinates.x += 1
        } else if next.coordinates.x - knot.coordinates.x == -2 {
            knot.coordinates.x -= 1
        }
    }
}

//MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "dec09Input")
    let moves = helper.inputAsArraySeparatedBy(.newlines)
        .map { $0.components(separatedBy: .whitespaces) }
        .compactMap(Move.init)
    
    let head = Knot()
    let tail = Knot()
    head.prev = tail
    
    var ropeSimulator = RopeSimulator(head: head)
    ropeSimulator.processMoves(moves)
    
    return ropeSimulator.tailLocations.count
}

//MARK: - Part 2

func part2() -> Int {
    let helper = InputHelper(fileName: "dec09Input")
    let moves = helper.inputAsArraySeparatedBy(.newlines)
        .map { $0.components(separatedBy: .whitespaces) }
        .compactMap(Move.init)

    let head = Knot()
    var current = head
    for i in 1...9 {
        let knot = Knot()
        current.prev = knot
        current = knot
    }
    
    var ropeSimulator = RopeSimulator(head: head)
    ropeSimulator.processMoves(moves)

    return ropeSimulator.tailLocations.count
}

print(part1())
print(part2())
