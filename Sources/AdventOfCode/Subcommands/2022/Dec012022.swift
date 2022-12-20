import ArgumentParser

struct Dec012022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - 2022 December 01", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec012022.txt"

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    func part1(_ lines: [String]) -> Int {
        let maxCalories = caloriesPerElf(lines)
            .max() ?? 0
        
        return maxCalories
    }

    func part2(_ lines: [String]) -> Int {
        let maxCalories = caloriesPerElf(lines)
            .sorted(by: >)
            .prefix(3)
            .reduce(0, +)
        
        return maxCalories
    }

    // MARK: - Shared
    
    func caloriesPerElf(_ caloriesArray: [String]) -> [Int] {
        var calorieCount = 0
        var caloriesList: [Int] = []
        for calorie in caloriesArray {
            if !calorie.isEmpty {
                calorieCount += Int(calorie)!
            } else {
                caloriesList.append(calorieCount)
                calorieCount = 0
            }
        }           
        
        return caloriesList
    }
}