import Foundation


typealias PacketPair = ([Component], [Component])

enum Component {
    case component([Component])
    case int(Int)
    
    var asComponentList: [Component] {
        switch self {
        case .int(_):
            let list: [Component] = [self]
            return list
        case .component(let component):
            return component
        }
    }
}

extension Component: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let component = try? container.decode([Component].self)
        let int = try? container.decode(Int.self)
        
        switch (component, int) {
        case (let component?, nil): self = .component(component)
        case (nil, let int?):       self = .int(int)
        default:
            throw DecodingError.valueNotFound(
                Component.self,
                .init(codingPath: decoder.codingPath,
                      debugDescription: "Value must be either component or int",
                      underlyingError: nil))
        }
    }
}

// For Debugging
extension Component: CustomStringConvertible {
    var description: String {
        switch self {
        case .component(let component): return component.description
        case .int(let int):             return String(int)
        }
    }
}

func createPacket(_ string: String) -> [Component]? {
    if let data = string.data(using: .utf8), let packet = try? JSONDecoder().decode([Component].self, from: data) {
        return packet
    } else {
        return nil
    }
}

// true: right order
// false: wrong order
func areOrderedCorrectly(_ pair: PacketPair) -> Bool {
    let elementsToCompare = min(pair.0.count, pair.1.count)
    
    for index in 0..<elementsToCompare {
        switch (pair.0[index], pair.1[index]) {
        
        // compare 2 numbers
        case (.int(let amount1), .int(let amount2)):
            print("compare \(amount1) vs \(amount2)")
            if amount1 > amount2 {
                print("Right side is smaller, so inputs are not in the right order")
                return false
            } else if amount1 < amount2 {
                print("LEFT side is smaller, so inputs are not in the right order")
                return true
            }
        
        // recursively compare for all other cases
        default:
            print("COMPARE \(pair.0[index]) vs \(pair.1[index])")
            let list1 = pair.0[index].asComponentList
            let list2 = pair.1[index].asComponentList
            print("COMPARE \(list1) vs \(list2)")
            if !areOrderedCorrectly((list1, list2)) {
                return false
            }
        }
    }
    
    if pair.0.count < pair.1.count {
        // left side ran out of items
        print("Left side ran out of items, so inputs are in the RIGHT ORDER")
        return true
    } else if pair.0.count > pair.1.count {
        // right side ran out of items
        print("Right side ran out of items, so inputs are NOT in the right order")
        return false
    } else {
        // lists must be equal
        return true
    }
    
}

func main() {
    let helper = InputHelper(fileName: "dec13Input")
    
    // convert input to type PacketPair (alias for two lists of components)
    let packetPairs = helper.inputAsString.components(separatedBy: "\n\n")
        .compactMap { pair -> PacketPair? in
            let packets = pair.components(separatedBy: .newlines)
                .compactMap(createPacket)
            guard packets.count >= 2 else { return nil }
            return (packets[0], packets[1])
        }
    
    var count = 0
    for (index, pair) in packetPairs.enumerated() {
        let result = areOrderedCorrectly(pair)
        if result {
            count += index + 1
        }
    }
    
    // Part 1
    print("Sum of indices in correct order: \(count)")
}

main()
