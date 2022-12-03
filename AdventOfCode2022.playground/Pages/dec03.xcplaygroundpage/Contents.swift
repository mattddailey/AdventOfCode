import Foundation

// MARK: - Shared

func priority(_ character: Character) -> Int {
    let ascviiValue = Int(character.asciiValue ?? 0)
    if character.isUppercase {
        return ascviiValue - 38
    } else {
        return ascviiValue - 96
    }
}

// MARK: - Part 1

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

// MARK: - Part 2

func part2() -> Int {
    let helper = InputHelper(fileName: "dec03Input")
    var prevElf: String? = nil
    var prevPrevElf: String?  = nil
    let prioritySum = helper.inputAsArraySeparatedBy(.newlines)
        .compactMap { elf -> Character? in
            guard prevElf != nil, prevPrevElf != nil else {
                prevPrevElf = prevElf
                prevElf = elf
                return nil
            }
            let sharedElement = elf.first(where: { element in
                prevElf?.contains(where: { $0 == element }) ?? false &&
                prevPrevElf?.contains(where: { $0 == element }) ?? false
            })?.description
            prevPrevElf = nil
            prevElf = nil
            return sharedElement?.first
        }
        .map(priority)
        .reduce(0, +)
    return prioritySum
}

print(part1())
print(part2())
