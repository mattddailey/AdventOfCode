import Foundation

// MARK: - Data Structures

extension Point {
    var oneDown: Point {
        return Point(x: self.x, y: self.y + 1)
    }
    
    var oneDownOneLeft: Point {
        return Point(x: self.x - 1, y: self.y + 1)
    }
    
    var oneDownOneRight: Point {
        return Point(x: self.x + 1, y: self.y + 1)
    }
}

struct Line {
    let start: Point
    let end: Point
    let direction: Direction
    
    init?(_ start: String, _ end: String) {
        let startComponents = start.components(separatedBy: ",")
        let endComponents = end.components(separatedBy: ",")
        guard startComponents.count == 2,
              endComponents.count == 2,
              let startx = Int(startComponents[0]),
              let starty = Int(startComponents[1]),
              let endx = Int(endComponents[0]),
              let endy = Int(endComponents[1])
        else { return nil }
        
        self.start = Point(x: startx, y: starty)
        self.end = Point(x: endx, y: endy)
        // set direction of line
        if startx < endx {
            self.direction = .east
        } else if endx < startx {
            self.direction = .west
        } else if starty < endy {
            self.direction = .south
        } else {
            self.direction = .north
        }
    }
}

// MARK: - Shared

class CaveMapper {
    var occupiedPoints = Set<Point>()
    var minY = 0
    let start = Point(x: 500, y: 0)
    
    var floor: Int {
        return minY + 2
    }
    
    func drawLines(_ lines: [Line]) {
        for line in lines {
            var temp = line.start
            occupiedPoints.insert(temp)
            minY = max(temp.y, line.end.y, minY)
            while (temp.x != line.end.x) ^ (temp.y != line.end.y) {
                switch line.direction {
                case .north: temp = Point(x: temp.x, y: temp.y - 1)
                case .south: temp = Point(x: temp.x, y: temp.y + 1)
                case .east: temp = Point(x: temp.x + 1, y: temp.y)
                case .west: temp = Point(x: temp.x - 1, y: temp.y)
                }
                occupiedPoints.insert(temp)
                if temp.y > minY {
                    minY = temp.y
                }
            }
        }
    }
    
    func dropSand(hasFloor: Bool) -> Int {
        var sand = start
        var settledSandCount = 0
        while hasFloor ? !occupiedPoints.contains(start) : sand.y <= minY {
            if hasFloor, sand.oneDown.y == floor {
                occupiedPoints.insert(sand)
                settledSandCount += 1
                sand = Point(x: 500, y: 0)
            } else if !occupiedPoints.contains(sand.oneDown) {
                sand = sand.oneDown
            } else if !occupiedPoints.contains(sand.oneDownOneLeft) {
                sand = sand.oneDownOneLeft
            } else if !occupiedPoints.contains(sand.oneDownOneRight) {
                sand = sand.oneDownOneRight
            } else {
                occupiedPoints.insert(sand)
                settledSandCount += 1
                sand = Point(x: 500, y: 0)
            }
        }
        
        return settledSandCount
    }
}

// converts input to a list of lines
func buildLines() -> [Line] {
    var lines: [Line] = []
    let helper = InputHelper(fileName: "dec14Input")
    helper.inputAsString.components(separatedBy: .newlines)
        .filter { !$0.isEmpty }
        .forEach { line in
            let componenets = line.components(separatedBy: " -> ")
            for (index, point) in componenets.enumerated() {
                guard index != componenets.count-1 else { return }
                let start = point
                let end  = componenets[index+1]
                if let line = Line(start, end) {
                    lines.append(line)
                }
            }
        }
    
    return lines
}

// MARK: - Part 1

func part1() -> Int {
    let lines = buildLines()
    let caveMapper = CaveMapper()
    
    // place rocks
    caveMapper.drawLines(lines)
    
    // drop sand, count how many come to rest
    return caveMapper.dropSand(hasFloor: false)
}

// MARK: - Part 2

func part2() -> Int {
    let lines = buildLines()
    let caveMapper = CaveMapper()
    
    // place rocks
    caveMapper.drawLines(lines)
    
    // drop sand, count how many come to rest
    return caveMapper.dropSand(hasFloor: true)
}

print(part1())
print(part2())
