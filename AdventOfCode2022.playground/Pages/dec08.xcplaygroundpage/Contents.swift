

import Foundation
import Darwin

func calculateScenicScore(col: [Int], row: [Int], x: Int, y: Int, currentTree: Int) -> Int {
    let left = row[0..<x].reversed()
    let right = row[x+1..<row.count]
    let above = col[0..<y].reversed()
    let below = col[y+1..<col.count]

    var leftScenicScore = 0
    for tree in left {
        leftScenicScore += 1
        if tree >= currentTree {
            break
        }
    }
    
    var rightScenicScore = 0
    for tree in right {
        rightScenicScore += 1
        if tree >= currentTree {
            break
        }
    }
    
    var aboveScenicScore = 0
    for tree in above {
        aboveScenicScore += 1
        if tree >= currentTree {
            break
        }
    }
    
    var belowScenicScore = 0
    for tree in below {
        belowScenicScore += 1
        if tree >= currentTree {
            break
        }
    }
    
    return leftScenicScore * rightScenicScore * aboveScenicScore * belowScenicScore
}

//MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "dec08Input")
    let rows = helper.inputAsArraySeparatedBy(.newlines)
        .map { Array($0).compactMap { char in Int(String(char)) } }
    let cols = transpose(rows)
    
    var count = 0
    for (index, row) in rows.enumerated() {
        for i in 0..<row.count {
            if index == 0 || index == rows.count - 1 || i == 0 || i == row.count - 1 {

                count += 1
            }
            else {
                guard let leftMax = row[0..<i].max(),
                      let rightMax = row[i+1..<row.count].max(),
                      let aboveMax = cols[i][0..<index].max(),
                      let belowMax = cols[i][index+1..<cols.count].max() else { continue }
                if row[i] > leftMax ||
                    row[i] > rightMax ||
                    row[i] > belowMax ||
                    row[i] > aboveMax {
                    count += 1
                }
            }
        }
    }
    
    return count
}

//MARK: - Part 2

func part2() -> Int {
    let helper = InputHelper(fileName: "dec08Input")
    let rows = helper.inputAsArraySeparatedBy(.newlines)
        .map { Array($0).compactMap { char in Int(String(char)) } }
    let cols = transpose(rows)
    
    var scenicScore = 0
    for (index, row) in rows.enumerated() {
        for i in 0..<row.count {
            let currentScenicScore = calculateScenicScore(col: cols[i], row: row, x: i, y: index, currentTree: row[i])
            if currentScenicScore > scenicScore {
                scenicScore = currentScenicScore
            }
        }
    }
    return scenicScore
}

print(part1())
print(part2())
