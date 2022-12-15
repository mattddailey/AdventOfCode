import Foundation

// MARK: - Data Structures

struct Sensor: Hashable {
    let point: Point
    let closestBeacon: Point
    
    init?(_ parts: [String]) {
        if let sensorX = Int(String(parts[0].dropLast().dropFirst(2))),
           let sensorY = Int(String(parts[1].dropLast().dropFirst(2))),
           let beaconX = Int(String(parts[2].dropLast().dropFirst(2))),
           let beaconY = Int(String(parts[3].dropFirst(2))) {
            self.point = Point(x: sensorX, y: sensorY)
            self.closestBeacon = Point(x: beaconX, y: beaconY)
        } else {
            return nil
        }
        
    }
    
    var distanceToBeacon: Int {
        return point.manhattanDistance(to: closestBeacon)
    }
    
    func spreadContains(_ y: Int) -> Bool {
        // check if the spread (manhattan radius) of a sensor contains the row we care about
        let spread = (self.point.y - distanceToBeacon)...(self.point.y + distanceToBeacon)
        return spread.contains(y)
    }
}

extension Point {
    func spreadForRadius(_ radius: Int, minimum: Int? = nil, maximum: Int? = nil) -> Set<Int> {
        if let minimum = minimum, let maximum = maximum {
            return Set(max(self.x-radius, minimum)...min(self.x+radius, maximum))
        } else {
            return Set(self.x-radius...self.x+radius)
        }
    }
}

// MARK: - Shared

func createMap(_ input: String) -> (Set<Sensor>, Set<Point>) {
    let lines = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
    var sensors = Set<Sensor>()
    var beaconPoints = Set<Point>()
    lines.forEach { line in
        let components = line.components(separatedBy: .whitespaces)
        if components.count == 10,
           let sensor = Sensor([components[2], components[3], components[8], components[9]]) {
            sensors.insert(sensor)
            beaconPoints.insert(sensor.closestBeacon)
        }
    }
    
    return (sensors, beaconPoints)
}

// MARK: - Main

func part1() {
    let row = 2000000

    let input = try? String(contentsOfFile: "Input/dec15Input.txt")
    guard let input = input else { return }
    let (sensors, beaconPoints) = createMap(input)
    
    var result = Set<Int>()
    var xIndexForBeaconsInRow = Set<Int>()
    for beacon in beaconPoints {
        guard beacon.y == row else { continue }
        xIndexForBeaconsInRow.insert(beacon.x)
    }

    sensors
        .filter { $0.spreadContains(row) } // use only sensors that have a spread that contains the desired row
        .forEach {
            let yDiff =  row - $0.point.y
            let radius = $0.distanceToBeacon - abs(yDiff)
            result.formUnion($0.point.spreadForRadius(radius)) // builds list of x indexes where beacon cannot be present
        }
    
    print("Beacon cannot be present in \(result.subtracting(xIndexForBeaconsInRow).count) points in row \(row)")
}

func part2() -> Int {
    
    let max = 4000000
    
    let input = try? String(contentsOfFile: "Input/dec15Input.txt")
    guard let input = input else { return 0 }
    let (sensors, _) = createMap(input)

    for y in 0...max {
        var x = 0
        while x <= max {
            let current = Point(x: x, y: y)
            if let sensor = sensors.first(where: { $0.point.manhattanDistance(to: current) <= $0.distanceToBeacon }) {
                // use spread of closest sensor to determine radius on given line, and advance x as much as possible
                let xDiff = sensor.point.x - x
                let yDiff =  y - sensor.point.y
                let radius = sensor.distanceToBeacon - abs(yDiff)
                x += (xDiff + radius + 1)
            } else {
                // found the point that is not in proximity of a sensor
                return 4000000 * x + y
            }
        }
    }
    
    // should never get here
    return 0
}

part1()
print("Tuning frequency: \(part2())")
