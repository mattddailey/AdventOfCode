import Foundation

//MARK: - Data Structures

class Square {
    let id = UUID()
    var distance = 0
    let name: Character
    var connections: [Square] = []
    let height: Int
    
    init?(char: Character) {
        self.name = char
        
        if char == "S" {
            self.height = 97
        } else if name == "E" {
            self.height = 122
        } else if let ascii = name.asciiValue {
            self.height = Int(ascii)
        } else {
            return nil
        }
    }
}

func findShortestPath(from source: Square) -> Int {
    var queue = Queue<Square>()
    var visited = Set<UUID>()
    visited.insert(source.id)
    queue.enqueue(source)
    
    while let current = queue.dequeue() {
        if current.name == "E" {
            return current.distance
        }
        
        visited.insert(current.id)
        
        for connection in current.connections {
            if !visited.contains(connection.id) {
                queue.enqueue(connection)
                
                connection.distance = current.distance + 1
            }
        }
    }
    return 0
}

func createGraph(input: [String]) -> (Square?, [Square]) {
    // create list of squares
    let squares = input
        .filter { !$0.isEmpty }
        .map { Array($0).compactMap(Square.init) }
    
    var source: Square? = nil
    var part2Sources: [Square] = []
    for j in 0..<squares.count {
        for i in 0..<squares[0].count {
            
            // set source
            let current = squares[j][i]
            if current.name == "S" {
                source = current
                part2Sources.append(current)
            } else if current.name == "a" {
                part2Sources.append(current)
            }
            
            
            // define connections for all squares
            for x in max(0, i-1)...min(i+1, squares[0].count-1) {
                for y in max(0, j-1)...min(j+1, squares.count-1) {
                    if (x != i || y != j) && !(x != i && y != j) {
                        let dest = squares[y][x]
                        let source = squares[j][i]
                        if dest.height <= source.height + 1, dest.name != "S" {
                            source.connections.append(dest)
                        }
                    }
                }
            }
        }
    }
    
    return (source, part2Sources)
}

//MARK: - Main

func part1() -> Int {
    let helper = InputHelper(fileName: "dec12Input")
    
    // create list of squares
    let input = helper.inputAsString.components(separatedBy: .newlines)
    let (source, _) = createGraph(input: input)
  
    guard let source = source  else { return 0 }
    let path = findShortestPath(from: source)

    return path
}

func part2() -> Int {
    let helper = InputHelper(fileName: "dec12Input")
    
    // create list of squares
    let input = helper.inputAsString.components(separatedBy: .newlines)
    let (_, sources) = createGraph(input: input)
  
    let result = sources
        .map(findShortestPath)
        .min()
    
    return result ?? 0
}

print(part1())
print(part2())
