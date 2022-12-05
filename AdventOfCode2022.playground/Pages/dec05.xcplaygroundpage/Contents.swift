import Foundation

typealias StacksDict = [Int: [Character]]

func parseInput(_ input: [String]) -> (StacksDict, [String]) {
    var stacksDict = StacksDict()
    var instructions: [String] = []
    
    input
        .forEach { row in
            // Build stacksDict
            if row.contains("[") {
                var index = 1
                var stackNumber = 1
                while index < row.count {
                    let character = row[index]
                    if character.isLetter {
                        if stacksDict[stackNumber] != nil {
                            stacksDict[stackNumber]?.append(character)
                        } else {
                            stacksDict[stackNumber] = [character]
                        }
                    }
                    stackNumber += 1
                    index += 4
                }
            } else if row.contains("move") {
                // Get instructions
                instructions.append(row)
            }
        }
    
    return (stacksDict, instructions)
}

func buildOutputString(_ stacksDict: StacksDict) -> String {
    let sortedStack = stacksDict.sorted(by: { $0.0 < $1.0 })
    var result = ""
    for pair in sortedStack {
        if let character = pair.value.first {
            result = result + String(character)
        }
    }
    return result
}

struct Instruction {
    let numberToMove: Int
    let source: Int
    let destination: Int
    
    init(instruction: String) {
        let integers = instruction.components(separatedBy: .whitespaces)
            .compactMap { Int($0) }
        self.numberToMove = integers[0]
        self.source = integers[1]
        self.destination = integers[2]
    }
}

//MARK: - Part 1

func part1() -> String {
    let helper = InputHelper(fileName: "dec05Input")
    var (stacksDict, instructions) = parseInput(helper.inputAsArraySeparatedBy(.newlines))
    
    // loop through instructions, move items accordingly
    instructions
        .map(Instruction.init)
        .forEach { instruction in
            for _ in 0...instruction.numberToMove - 1 {
                if let character = stacksDict[instruction.source]?.removeFirst() {
                    stacksDict[instruction.destination]?.insert(character, at: 0)
            }
        }
    }
    
    return buildOutputString(stacksDict)
}

//MARK: - Part 2

func part2() -> String {
    let helper = InputHelper(fileName: "dec05Input")
    var (stacksDict, instructions) = parseInput(helper.inputAsArraySeparatedBy(.newlines))
    
    // loop through instructions, move items accordingly
    instructions
        .map(Instruction.init)
        .forEach { instruction in
            for index in 0...instruction.numberToMove - 1 {
                if let character = stacksDict[instruction.source]?.removeFirst() {
                    stacksDict[instruction.destination]?.insert(character, at: index)
                }
            }
        }
    
    return buildOutputString(stacksDict)
}

print(part1())
print(part2())

