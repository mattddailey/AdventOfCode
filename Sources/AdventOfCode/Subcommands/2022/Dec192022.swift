import ArgumentParser

struct Dec192022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - Not Enough Minerals", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec192022.txt"

    // MARK: - Data Structures

    typealias Blueprint = [Material : Cost]
    typealias Cost = [Material : Int]
    typealias Robots = [Material : Int]
    typealias Maxes = [Material : Int]
    typealias Stock = [Material : Int]

    enum Material: String, CaseIterable {
        case ore
        case clay
        case obsidian
        case geode
    }

    struct State: Hashable {
        var time: Int
        var robots: Robots
        var stock: Stock
        var skipped: Set<Material>
    }
    
    // MARK: - Lifecycle

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        var result = 0
        for (index, environment) in lines.compactMap(parseInput).enumerated() {
            let temp = mineGeodes(for: 24, environment.0, environment.1) * (index + 1)
            result += temp
            print("Geodes mined for \(index + 1): \(temp / (index + 1))")
        }
        
        return result
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        let environments = lines.compactMap(parseInput)
        var result = 1
        for index in 0...2 {
            result *= mineGeodes(for: 32, environments[index].0, environments[index].1)
        }
        return result
    }

    func parseInput(_ line: String) -> (Blueprint, Maxes)? {
        var maxes: Maxes = [.ore: 0, .clay: 0, .obsidian: 0, .geode: 0]
        var blueprints = Blueprint()
        let robotsString = line.components(separatedBy: ".").filter { !$0.isEmpty }
        for (index, robotString) in robotsString.enumerated() {
            let components = robotString.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            if index == 0 {
                guard let type = Material(rawValue: components[3]), 
                      let cost = Int(components[6]),
                      let costType = Material(rawValue: components[7])
                      else { return nil }
                maxes[costType] = max(cost, maxes[costType]!)
                blueprints[type] = [costType : cost]
            } else if index == 1 {
                guard let type = Material(rawValue: components[1]) ,
                      let cost = Int(components[4]),
                      let costType = Material(rawValue: components[5])
                else { return nil }
                maxes[costType] = max(cost, maxes[costType]!)
                blueprints[type] = [costType : cost]
            } else {
                guard let type = Material(rawValue: components[1]) ,
                      let cost = Int(components[4]),
                      let costType = Material(rawValue: components[5]),
                      let cost2 = Int(components[7]),
                      let costType2 = Material(rawValue: components[8])
                else { return nil }
                maxes[costType] = max(cost, maxes[costType]!)
                maxes[costType2] = max(cost2, maxes[costType2]!)
                blueprints[type] = [costType : cost, costType2 : cost2]
            }
        }
        return (blueprints, maxes)
    }

    func mineGeodes(for time: Int, _ blueprint: Blueprint, _ maxes: Maxes) -> Int {
        var queue = Queue<State>()
        let start = State(time: time, robots: [.ore: 1], stock: [.ore: 0, .clay: 0, .obsidian: 0, .geode: 0], skipped: Set())
        queue.enqueue(start)

        var maxGeodes = 0
        var best: [Int: Int] = [:]

        while let state = queue.dequeue() {
            best[state.time] = max(best[state.time] ?? 0, state.stock[.geode] ?? 0)
            guard state.time > 0,
                  // if we had more geodes at the current minute in previous iteration, we are not going to beat it here
                  state.stock[.geode]! >= (best[state.time] ?? 0)
            else {
                maxGeodes = max(maxGeodes, state.stock[.geode]!)
                continue
            }

            var toBuild = Material.allCases
                .filter { canBuild($0, blueprint, state.stock) }
                .filter { shouldBuild($0, state.robots, maxes: maxes) }
                // if we skipped building robot last iteration, no need to try to build it here
                .filter { !state.skipped.contains($0) }
            // if we are able to build a geode robot, this is the only one we should build
            if toBuild.contains(.geode) { toBuild = [.geode] }

            let stock = collect(state.robots, state.stock)
            for material in toBuild {
                let (newRobots, newStock) = build(blueprint, material, state.robots, stock)
                queue.enqueue(State(time: state.time - 1, robots: newRobots, stock: newStock, skipped: Set()))
            }

            // as long as we dont have option to build geode, we want to add scenario of no build to queue
            if toBuild != [.geode] {
                queue.enqueue(State(time: state.time - 1, robots: state.robots, stock: stock, skipped: Set(toBuild)))
            }
        }

        return maxGeodes
    }

    func canBeatMax(_ time: Int, _ geodes: Int, _ max: Int) -> Bool {
        return (geodes + time * (time - 1) / 2 > max)
    }

    // returns true if we can build a robot of type material based on stock
    func canBuild(_ material: Material, _ blueprint: Blueprint, _ stock: Stock) -> Bool {
        guard let oreStock = stock[.ore], 
              let clayStock = stock[.clay],
              let obsidianStock = stock[.obsidian],
              let oreCost = blueprint[.ore]?[.ore],
              let clayCost = blueprint[.clay]?[.ore],
              let obsidianOreCost = blueprint[.obsidian]?[.ore],
              let obsidianClayCost = blueprint[.obsidian]?[.clay],
              let geodeOreCost = blueprint[.geode]?[.ore],
              let geodeObsidianCost = blueprint[.geode]?[.obsidian]
        else { return false }

        switch material {
            case .ore:      return oreStock >= oreCost
            case .clay:     return oreStock >= clayCost
            case .obsidian: return oreStock >= obsidianOreCost && clayStock >= obsidianClayCost
            case .geode:    return oreStock >= geodeOreCost && obsidianStock >= geodeObsidianCost
        }
    }

    // returns true if we should build a robot of type material 
    // always true for geode
    // true for other types if we are not yet producing enough to harvest max materials needed in one round
    func shouldBuild(_ material: Material, _ robots: Robots, maxes: Maxes) -> Bool {
        guard material != .geode else { return true }

        guard let numberCurrentlyProducing = robots[material],
              let maximum = maxes[material] 
        else { return true }

        return numberCurrentlyProducing < maximum
    }

    func build(_ blueprint: Blueprint, _ material: Material, _ robots: Robots, _ stock: Stock) -> (Robots, Stock) {
        var mutableStock = stock
        guard let oreStock = mutableStock[.ore],
              let clayStock = mutableStock[.clay],
              let obsidianStock = mutableStock[.obsidian],
              let geodeStock = mutableStock[.geode] 
        else { return (robots, stock) }

        for buildMaterial in blueprint[material]!.keys {
            guard let cost = blueprint[material]?[buildMaterial] else { continue }
            switch buildMaterial {
            case .ore:      mutableStock[.ore] = oreStock - cost
            case .clay:     mutableStock[.clay] = clayStock - cost
            case .obsidian: mutableStock[.obsidian] = obsidianStock - cost
            case .geode:    mutableStock[.geode] = geodeStock - cost
            }
        }

        var mutableRobots = robots
        let currentCount = robots[material] ?? 0
        mutableRobots[material] = currentCount + 1

        return (mutableRobots, mutableStock)
    }

    func collect(_ robots: Robots, _ stock: Stock) -> Stock {
            var mutableStock = stock
            guard let oreStock = mutableStock[.ore],
                  let clayStock = mutableStock[.clay],
                  let obsidianStock = mutableStock[.obsidian],
                  let geodeStock = mutableStock[.geode] 
            else { return stock }

            for material in robots.keys {
                guard let count = robots[material] else { continue }
                switch material {
                case .ore:      mutableStock[.ore] = oreStock + count  
                case .clay:     mutableStock[.clay] = clayStock + count  
                case .obsidian: mutableStock[.obsidian] = obsidianStock + count
                case .geode:    mutableStock[.geode] = geodeStock + count  
                }
            }
            return mutableStock
        }
}