import ArgumentParser

struct Dec182022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - Boiling Boulders", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec182022.txt"

    // MARK: - Data Structures

    struct LavaScanner {
        let lavaPoints: Set<Point3D>
        let start: Point3D
        let xBounds: ClosedRange<Int>
        let yBounds: ClosedRange<Int>
        let zBounds: ClosedRange<Int>

        init (lavaPoints: Set<Point3D>) {
            let xMin = lavaPoints.minimum(for: .x) - 2
            let xMax = lavaPoints.maximum(for: .x) + 2
            let yMin = lavaPoints.minimum(for: .y) - 2
            let yMax = lavaPoints.maximum(for: .y) + 2
            let zMin = lavaPoints.minimum(for: .z) - 2
            let zMax = lavaPoints.maximum(for: .z) + 2
            self.start = Point3D(x: xMin + 1, y: yMin + 1, z: zMin + 1)
            self.lavaPoints = lavaPoints
            self.xBounds = (xMin+1)...(xMax-1)
            self.yBounds = (yMin+1)...(yMax-1)
            self.zBounds = (zMin+1)...(zMax-1)
        }

        func scanLava() -> Int {
            var visited = Set<Point3D>([start])
            var queue = Queue<Point3D>()
            var surfaceArea = 0
            queue.enqueue(start)

            while let current = queue.dequeue() {
                // check that connecting point is within the bounds (set to be 2 pixels wider than the lava in all directions)
                let connectedPoints = current.connectedPoints.filter { isWithinBounds($0) }
                
                for point in connectedPoints {
                    guard !visited.contains(point) && !lavaPoints.contains(point) else { continue }
                    queue.enqueue(point)
                    visited.insert(point)
                }

                surfaceArea += connectedPoints.intersection(lavaPoints).count
            }

            return surfaceArea
        }

        private func isWithinBounds(_ point: Point3D) -> Bool {
            return xBounds.contains(point.x) && yBounds.contains(point.y) && zBounds.contains(point.z)
        }
    }

    // MARK: - Lifecycle

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        let points = Set<Point3D>(lines.compactMap(Point3D.init))
        return points.reduce(0) { partialResult, point in
            return partialResult + point.connectedPoints.subtracting(points).count
        }
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        let points = Set<Point3D>(lines.compactMap(Point3D.init))
        let lavaScanner = LavaScanner(lavaPoints: points)
        return lavaScanner.scanLava()
    }
}

fileprivate extension Point3D {
    init?(_ line: String) {
            let components = line.components(separatedBy: ",")
            guard let x = Int(components[0]),
                  let y = Int(components[1]),
                  let z = Int(components[2])
            else { return nil }

            self.x = x
            self.y = y
            self.z = z
        }
}

fileprivate extension Set where Element == Point3D {
    func minimum(for axis: Point3D.Axis) -> Int {
        var tempMin = Int.max
        switch axis {
            case .x: self.forEach { tempMin = Swift.min(tempMin, $0.x) }
            case .y: self.forEach { tempMin = Swift.min(tempMin, $0.y) }
            case .z: self.forEach { tempMin = Swift.min(tempMin, $0.z) }
        }
        return tempMin
    }

    func maximum(for axis: Point3D.Axis) -> Int {
        var tempMax = Int.min
        switch axis {
            case .x: self.forEach { tempMax = Swift.max(tempMax, $0.x) }
            case .y: self.forEach { tempMax = Swift.max(tempMax, $0.y) }
            case .z: self.forEach { tempMax = Swift.max(tempMax, $0.z) }
        }
        return tempMax
    }
}
