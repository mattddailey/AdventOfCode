import Foundation

struct SectionAssignment {
    let lower: Int
    let upper: Int
    
    init?(_ asString: String?) {
        let components = asString?.components(separatedBy: "-")
        guard let lower = components?.first, !lower.isEmpty,
              let upper = components?.last, !upper.isEmpty
        else { return nil }
        
        self.lower = Int(lower) ?? 0
        self.upper = Int(upper) ?? 0
    }
    
    var asSet: Set<Int> {
        return Set(lower...upper)
    }
}

func containsOverlap(_ sets: [Set<Int>]) -> Bool {
    return !sets[0].isDisjoint(with: sets[1])
}

func isFullyContained(_ sets: [Set<Int>]) -> Bool? {
    if (sets[0].intersection(sets[1]) == sets[0]) ||
        (sets[0].intersection(sets[1]) == sets[1]) {
        return true
    } else {
        return nil
    }
}

func convertToSets(_ pair: String) -> [Set<Int>]? {
    let elves = pair.components(separatedBy: ",")
    let firstElf = SectionAssignment(elves.first)
    let secondElf = SectionAssignment(elves.last)
    
    if let firstElf = firstElf, let secondElf = secondElf {
        return [firstElf.asSet, secondElf.asSet]
    } else {
        return nil
    }
}

//MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "dec04Input")
    let reconsiderCount = helper.inputAsArraySeparatedBy(.newlines)
        .filter { !$0.isEmpty }
        .compactMap(convertToSets)
        .compactMap(isFullyContained)
        .count
        
    return reconsiderCount
}

//MARK: - Part 2

func part2() -> Int {
    let helper = InputHelper(fileName: "dec04Input")
    let overlapCount = helper.inputAsArraySeparatedBy(.newlines)
        .filter { !$0.isEmpty }
        .compactMap(convertToSets)
        .map(containsOverlap)
        .filter { $0 }
        .count
    
    return overlapCount
}

print(part1())
print(part2())
