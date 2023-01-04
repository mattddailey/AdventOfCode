import ArgumentParser

struct Dec212022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - Monkey Math", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec212022.txt"

    // MARK: - Data Structures

    typealias Monkeys = [String : Int]
    typealias Waiters = [String : Waiter]

    enum numberError: Error {
        case invalidName
    }

    enum Operand: Hashable {
        case add(Int)
        case divide(Int)
        case multiply(Int)
        case subtract(Int)

        // covers scenario in which variable x (my unknown value) is on the rhs of an operand
        // for my case, this only occurs for subtraction - e.g. 4 - x
        // To solve, in the applyInverse function, I first negate the value, then add the num (4 in this case)
        case minusX(Int)

        init?(rawValue: String) {
            switch rawValue {
            case "+": self = .add(0)
            case "/": self = .divide(0)
            case "*": self = .multiply(0)
            case "-": self = .subtract(0)
            default: return nil
            }
        }

        func applyInverse(to value: Int) -> Int {
            switch self {
            case .add(let num):      return value - num
            case .divide(let num):   return value * num
            case .multiply(let num): return value / num
            case .subtract(let num): return value + num
            case .minusX(let num):
                let negated = value * -1
                return negated + num
            }
        }
    }

    struct Variable {
        var value: Int?
        var operands: [Operand]?
    }

    struct Waiter: Hashable {
        let name: String
        var operand: Operand
        let waitingFor: [String]

        init?(_ components: [String]) {
            guard let operand = Operand(rawValue: components[2]) else { return nil }
            self.name = String(components[0].dropLast())
            self.operand = operand
            self.waitingFor = [components[1], components[3]]
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
        let (monkeys, waiters) = parseInput(lines)

        if let result = try? number(for: "root", monkeys, waiters) {
            return result
        } else {
            print("Unable to solve part 1")
            return 0
        }
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        let (monkeys, waiters) = parseInput(lines, myName: "humn")
        return determineMyNumber(monkeys, waiters)
    }

    // MARK: Helpers

    func buildVariable(for name: String,  _ monkeys: Monkeys, _ waiters: Waiters) -> Variable {
        if let number = monkeys[name] {
            return Variable(value: number)
        } else if name == "humn" {
            return Variable(operands: [])
        } else {
            guard let waiter = waiters[name] else { fatalError() }
            let first = buildVariable(for: waiter.waitingFor[0], monkeys, waiters)
            let second = buildVariable(for: waiter.waitingFor[1], monkeys, waiters)

            if let firstVal = first.value, let secondVal = second.value {
                switch waiter.operand {
                case .add: return Variable(value: firstVal + secondVal)
                case .divide: return Variable(value: firstVal / secondVal)
                case .multiply: return Variable(value: firstVal * secondVal)
                case .subtract: return Variable(value: firstVal - secondVal)
                case .minusX: fatalError()
                }
            } else if let firstVal = first.value, second.value == nil, var secondOperands = second.operands {
                switch waiter.operand {
                case .add: 
                    secondOperands.append(.add(firstVal))
                    return Variable(operands: secondOperands)
                case .divide: 
                    // this scenario should never occur
                    fatalError()
                case .multiply: 
                    secondOperands.append(.multiply(firstVal))
                    return Variable(operands: secondOperands)
                case .subtract: 
                    secondOperands.append(.minusX(firstVal))
                    return Variable(operands: secondOperands)
                case .minusX:
                    // this scenario should never occur
                    fatalError()
                }
            } else if let secondVal = second.value, first.value == nil, var firstOperands = first.operands {
                switch waiter.operand {
                case .add: 
                    firstOperands.append(.add(secondVal))
                    return Variable(operands: firstOperands)
                case .divide: 
                    firstOperands.append(.divide(secondVal))
                    return Variable(operands: firstOperands)
                case .multiply: 
                    firstOperands.append(.multiply(secondVal))
                    return Variable(operands: firstOperands)
                case .subtract: 
                    firstOperands.append(.subtract(secondVal))
                    return Variable(operands: firstOperands)
                case .minusX:
                    // this scenario should never occur
                    fatalError()
                }
            } else {
                fatalError()
            }
        }
    }

    func determineMyNumber( _ monkeys: Monkeys, _ waiters: Waiters) -> Int {
        guard let lhs = waiters["root"]?.waitingFor[0],
              let rhs = waiters["root"]?.waitingFor[1]
        else { return 0 }

        if let rhsValue = try? number(for: rhs, monkeys, waiters) {
            let lhsVariable = buildVariable(for: lhs, monkeys, waiters)
            var result = rhsValue
            if var operands = lhsVariable.operands {
                while let operand = operands.popLast() {
                    result = operand.applyInverse(to: result)
                }
            }
            return result
        } 
        return 0
    }

    func number(for name: String, _ monkeys: Monkeys, _ waiters: Waiters) throws -> Int {
        if let number = monkeys[name] {
            return number
        } else  {
            guard let waiter = waiters[name] else { throw numberError.invalidName }
            let first = waiter.waitingFor[0]
            let second = waiter.waitingFor[1]
            switch waiter.operand { 
            case .add:      return try number(for: first, monkeys, waiters) + number(for: second, monkeys, waiters) 
            case .divide:   return try number(for: first, monkeys, waiters) / number(for: second, monkeys, waiters) 
            case .multiply: return try number(for: first, monkeys, waiters) * number(for: second, monkeys, waiters) 
            case .subtract: return try number(for: first, monkeys, waiters) - number(for: second, monkeys, waiters)
            case .minusX:
                // this scenario should never occur
                fatalError() 
            }
        }
    }

    func parseInput(_ lines: [String], myName: String? = nil) -> (Monkeys, Waiters) {
        var monkeys = Monkeys()
        var waiters = Waiters()
        for line in lines {
            let components = line.components(separatedBy: .whitespaces)
            // for part 2, monkey with my name is incorrect, so do not include it
            if String(components[0].dropLast()) == myName {
                continue
            }
            if components.count == 2 {
                monkeys[String(components[0].dropLast())] = Int(components[1])
            } else if let waiter = Waiter(components) {
                waiters[String(components[0].dropLast())] = waiter
            }
        }

        return  (monkeys, waiters)
    }
}