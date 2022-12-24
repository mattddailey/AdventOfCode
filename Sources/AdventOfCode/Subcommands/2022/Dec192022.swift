import ArgumentParser

struct Dec192022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - Not Enough Minerals", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec192022.txt"

    // MARK: - Data Structures

    typealias Blueprint = [Material : Robot]
    typealias Robots = [Material : Int]

    enum Material: String {
        case ore
        case clay
        case obsidian
        case geode
    }

    struct Robot: Hashable {
        let type: Material
        let cost: [Material : Int]

        init(type: Material, cost: [Material: Int] = [:]) {
            self.type = type
            self.cost = cost
        }
    }

    struct Stock {
        var ore: Int = 0
        var clay: Int = 0
        var obsidian: Int = 0
        var geode: Int = 0
    }

    class GeodeMiner {
        let blueprint: Blueprint
        let maxes: [Material : Int]

        var maxGeodes = 0

        init(blueprint: Blueprint, maxes: [Material : Int]) {
            self.blueprint = blueprint
            self.maxes = maxes
        }

        // will ultimately return the largest number of geodes that can be mined
        func mine(robots: Robots, stock: Stock, time: Int) -> Int {
            guard time > 0 && canBeatMax(stock.geode, time) else { 
                maxGeodes = max(maxGeodes, stock.geode)
                return stock.geode 
            }

            // print("== Minute \(25 - time) ==")
            let affordableRobots = blueprint
                .filter { canBuild($0.value, stock) && shouldBuild($0.value, robots, stock) }

            // collect minerals from current robots
            let mutableStock = collect(robots, stock)

            let maxWhenBuildingARobot = affordableRobots
                .map { pair in
                    let (mutableRobots, mutableStock) = build(pair.value, robots, stock)
                    return mine(robots: mutableRobots, stock: mutableStock, time: time - 1) 
                }
                .max() ?? 0
            let noNewRobotsResult = mine(robots: robots, stock: mutableStock, time: time - 1)
            return max(maxWhenBuildingARobot, noNewRobotsResult)
        }

        private func build(_ robot: Robot, _ robots: Robots, _ stock: Stock) -> (Robots, Stock) {
            var mutableStock = stock
            for material in robot.cost.keys {
                guard let cost = robot.cost[material] else { continue }
                switch material {
                case .ore: mutableStock.ore -= cost
                case .clay: mutableStock.clay -= cost
                case .obsidian: mutableStock.obsidian -= cost
                case .geode: mutableStock.geode -= cost
                }
            }

            var mutableRobots = robots
            let currentCount = robots[robot.type] ?? 0
            // print("Spend \(robot.cost) to start building a new \(robot.type) robot.")
            mutableRobots[robot.type] = currentCount + 1
            // print("The new \(robot.type) robot is ready. You now have \(mutableRobots[robot.type] ?? 0) of them")

            return (mutableRobots, mutableStock)
        }

        private func canBeatMax(_ currentGeodes: Int, _ time: Int) -> Bool {
            return time - 1 + currentGeodes > maxGeodes
        }

        private func canBuild(_ robot: Robot, _ stock: Stock) -> Bool {
            switch robot.type {
            case .ore:      return stock.ore >= (robot.cost[.ore] ?? Int.max) 
            case .clay:     return stock.ore >= (robot.cost[.ore] ?? Int.max) 
            case .obsidian: return (stock.ore >= (robot.cost[.ore] ?? Int.max) && stock.clay >= (robot.cost[.clay] ?? Int.max))
            case .geode:    return (stock.ore >= (robot.cost[.ore] ?? Int.max) && stock.obsidian >= (robot.cost[.obsidian] ?? Int.max))
            }
        }

        private func shouldBuild(_ robot: Robot, _ robots: Robots, _ stock: Stock) -> Bool {
            guard robot.type != .geode else { return true }

            guard let numberCurrentlyProducing = robots[robot.type],
                  let maximum = maxes[robot.type] 
            else { return true }


            return numberCurrentlyProducing < maximum
        }

        private func collect(_ robots: Robots, _ stock: Stock) -> Stock {
            var mutableStock = stock
            for material in robots.keys {
                guard let count = robots[material] else { continue }
                switch material {
                case .ore: 
                    mutableStock.ore += count     
                    // print("\(count) ore-collecting robot collects \(count) ore; you now have \(mutableStock.ore) ore.")
                case .clay:     
                    mutableStock.clay += count     
                    // print("\(count) clay-collecting robot collects \(count) clay; you now have \(mutableStock.clay) clay.")
                case .obsidian: 
                    mutableStock.obsidian += count     
                    // print("\(count) obsidian-collecting robot collects \(count) obsidian; you now have \(mutableStock.obsidian) obsidian.")
                case .geode:    
                    mutableStock.geode += count     
                    // print("\(count) geode-collecting robot collects \(count) geode; you now have \(mutableStock.geode) geode.")
                }
            }
            return mutableStock
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
        let blueprints: [(Blueprint, [Material : Int])] = lines.compactMap(createBlueprint)

        var result = 0
        for (index, blueprint) in blueprints.enumerated() {
            let geodeMiner = GeodeMiner(blueprint: blueprint.0, maxes: blueprint.1)
            let qualityLevel = geodeMiner.mine(robots: [.ore : 1], stock: Stock(), time: 24) * (index + 1)
            result += qualityLevel
        }
        return result
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        // let blueprints = lines.compactMap(createBlueprint)
        return 0
    }

    func createBlueprint(_ line: String) -> (Blueprint, [Material : Int])? {
        var maxes: [Material : Int] = [.ore : 0, .clay: 0, .obsidian: 0, .geode: 0]
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
                blueprints[type] = Robot(type: type, cost: [costType : cost])
            } else if index == 1 {
                guard let type = Material(rawValue: components[1]) ,
                      let cost = Int(components[4]),
                      let costType = Material(rawValue: components[5])
                else { return nil }
                maxes[costType] = max(cost, maxes[costType]!)
                blueprints[type] = Robot(type: type, cost: [costType : cost])
            } else {
                guard let type = Material(rawValue: components[1]) ,
                      let cost = Int(components[4]),
                      let costType = Material(rawValue: components[5]),
                      let cost2 = Int(components[7]),
                      let costType2 = Material(rawValue: components[8])
                else { return nil }
                maxes[costType] = max(cost, maxes[costType]!)
                maxes[costType2] = max(cost2, maxes[costType2]!)
                blueprints[type] = Robot(type: type, cost: [costType : cost, costType2 : cost2])
            }
        }
        return (blueprints, maxes)
    }
}