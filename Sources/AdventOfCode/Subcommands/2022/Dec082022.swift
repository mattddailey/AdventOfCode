import ArgumentParser

struct Dec082022: ParsableCommand, AOCDayProtocol {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - Treetop Tree House", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec082022.txt"

    // MARK: - Data Structures

    // MARK: - Lifecycle

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        let rows = lines
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

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        let rows = lines
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

    func calculateScenicScore(col: [Int], row: [Int], x: Int, y: Int, currentTree: Int) -> Int {
        let left = Array(row[0..<x].reversed())
        let right = Array(row[x+1..<row.count])
        let above = Array(col[0..<y].reversed())
        let below = Array(col[y+1..<col.count])

        let leftDistance = visibleDistance(left, currentTree: currentTree)
        let rightDistance = visibleDistance(right, currentTree: currentTree)
        let aboveDistance = visibleDistance(above, currentTree: currentTree)
        let belowDistance = visibleDistance(below, currentTree: currentTree)

        return leftDistance * rightDistance * aboveDistance * belowDistance
    }

    func transpose(_ input: [[Int]]) -> [[Int]] {
        guard !input.isEmpty else { return input }
        var result = [[Int]]()
        for index in 0..<input.first!.count {
            result.append(input.map{$0[index]})
        }
        return result
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

    func visibleDistance(_ treeHeights: [Int], currentTree: Int) -> Int {
        var visibleDistance = 0
        for height in treeHeights {
            visibleDistance += 1
            if height >= currentTree {
                break
            }
        }
        return visibleDistance
    }
}
