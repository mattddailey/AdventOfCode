import ArgumentParser
import Foundation

struct Dec162022: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - 2022 December 16", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec162022.txt"

    // MARK: - Data Structures

    struct State: Hashable {
        let current: Valve
        let time: Int
        let visited: Set<Valve>
    }

    struct Valve: Hashable, Codable {
        // index of valve in adjacency matrix
        let index: Int
        let name: String
        let flowRate: Int
        // Maps Neighbor valve name to an Int representing the distance to this valve
        var neighbors: [String : Int] = [:]
    }

    class VolcanoEscape {
        typealias Flow = Int

        // maps current state to a flow value (int)
        var cache: [State: Flow] = [:]
        let start: Valve
        let valves: [String: Valve]


        init(valves: [String : Valve]) {
            guard let start = valves["AA"] else {
                fatalError("Didn't find start valve")
            }
            self.start = start
            self.valves = valves
        }

        func maxFlow(current: Valve, maxTime: Int = 30, time: Int = 0, visited: Set<Valve> = Set<Valve>(), addElephant: Bool = false) -> Int {
            // check if we have run out of time or visited all valves with flow
            if time >= maxTime {
                return 0
            }

            // calculate current flow from newly opened valve; check if we have a cached value for maximum additional flow possible
            let flowFromCurrent = current.flowRate * (maxTime - time)
            let state = State(current: current, time: maxTime - time, visited: visited)
            if let cachedMaxAdditionalFlow = cache[state] {
                return flowFromCurrent + cachedMaxAdditionalFlow
            }
            
            // append current to visited, now that its flow value has been added
            var mutableVisited = visited
            mutableVisited.insert(current)

            // calculate maximum additional flow based on current state
            let maxAdditionalFlow = current.neighbors
                .filter {  pair in
                    // do not include already visited valves / valves we don't have time to travel to
                    guard let valve = valves[pair.key] else { return false }
                    let travelTime = current.neighbors[valve.name]
                    if let travelTime = travelTime {
                        return (!mutableVisited.contains(valve) && travelTime < maxTime - time)
                    } else {
                        return false
                    }
                }
                .compactMap { pair -> Int in
                    guard let neighbor = valves[pair.key], let travelTime = current.neighbors[neighbor.name] else { return 0 }
                    return maxFlow(current: neighbor, maxTime: maxTime, time: time + travelTime + 1, visited: mutableVisited, addElephant: addElephant)
                }
                .map { result in
                    if addElephant {
                        let elephant = maxFlow(current: self.start, maxTime: maxTime, visited: mutableVisited)
                        return max(result, elephant)
                    } else {
                        return result
                    }
                }
                .max() ?? 0

            // cache maximum additional flow current state
            cache[state] = maxAdditionalFlow

            return flowFromCurrent + maxAdditionalFlow
        }
    }


    // MARK: - Lifecycle

    mutating func run() throws {
        let input  = try String(contentsOfFile: path)
        let start = Date()
        defer { print("Part 1 complete in \(Date().timeIntervalSince(start)) seconds") }

        let valves = createDataStructures(input.components(separatedBy: .newlines).filter { !$0.isEmpty })

        let volcanoEscape = VolcanoEscape(valves: valves)
        let part1 = volcanoEscape.maxFlow(current: volcanoEscape.start)
        print("Part 1 Max Flow: \(part1)")

        let part2 = volcanoEscape.maxFlow(current: volcanoEscape.start, maxTime: 26, addElephant: true)
        print("Part 2 Max Flow: \(part2)")
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
}