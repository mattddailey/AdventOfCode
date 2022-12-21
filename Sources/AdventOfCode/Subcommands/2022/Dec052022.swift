import ArgumentParser

struct Dec052022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - 2022 December 05", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec052022.txt"

    // MARK: - Data Structures

    typealias StacksDict = [Int: [Character]]

    struct Instruction {
        let numberToMove: Int
        let source: Int
        let destination: Int
        
        init(string: String) {
            let integers = string.components(separatedBy: .whitespaces)
                .compactMap { Int($0) }
            self.numberToMove = integers[0]
            self.source = integers[1]
            self.destination = integers[2]
        }
    }

    // MARK: - Lifecycle

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)
        
        _ = part1(lines)
        _ = part2(lines)
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        var (stacksDict, instructions) = parseInput(lines)

        // loop through instructions, move items accordingly
        instructions
            .forEach { instruction in
                stacksDict = moveCrate(accordingTo: instruction, stacksDict: stacksDict)
            }
        
        print("Part 1: \(buildOutputString(stacksDict))")
        return 0
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        var (stacksDict, instructions) = parseInput(lines)

        // loop through instructions, move items accordingly
        instructions
            .forEach { instruction in
                stacksDict = moveCrate(accordingTo: instruction, moveAsGroup: true, stacksDict: stacksDict)
            }
        
        print("Part 2: \(buildOutputString(stacksDict))")
        return 0
    }

    func parseInput(_ input: [String]) -> (StacksDict, [Instruction]) {
        var stacksDict = StacksDict()
        var instructions: [Instruction] = []
        
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
                    let instruction = Instruction(string: row)
                    instructions.append(instruction)
                }
            }
        
        return (stacksDict, instructions)
    }

    func moveCrate(accordingTo instruction: Instruction, moveAsGroup: Bool = false, stacksDict: StacksDict) -> StacksDict {
        var mutableStacksDict = stacksDict
        
        for index in 0...instruction.numberToMove - 1 {
            if let character = mutableStacksDict[instruction.source]?.removeFirst() {
                mutableStacksDict[instruction.destination]?.insert(character, at: moveAsGroup ? index : 0)
            }
        }
    
        return mutableStacksDict
    }

    func buildOutputString(_ stacksDict: StacksDict) -> String {
        let sortedStack = stacksDict.sorted(by: { $0.0 < $1.0 })
        
        return sortedStack.reduce("") { partialResult, pair in
            if let character = pair.value.first {
                return partialResult.appending(String(character))
            }
            return partialResult
        }
    }

}