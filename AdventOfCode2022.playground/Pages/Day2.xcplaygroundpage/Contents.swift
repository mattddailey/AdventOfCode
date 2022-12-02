import Foundation
import Darwin

enum Shape: String {
    case rock = "A"
    case paper = "B"
    case scissors = "C"
    
    // For part 1
    init(myTurn: String) {
        switch myTurn {
        case ("X"):
            self = .rock
        case ("Y"):
            self = .paper
        default:
            self = .scissors
        }
    }

    // returns bool corresponding to whether or not RHS wins
    static func <(lhs: Shape, rhs: Shape) -> Bool?  {
        switch (lhs, rhs) {
        case (.rock, .paper):
            return true
        case (.rock, .scissors):
            return false
        case (.paper, .rock):
            return false
        case (.paper, .scissors):
            return true
        case (.scissors, .rock):
            return true
        case (.scissors, .paper):
            return false
        default:
            return nil
        }
    }
        
    var score: Int {
        switch self {
        case .rock:
            return 1
        case .paper:
            return 2
        case .scissors:
            return 3
        }
    }
    
    var shapeThatWins: Shape {
        switch self {
        case .rock:
            return .paper
        case .paper:
            return .scissors
        case .scissors:
            return .rock
        }
    }
    
    var shapeThatLoses: Shape {
        switch self {
        case .rock:
            return .scissors
        case .paper:
            return .rock
        case .scissors:
            return .paper
        }
    }
    
}

enum DesiredOutcome: String {
    case loss = "X"
    case draw = "Y"
    case win = "Z"
}


// MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "Day2Input")
    let rounds = helper.inputAsArraySeparatedBy(.newlines)
    
    var score = 0
    for round in rounds {
        if !round.isEmpty {
            let splitRound = round.split(separator: " ")
            let opponentsTurn = Shape(rawValue: String(splitRound[0]))!
            let myTurn = Shape(myTurn: String(splitRound[1]))
            
            if let result = opponentsTurn < myTurn {
                // Win / Lose
                score += result ? 6 + myTurn.score : myTurn.score
            } else {
                // Tie
                score += myTurn.score + 3
            }
        }
    }
    
    return score
}

// MARK: - Part 2

func part2() -> Int {
    let helper = InputHelper(fileName: "Day2Input")
    let rounds = helper.inputAsArraySeparatedBy(.newlines)
    
    var score = 0
    for round in rounds {
        if !round.isEmpty {
            let splitRound = round.split(separator: " ")
            let opponentsTurn = Shape(rawValue: String(splitRound[0]))!
            let desiredOutcome = DesiredOutcome(rawValue: String(splitRound[1]))
            
            if desiredOutcome == .draw {
                score += opponentsTurn.score + 3
            } else if desiredOutcome == .win {
                score += opponentsTurn.shapeThatWins.score + 6
            } else {
                score += opponentsTurn.shapeThatLoses.score
            }
        }
    }
    
    
    return score
}

print(part1())
print(part2())
