import Foundation

// MARK: - Data Structures

struct Valve: Hashable {
    let index: Int
    let name: String
    let flowRate: Int
}

// MARK: - Shared

class VolcanoEscape {
    
    // time until volcano erupts
    let timeRemaining = 30
    
    // keep track of valves
    let allValves: Set<Valve>
    var openValves = Set<Valve>()
    let zeroValves: Set<Valve>
    
    // shortest path from each valve to another
    let distances: [[Int]]
    
    // starting valve
    let start: Valve?
    
                        
    init(valves: [Valve], distances: [[Int]]) {
        self.allValves = Set(valves)
        self.distances = distances
        self.start = allValves.first(where: { $0.name == "AA" })
        self.zeroValves = allValves.filter({ $0.flowRate == 0 })
    }
    
    func determineMaximumPressureReleased() -> Int {
        let valves = Array(allValves.subtracting(zeroValves))
        
        // find all permutations of valves
        let permutations: [[Valve]] = [[]]
        
        // loop through list of permutations, calculate max pressure released
        let maxPressure = permutations
            .map(processPath)
            .max()
        
        return maxPressure ?? 0
    }
    
    // takes a list of valves, traverses them in order, and determines flow
    func processPath(_ valves: [Valve]) -> Int {
        guard let start = start else { return 0 }
        var currentValve = start
        var mutableValves = valves
        var distanceToNextValve = -1
        var cumulativePressure = 0
        var time = 1
        
        while time <= timeRemaining {
            print("Minute: \(time)")
            
            // add to pressure
            cumulativePressure = openValves.reduce(cumulativePressure, { partialResult, valve in
                print("Valve \(valve.name) is open, releasing \(valve.flowRate) pressure")
                return partialResult + valve.flowRate
            })
            // time to open
            if distanceToNextValve == 0 {
                print("Opening Valve \(currentValve.name)")
                openValves.insert(currentValve)
                distanceToNextValve = -1
            }
            // need to continue move to next valve
            else if distanceToNextValve > 0 {
                distanceToNextValve -= 1
            }
            // need to open next valve
            else if !mutableValves.isEmpty {
                let nextValve = mutableValves.removeFirst()
                // determine how far I need to travel to next valve
                let distance = distances[currentValve.index][nextValve.index]
                print("Distance to next valve: \(distance)")
                currentValve = nextValve
                // make one move here
                distanceToNextValve = distance - 1
            }
            
            time += 1
        }
        
        return cumulativePressure
    }
}

func createDataStructures(_ input: [String]) -> ([Valve], [[Int]]) {
    // create valves
    var valves: [Valve] = []
    for (index, line) in input.enumerated() {
        let components = line.components(separatedBy: .whitespaces)
        if let flowRate = Int(String(components[4].dropLast().dropFirst(5))) {
            valves.append(Valve(index: index, name: components[1], flowRate: flowRate))
        }
    }
    
    // create initial distance matrix
    let max = 999
    let distanceRow = Array(repeating: max, count: input.count)
    var distances = Array(repeating: distanceRow, count: input.count)
    for (index, line) in input.enumerated() {
        distances[index][index] = 0
        let components = line.components(separatedBy: .whitespaces)
        let source = valves.first(where: { $0.name == components[1] })
        for index in 9..<components.count {
            let destinationName = index == components.count - 1 ? components[index] : String(components[index].dropLast())
            let destination = valves.first(where: { $0.name == destinationName })
            if let source = source, let destination = destination  {
                distances[source.index][destination.index] = 1
            }
        }
    }
    
    // apply Floyd Warshall to distance matrix
    let adjMatrix = FloydWarshall(distances)

    return (valves, adjMatrix)
}

// MARK: - Main

func main() {
    let helper = InputHelper(fileName: "dec16Input")
    let input = helper.inputAsArraySeparatedBy(.newlines)
    
    let (valves, distances) = createDataStructures(input)

    let volcanoEscape = VolcanoEscape(valves: valves, distances: distances)
//    let test = [valves[3], valves[1], valves[9], valves[7], valves[4], valves[2]]
    
    let result = volcanoEscape.determineMaximumPressureReleased()

    print("Part 1 Max Pressure: \(result)")
}

main()
