import Foundation

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
    
    var pixels = ""
    var pixelRowCount = 0
    var register = 1
    var signalStrength = 0
    
    var cycleCounter: Int = 1
    var inProgress: Direction? = nil
    
    mutating func processDirections(_ directions: [Direction]) {
        var remainingDirections = directions
        while !remainingDirections.isEmpty || inProgress != nil {
            drawPixel()
            
            if inProgress == nil {
                let direction = remainingDirections.removeFirst()
                if case .add(_) = direction.type {
                    inProgress = direction
                }
            } else {
                processInProgress()
            }
            
            cycleCounter += 1
            checkSignalStrength()
        }
    }
    
    mutating private func drawPixel() {
        if pixelRowCount <= register + 1 && pixelRowCount >= register - 1 {
            pixels.append("#")
        } else {
            pixels.append(".")
        }
        pixelRowCount += 1
        
        if pixelRowCount % 40 == 0 {
            pixels.append("\n")
            pixelRowCount = 0
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

//MARK: - Main

func dec10() {
    let helper = InputHelper(fileName: "dec10Input")
    let directions = helper.inputAsArraySeparatedBy(.newlines)
        .compactMap(Direction.init)
    
    var elfDeviceCPU = ElfDeviceCPU()
    elfDeviceCPU.processDirections(directions)
    
    print("Signal Strength: \(elfDeviceCPU.signalStrength) \n")
    print("CRT Ouput: \n\(elfDeviceCPU.pixels)")
}

dec10()
