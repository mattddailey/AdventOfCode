import Foundation

// MARK: - Shared

func caloriesList() -> [Int] {
    let input = getInputData(from: "Day1Input")
    let calories = input.components(separatedBy: .newlines)

    var calorieCount = 0
    var caloriesList: [Int] = []
    for calorie in calories {
        if !calorie.isEmpty {
            calorieCount += Int(calorie)!
        } else {
            caloriesList.append(calorieCount)
            calorieCount = 0
        }
    }
    
    return caloriesList
}

// MARK: - Part 1

func part1() -> Int {
    let maxCalories = caloriesList()
        .max()!
    
    return maxCalories
}

// MARK: - Part 2

func part2() -> Int {
    let maxThreeCalories = caloriesList()
        .sorted(by: >)
        .prefix(3)
        .reduce(0, +)
    
    return maxThreeCalories
}

print(part1())
print(part2())
