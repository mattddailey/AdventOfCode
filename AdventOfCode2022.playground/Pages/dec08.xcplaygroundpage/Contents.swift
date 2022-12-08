import Foundation

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

func treeIsVisible(col: [Int], row: [Int], x: Int, y: Int, currentTree: Int) -> Bool {
    // check if on the edge
    if y == 0 || y == col.count - 1 || x == 0 || x == row.count - 1 {
        return true
    }
    
    return row[x] > row[0..<x].max() ?? .max ||
    row[x] > row[x+1..<row.count].max() ?? .max ||
    row[x] > col[0..<y].max() ?? .max ||
    row[x] > col[y+1..<col.count].max() ?? .max
}

//MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "dec08Input")
    let rows = helper.inputAsArraySeparatedBy(.newlines)
        .map { Array($0).compactMap { Int(String($0)) } }
    let cols = transpose(rows)

    let count = rows.enumerated()
        .map { y, row in
            row.indices
                .map { treeIsVisible(col: cols[$0], row: row, x: $0, y: y, currentTree: row[$0]) }
                .filter { $0 }
                .count
        }
        .reduce(0, +)
    
    return count
}

//MARK: - Part 2

func part2() -> Int {
    let helper = InputHelper(fileName: "dec08Input")
    let rows = helper.inputAsArraySeparatedBy(.newlines)
        .map { Array($0).compactMap { Int(String($0)) } }
    let cols = transpose(rows)
    
    let scenicScore = rows.enumerated()
        .map { y, row in
            row.indices
                .map { calculateScenicScore(col: cols[$0], row: row, x: $0, y: y, currentTree: row[$0]) }
                .max()
        }
        .compactMap { $0 }
        .max()
    
    return scenicScore ?? 0
}

print(part1())
print(part2())
