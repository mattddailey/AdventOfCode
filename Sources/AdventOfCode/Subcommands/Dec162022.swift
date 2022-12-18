import Algorithms
import ArgumentParser
import Foundation

struct Dec162022: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - 2022 December 16", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec162022.txt"

    // MARK: - Data Structures

    struct Valve: Hashable, Codable {
        // index of valve in adjacency matrix
        let index: Int
        let name: String
        let flowRate: Int
        // Maps Neighbor valve name to an Int representing the distance to this valve
        var neighbors: [String : Int] = [:]
    }


    // MARK: - Lifecycle

    mutating func run() throws {
        let input  = try String(contentsOfFile: path)
        let start = Date()
        defer { print("Part 1 complete in \(Date().timeIntervalSince(start)) seconds") }

        let valves = createDataStructures(input.components(separatedBy: .newlines).filter { !$0.isEmpty })

        if let start = valves["AA"] {
            let maxFlow = maxFlow(valves: valves, current: start)
            print("Part 1 Max Flow: \(maxFlow)")
        }

    }

    // MARK: - Helpers

    func createDataStructures(_ input: [String]) -> [String : Valve] {
        // dict containing a mapping of valve name to index
        var nonZeroNamesWithIndex: [String : Int] = [:]

        // create valves, keep track of nonzero valve name & indexes
        var valves: [String : Valve] = [:]
        for (index, line) in input.enumerated() {
            let components = line.components(separatedBy: .whitespaces)
            if let flowRate = Int(String(components[4].dropLast().dropFirst(5))) {
                let valve = Valve(index: index, name: components[1], flowRate: flowRate)
                valves[components[1]] = valve
                if valve.flowRate != 0 || valve.name == "AA" {
                    nonZeroNamesWithIndex[valve.name] = index
                }
            }
        }

        // create initial distance matrix
        let max = 999
        let distanceRow = Array(repeating: max, count: input.count)
        var distances = Array(repeating: distanceRow, count: input.count)
        for (index, line) in input.enumerated() {
            distances[index][index] = 0
            let components = line.components(separatedBy: .whitespaces)
            let source = valves[components[1]]
            for index in 9..<components.count {
                let destinationName = index == components.count - 1 ? components[index] : String(components[index].dropLast())
                let destination = valves[destinationName]
                if let source = source, let destination = destination  {
                    distances[source.index][destination.index] = 1
                }
            }
        }
        
        // apply Floyd Warshall to distance matrix to get all pairs shortest paths
        let adjMatrix = FloydWarshall(distances)

        // loop through all indexes of vertexes with flow, add neighbors to valves
        for s in nonZeroNamesWithIndex {
            for d in nonZeroNamesWithIndex {
                guard s != d else { continue }
                // adds entry to neighbors dict with key corresponding to neighbor name, value corresponding to distance to this neighbor
                valves[s.key]?.neighbors[d.key] = adjMatrix[s.value][d.value]
            }
        }

        return valves
    }

    func maxFlow(valves: [String : Valve], current: Valve, cumulativeFlow: Int = 0, maxTime: Int = 30, time: Int = 0, visited: [Valve] = []) -> Int {
        if time >= maxTime {
            return cumulativeFlow
        }


        var mutableVisited = visited
        mutableVisited.append(current)

        let flow = current.flowRate * (30 - time)
        var mutableFlow = cumulativeFlow
        mutableFlow += flow

        let neighborsFlow = current.neighbors
            .filter {  pair in
                // do not include already visited valves
                guard let valve = valves[pair.key] else { return false }
                return !mutableVisited.contains(valve) 
            }
            .compactMap { pair -> Int in
                guard let neighbor = valves[pair.key], let travelTime = current.neighbors[neighbor.name] else { return 0 }
                return maxFlow(valves: valves, current: neighbor, cumulativeFlow: mutableFlow, maxTime: maxTime, time: time + travelTime + 1, visited: mutableVisited)
            }
            .max()


        return flow + (neighborsFlow ?? 0)
    }
}