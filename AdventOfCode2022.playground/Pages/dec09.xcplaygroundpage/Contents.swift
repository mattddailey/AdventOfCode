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
    weak var head: Knot? = nil
    weak var tail: Knot? = nil
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
    
    var head = Coordinates()
    var tail = Coordinates()
    
    var tailLocations: Set<Coordinates> = [Coordinates()]
    
    mutating func processMoves(_ moves: [Move]) {
        // move head
        for move in moves {
            for _ in 1...move.amount {
                switch move.direction {
                case .right:
                    head.x += 1
                case .left:
                    head.x -= 1
                case .up:
                    head.y += 1
                case .down:
                    head.y -= 1
                }
                moveTailIfNeeded()
                tailLocations.insert(tail)
            }
        }
    }

    private mutating func moveTailIfNeeded() {
        // up two right one; up one right two; down one right two; down two right one;
        if (head.y - tail.y == 2) && (head.x - tail.x == 1) {
            tail.x += 1
            tail.y += 1
        } else if (head.y - tail.y == 1) && (head.x - tail.x == 2) {
            tail.x += 1
            tail.y += 1
        } else if (head.y - tail.y == -1) && (head.x - tail.x == 2) {
            tail.x += 1
            tail.y -= 1
        } else if (head.y - tail.y == -2) && (head.x - tail.x == 1) {
            tail.x += 1
            tail.y -= 1
        // up two left one; up one left two; down one left two; down two left one;
        } else if (head.y - tail.y == 2) && (head.x - tail.x == -1) {
            tail.x -= 1
            tail.y += 1
        } else if (head.y - tail.y == 1) && (head.x - tail.x == -2) {
            tail.x -= 1
            tail.y += 1
        } else if (head.y - tail.y == -1) && (head.x - tail.x == -2) {
            tail.x -= 1
            tail.y -= 1
        } else if (head.y - tail.y == -2) && (head.x - tail.x == -1) {
            tail.x -= 1
            tail.y -= 1
        }
        // two steps up down, left, right;
        if head.y - tail.y == 2 {
            tail.y += 1
        } else if head.y - tail.y == -2 {
            tail.y -= 1
        } else if head.x - tail.x == 2 {
            tail.x += 1
        } else if head.x - tail.x == -2 {
            tail.x -= 1
        }
    }
}



func part1() -> Int {
    let helper = InputHelper(fileName: "dec09Input")
    let moves = helper.inputAsArraySeparatedBy(.newlines)
        .map { $0.components(separatedBy: .whitespaces) }
        .compactMap(Move.init)
    
    var ropeSimulator = RopeSimulator()
    ropeSimulator.processMoves(moves)
    
    return ropeSimulator.tailLocations.count
}

print(part1())
