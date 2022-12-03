import Foundation

func priority(_ character: Character) -> Int {
    let ascviiValue = Int(character.asciiValue ?? 0)
    if character.isUppercase {
        return ascviiValue - 38
    } else {
        return ascviiValue - 96
    }
}

func part1() -> Int {
    let helper = InputHelper(fileName: "dec03Input")
    let prioritySum = helper.inputAsArraySeparatedBy(.newlines)
        .compactMap { ruckSackContents -> Character? in
            let firstCompartment = String(ruckSackContents.prefix(ruckSackContents.count / 2))
            let secondCompartment = String(ruckSackContents.suffix(ruckSackContents.count / 2))
            let sharedElement = firstCompartment.first(where: { element in
                secondCompartment.contains(where: { $0 == element })
            })?.description
            return sharedElement?.first
        }
        .map(priority)
        .reduce(0, +)
    
    return prioritySum
}

func part2() -> Int {
    let helper = InputHelper(fileName: "dec03Input")
    let elves = helper.inputAsArraySeparatedBy(.newlines)
    
    var offset = 0
    var prioritySum = 0
    while offset < elves.count - 3 {
        let elfOne = elves[offset + 0]
        let elfTwo = elves[offset + 1]
        let elfThree = elves[offset + 2]
        
        let sharedElement = elfOne.first(where: { element in
            elfTwo.contains(where: { $0 == element }) &&
            elfThree.contains(where: { $0 == element })
        })?.description

        if let character = sharedElement?.first {
            prioritySum += priority(character)
        }
        offset += 3

    }
    return prioritySum
}

print(part1())
print(part2())
