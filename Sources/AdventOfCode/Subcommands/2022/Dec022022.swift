import ArgumentParser

struct Dec022022: ParsableCommand, AOCDayProtocol {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - 2022 December 02", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec022022.txt"

    // MARK: - Data Structures

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

    var part1Scores: [String : Int] = [
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

    var part2Scores: [String : Int] = [
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

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        var score = 0
        for round in lines {
            if !round.isEmpty {
                score += part1Scores[round] ?? 0
            }
        }
        
        return score
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
         var score = 0
        for round in lines {
            if !round.isEmpty {
                score += part2Scores[round] ?? 0
            }
        }
        
        return score
    }
}
