import Foundation

enum Operation{
    case add(Int)
    case multiply(Int)
    case square
    
    init?(_ string: String?) {
        guard let string = string else { return nil }

        let components = string.components(separatedBy: .whitespaces)
        if let amount = Int(components[2]) {
            switch components[1] {
            case "+": self = .add(amount)
            case "*": self = .multiply(amount)
            default: return nil
            }
        } else {
            self = .square
        }
    }
    
    func perform(on value: Int) -> Int {
        switch self {
        case .add(let amount): return value + amount
        case .multiply(let amount): return value * amount
        case .square: return value * value
        }
    }
}

class Monkey {
    let divisibleAmount: Int
    let id: Int
    var inspectionCount = 0
    var items: [Int]
    let operation: Operation
    let testFalse: Int
    let testTrue: Int
    
    init?(_ string: String) {
        let components = string.components(separatedBy: .newlines)
        guard let id = components[0].components(separatedBy: .whitespaces).last?[0],
              let intId = Int(String(id)),
              let items = components[1].components(separatedBy: ": ").last?.components(separatedBy: ", ").compactMap({Int($0)}),
              let divisibleString = components[3].components(separatedBy: .whitespaces).last,
              let divisibleAmount = Int(divisibleString),
              let operationString = components[2].components(separatedBy: "= ").last,
              let operation = Operation(operationString),
              let trueString = components[4].components(separatedBy: .whitespaces).last,
              let testTrue = Int(trueString),
              let falseString = components[5].components(separatedBy: .whitespaces).last,
              let testFalse = Int(falseString)
        else { return nil }
        
        self.id = intId
        self.items = items
        self.operation = operation
        self.divisibleAmount = divisibleAmount
        self.testTrue = testTrue
        self.testFalse = testFalse
    }
}

func calculateMonkeyBusiness(_ monkeys: [Monkey], rounds: Int, useStressReducer: Bool) -> Int {
    let stressReducer = monkeys
        .map { $0.divisibleAmount }
        .reduce(1, *)

    for _ in 1...rounds {
        for monkey in monkeys {
            monkey.items.forEach { item in
                // perform worry operation
                var tempValue = monkey.operation.perform(on: item)
                
                if useStressReducer {
                    // keep stress levels down by performing modulo of all divisible amounts multiplied together
                    tempValue %= stressReducer
                } else {
                    // monkey gets bored
                    tempValue /= 3
                }
                
                // check divisibility
                let isDivisible = tempValue % monkey.divisibleAmount == 0
                if isDivisible, let newMonkey = monkeys.first(where: {  $0.id == monkey.testTrue }) {
                    newMonkey.items.append(tempValue)
                } else if let newMonkey = monkeys.first(where: {  $0.id == monkey.testFalse }) {
                    newMonkey.items.append(tempValue)
                }
                
                // increment inspection count
                monkey.inspectionCount += 1
            }
            monkey.items = []
        }
    }
    
    let monkeyBusiness = monkeys
        .map { $0.inspectionCount }
        .sorted(by: >)
        .prefix(2)
        .reduce(1, *)

    return monkeyBusiness
}

//MARK: - Main

func main() {
    let helper = InputHelper(fileName: "dec11Input")
    var monkeys = helper.inputAsString.components(separatedBy: "\n\n").compactMap(Monkey.init)
    
    let part1 = calculateMonkeyBusiness(monkeys, rounds: 20, useStressReducer: false)
    print("Part 1 Monkey Business: \(part1)")
    
    monkeys = helper.inputAsString.components(separatedBy: "\n\n").compactMap(Monkey.init)
    
    let part2 = calculateMonkeyBusiness(monkeys, rounds: 10000, useStressReducer: true)
    print("Part 2 Monkey Business: \(part2)")
}

main()
