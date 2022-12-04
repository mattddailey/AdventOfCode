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
    
    var asClosedRange: ClosedRange<Int> {
        return lower...upper
    }
}

func isFullyContained(_ ranges: [ClosedRange<Int>]) -> Bool {
    if ranges[0].clamped(to: ranges[1]) == ranges[0] || ranges[1].clamped(to: ranges[0]) == ranges[1]   {
        return true
    } else {
        return false
    }
}


func separateElves(_ pair: String) -> [ClosedRange<Int>]? {
    let elves = pair.components(separatedBy: ",")
    let firstElf = SectionAssignment(elves.first)
    let secondElf = SectionAssignment(elves.last)
    
    if let firstElf = firstElf, let secondElf = secondElf {
        return [firstElf.asClosedRange, secondElf.asClosedRange]
    } else {
        return nil
    }
}

//MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "dec04Input")
    let reconsiderCount = helper.inputAsArraySeparatedBy(.newlines)
        .filter { !$0.isEmpty }
        .compactMap(separateElves)
        .map(isFullyContained)
        .filter { $0 }
        .count
        
    return reconsiderCount
}


print(part1())
