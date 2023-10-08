import ArgumentParser

struct Dec042022: ParsableCommand, AOCDayProtocol {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - 2022 December 04", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec042022.txt"

    // MARK: - Data Structures

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

    // MARK: - Lifecycle

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        let reconsiderCount = lines
            .compactMap(convertToSets)
            .compactMap(isFullyContained)
            .count
        
        return reconsiderCount
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        let overlapCount = lines
            .compactMap(convertToSets)
            .map(containsOverlap)
            .filter { $0 }
            .count
        
        return overlapCount
    }

    func containsOverlap(_ sets: [Set<Int>]) -> Bool {
        return !sets[0].isDisjoint(with: sets[1])
    }

    func isFullyContained(_ sets: [Set<Int>]) -> Bool? {
        if (sets[0].isSubset(of: sets[1])) ||
            (sets[1].isSubset(of: sets[0])) {
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
}
