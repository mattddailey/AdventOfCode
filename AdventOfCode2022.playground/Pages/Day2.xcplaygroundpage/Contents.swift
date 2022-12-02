import Foundation
import Darwin

enum Choice {
    case rock
    case paper
    case scissor
    
    var score: Int {
        switch self {
        case .rock:
            return 1
        case .paper:
            return 2
        case .scissor:
            return 3
        }
    }
}

enum Outcome {
    case win
    case loss
    case draw
    
    var score: Int {
        switch self {
        case .win:
            return 6
        case .loss:
            return 0
        case .draw:
            return 3
        }
    }
}

let part1Scores: [String : Int] = [
    // LHS: input ; RHS: score of our play + score of outcome
    "A X" : Choice.rock.score + Outcome.draw.score,
    "A Y" : Choice.paper.score + Outcome.win.score,
    "A Z" : Choice.scissor.score + Outcome.loss.score,
    "B X" : Choice.rock.score + Outcome.loss.score,
    "B Y" : Choice.paper.score + Outcome.draw.score,
    "B Z" : Choice.scissor.score + Outcome.win.score,
    "C X" : Choice.rock.score + Outcome.win.score,
    "C Y" : Choice.paper.score + Outcome.loss.score,
    "C Z" : Choice.scissor.score + Outcome.draw.score,
]

// X - lose
// Y - Draw
// Z - Win

let part2Scores: [String : Int] = [
    // LHS: input ; RHS: score of our play + score of outcome
    "A X" : Choice.scissor.score + Outcome.loss.score,
    "A Y" : Choice.rock.score + Outcome.draw.score,
    "A Z" : Choice.paper.score + Outcome.win.score,
    "B X" : Choice.rock.score + Outcome.loss.score,
    "B Y" : Choice.paper.score + Outcome.draw.score,
    "B Z" : Choice.scissor.score + Outcome.win.score,
    "C X" : Choice.paper.score + Outcome.loss.score,
    "C Y" : Choice.scissor.score + Outcome.draw.score,
    "C Z" : Choice.rock.score + Outcome.win.score,
]


// MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "Day2Input")
    let rounds = helper.inputAsArraySeparatedBy(.newlines)
    
    var score = 0
    for round in rounds {
        if !round.isEmpty {
            score += part1Scores[round]!
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
            score += part2Scores[round]!
        }
    }
    
    return score
}

print(part1())
print(part2())
