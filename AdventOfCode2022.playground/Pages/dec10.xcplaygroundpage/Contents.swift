import Foundation

//MARK: - Part 1

struct Direction {
    let type: DirectionType
    var remainingCycles: Int = 0
    
    init?(_ line: String) {
        let input = line.components(separatedBy: .whitespaces)
        if case input.count = 2, let amount = Int(input[1]), input[0] == "addx" {
            self.type = .add(amount)
            self.remainingCycles = 1
        } else if input[0] == "noop" {
            self.type = .noOp
        } else {
            return nil
        }
    }
}

enum DirectionType {
    case noOp
    case add(Int)
}

struct ElfDeviceCPU {
    
    var register = 1
    var signalStrength = 0
    
    var cycleCounter: Int = 1
    var inProgress: Direction? = nil
    
    mutating func processDirections(_ directions: [Direction]) {
        var remainingDirections = directions
        while !remainingDirections.isEmpty {
            if inProgress == nil {
                let direction = remainingDirections.removeFirst()
                switch direction.type {
                case .noOp:
                    break
                case .add(_):
                    inProgress = direction
                }
            } else {
                processInProgress()
            }
            
            cycleCounter += 1
            checkSignalStrength()
        }
        
        // complete in progress (if there is one)
        while inProgress != nil {
            processInProgress()
            cycleCounter += 1
            checkSignalStrength()
        }
    }
    
    mutating private func processInProgress() {
        inProgress?.remainingCycles -= 1
        
        if let direction = inProgress, direction.remainingCycles == 0 {
            if case let .add(amount) = direction.type {
                register += amount
                inProgress = nil
            }
        }
    }
    
    private mutating func checkSignalStrength() {
        if (cycleCounter - 20) % 40 == 0 {
            signalStrength += cycleCounter * register
        }
    }
}

//MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "dec10Input")
    let directions = helper.inputAsArraySeparatedBy(.newlines)
        .compactMap(Direction.init)
    
    var elfDeviceCPU = ElfDeviceCPU()
    elfDeviceCPU.processDirections(directions)
    

    return elfDeviceCPU.signalStrength
}

print(part1())
