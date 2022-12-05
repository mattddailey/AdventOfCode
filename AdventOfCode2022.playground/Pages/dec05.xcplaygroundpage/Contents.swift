import Foundation

func part1() -> String {
    
    var stacksDict = [Int: [Character]]()
    var instructions: [String] = []
    
    let helper = InputHelper(fileName: "dec05Input")
    helper.inputAsArraySeparatedBy(.newlines)
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
    
    // loop through instructions, move items accordingly using removeFirst & append
    instructions.forEach { instruction in
        let readableInstructions = instruction.components(separatedBy: .whitespaces)
            .compactMap { Int($0) }
        let numberToMove = readableInstructions[0]
        let source = readableInstructions[1]
        let destination = readableInstructions[2]
        
        for _ in 1...numberToMove {
            if let character = stacksDict[source]?.removeFirst() {
                stacksDict[destination]?.insert(character, at: 0)
            }
        }
    }
    
    
    // sort dict, loop through and create string of elements on top
    let sortedStack = stacksDict.sorted(by: { $0.0 < $1.0 })
    var result = ""
    for pair in sortedStack {
        if let character = pair.value.first {
            result = result + String(character)
        }
        
    }

    return result
}

func part2() -> String {
    var stacksDict = [Int: [Character]]()
    var instructions: [String] = []
    
    let helper = InputHelper(fileName: "dec05Input")
    helper.inputAsArraySeparatedBy(.newlines)
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
    
    // loop through instructions, move items accordingly using removeFirst & append
    instructions.forEach { instruction in
        let readableInstructions = instruction.components(separatedBy: .whitespaces)
            .compactMap { Int($0) }
        let numberToMove = readableInstructions[0]
        let source = readableInstructions[1]
        let destination = readableInstructions[2]
        
        var tempArray: [Character] = []
        for _ in 1...numberToMove {
            if let character = stacksDict[source]?.removeFirst() {
                tempArray.append(character)
            }
        }
        tempArray.reversed().forEach {
            stacksDict[destination]?.insert($0, at: 0)
        }
    }
    
    
    // sort dict, loop through and create string of elements on top
    let sortedStack = stacksDict.sorted(by: { $0.0 < $1.0 })
    var result = ""
    for pair in sortedStack {
        if let character = pair.value.first {
            result = result + String(character)
        }
        
    }

    return result
}



print(part1())
print(part2())

