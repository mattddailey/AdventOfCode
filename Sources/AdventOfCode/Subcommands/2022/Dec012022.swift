import ArgumentParser
import AOCDayPackage

@AOCDay
struct Dec012022: AsyncParsableCommand, AOCDayProtocol {
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
