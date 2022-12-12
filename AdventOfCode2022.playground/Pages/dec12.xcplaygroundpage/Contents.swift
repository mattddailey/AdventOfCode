import Foundation

struct Location: Hashable {
    let x: Int
    let y: Int
}

extension Character {
    var height: Int {
        if self == "S" {
            return 97
        } else if self == "E" {
            return 122
        } else if let ascii = self.asciiValue {
            return Int(ascii)
        } else {
            return Int.max
        }
    }
}

func findShortestPath(from source: Location, to destination: Location, heights: [[Int]]) -> Int? {
    var distances: [Location: Int] = [:]
    var queue = Queue<Location>()
    var visited = Set<Location>()
    
    distances[source] = 0
    visited.insert(source)
    queue.enqueue(source)
    
    while let current = queue.dequeue() {
        if current == destination {
            return distances[destination]
        }
        
        let x = current.x
        let y = current.y
        let currentHeight = heights[y][x]
        for i in max(0, x-1)...min(x+1, heights[0].count-1) {
            for j in max(0, y-1)...min(y+1, heights.count-1) {
                if (x != i || y != j) && !(x != i && y != j) {
                    let destHeight = heights[j][i]
                    if destHeight <= currentHeight + 1  {
                        let location = Location(x: i, y: j)
                        if !visited.contains(location) {
                            visited.insert(location)
                            queue.enqueue(location)
                            if let sourceDistance = distances[current] {
                                distances[location] = sourceDistance + 1
                            }
                        }
                    }
                }
            }
        }
    }
    return 0
}

func main() {
    var source: Location? = nil
    var destination: Location? = nil
    let helper = InputHelper(fileName: "dec12Input")
    let input = helper.inputAsArraySeparatedBy(.newlines)
        .filter { !$0.isEmpty }
        .map { Array($0) }

    var aLocations: [Location] = []
    for y in 0..<input.count {
        for x in 0..<input[0].count {
            if input[y][x] == "S" {
                source = Location(x: x, y: y)
                let a = Location(x: x, y: y)
                aLocations.append(a)
            } else if input[y][x] == "E" {
                destination = Location(x: x, y: y)
            } else if input[y][x] == "a" {
                let a = Location(x: x, y: y)
                aLocations.append(a)
            }
        }
    }
    
    let heights = input
        .map { row in
            row.compactMap { $0.height }
        }

    guard let source = source, let destination = destination else {
        print("Could not find source / destination")
        return
    }

    let shortestPath = findShortestPath(from: source, to: destination, heights: heights)
    print("Part 1 shortest path: \(shortestPath ?? 0)")
    
//    let shortestPathPart2 = aLocations
//        .compactMap { findShortestPath(from: $0, to: destination, heights: heights) }
//        .min()
//    print("Part 2 shortest path: \(shortestPathPart2)")
}

main()
