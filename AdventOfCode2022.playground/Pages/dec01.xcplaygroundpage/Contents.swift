import Foundation

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

// MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "dec01Input")
    let caloriesArray = helper.inputAsArraySeparatedBy(.newlines)
    
    let maxCalories = caloriesPerElf(caloriesArray)
        .max()!
    
    return maxCalories
}

// MARK: - Part 2

func part2() -> Int {
    let helper = InputHelper(fileName: "dec01Input")
    let caloriesArray = helper.inputAsArraySeparatedBy(.newlines)
    
    let maxThreeCalories = caloriesPerElf(caloriesArray)
        .sorted(by: >)
        .prefix(3)
        .reduce(0, +)
    
    return maxThreeCalories
}

print(part1())
print(part2())
