import ArgumentParser
import Foundation

struct Dec162022: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - 2022 December 16", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec162022.txt"

    // MARK: - Data Structures

    struct State: Hashable {
        let valve: Valve
        let time: Int
        let mask: Int
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

        // maps non-empty valve names to an index for bitmask
        var nonEmptyIndices: [String: Int] = [:]


        init(valves: [String : Valve]) {
            guard let start = valves["AA"] else {
                fatalError("Didn't find start valve")
            }
            self.start = start
            self.valves = valves
            let nonEmpty = valves
                .filter({ $0.value.flowRate != 0 })
                .map { $0.value.name }

            for (index, name) in nonEmpty.enumerated() {
                self.nonEmptyIndices[name] = index
            }
        }

        func maxFlow(valve: Valve, time: Int, mask: Int) -> Flow {
            let state = State(valve: valve, time: time, mask: mask)
            if let cached = cache[state] {
                return cached
            }

            var flow = 0
            for neighbor in valve.neighbors.keys {
                // calculate bit for neighbor
                guard let index = nonEmptyIndices[neighbor] else { continue }
                let bit = 1 << index

                // check if we already visited already visited neighbor
                guard mask & bit == 0 else { continue }

                // calculate travel time to neighbor, confirm we still have time to get there
                guard let neighborValve = valves[neighbor], let travelTime = valve.neighbors[neighborValve.name] else { continue }
                let remainingTime = time - travelTime - 1
                guard remainingTime > 0 else { continue }

                // calculate maximum possible remaining flow
                flow = max(flow, maxFlow(valve: neighborValve, time: remainingTime, mask: mask | bit) + neighborValve.flowRate * remainingTime)
            }

            // cache result
            cache[state] = flow

            return flow
        }

        func flowWithElephantHelper() -> Int {
            // bitmask corresponding to all nonEmpty valves being open
            let allOpenMask = (1 << nonEmptyIndices.count) - 1
            var flow = 0
            for bits in 0...((allOpenMask + 1) / 2) {
                // try all disjoint pairs of valves, take max of the result
                flow = max(flow,  maxFlow(valve: start, time: 26, mask: bits) + maxFlow(valve: start, time: 26, mask: allOpenMask ^ bits))
            }

            return flow
        }
    }


    // MARK: - Lifecycle

    mutating func run() throws {
        let input  = try String(contentsOfFile: path)
        let valves = createDataStructures(input.components(separatedBy: .newlines).filter { !$0.isEmpty })

        var start = Date()
        let volcanoEscape = VolcanoEscape(valves: valves)
        let part1 = volcanoEscape.maxFlow(valve: volcanoEscape.start, time: 30, mask: 0)
        print("Part 1 Max Flow: \(part1)")
        print("Part 1 complete in \(Date().timeIntervalSince(start)) seconds")

        start = Date()
        let part2 = volcanoEscape.flowWithElephantHelper()
        print("Part 2 Flow: \(part2)")
        print("Part 1 complete in \(Date().timeIntervalSince(start)) seconds")
    }

    // MARK: - Parsing input

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