import Foundation


typealias PacketPair = ([Component], [Component])

enum Component: Equatable {
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

func createPacket(_ string: String) -> [Component]? {
    if let data = string.data(using: .utf8), let packet = try? JSONDecoder().decode([Component].self, from: data) {
        return packet
    } else {
        return nil
    }
}

// true: right order
// false: wrong order
// nil: don't know if order is right yet
func compare(_ lhs: [Component], _ rhs: [Component]) -> ComparisonResult {
    let elementsToCompare = min(lhs.count, rhs.count)
    
    for index in 0..<elementsToCompare {
        switch (lhs[index], rhs[index]) {
        
        // compare 2 numbers
        case (.int(let amount1), .int(let amount2)):
            if amount1 > amount2 {
                return .orderedDescending
            } else if amount1 < amount2 {
                return .orderedAscending
            }
        
        // recursively compare for all other cases
        default:
            let list1 = lhs[index].asComponentList
            let list2 = rhs[index].asComponentList
            let comparison = compare(list1, list2)
            if comparison != .orderedSame {
                return comparison
            }
        }
    }
    
    if lhs.count < rhs.count {
        // left side ran out of items
        return .orderedAscending
    } else if lhs.count > rhs.count {
        // right side ran out of items
        return .orderedDescending
    } else {
        // cannot determine if ordered correctly
        return .orderedSame
    }
    
}

func part1() {
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
        let result = compare(pair.0, pair.1)
        if result == .orderedAscending {
            count += index + 1
        }
    }
    
    // print part1 result
    print("Sum of indices in correct order: \(count)")
}

func part2() {

    let helper = InputHelper(fileName: "dec13Input")
    var packets = helper.inputAsString.components(separatedBy: .newlines)
        .filter { !$0.isEmpty }
        .compactMap(createPacket)

    // append dividers
    packets.append([.component([.int(2)])])
    packets.append([.component([.int(6)])])

    // sort using compare function
    packets.sort { (lhs, rhs) -> Bool in
        return compare(lhs, rhs) == .orderedAscending
    }
    
    // print part2 result
    if let divider1Index = packets.firstIndex(where: { $0 == [.component([.int(2)])]}),
       let divider2Index = packets.firstIndex(where: { $0 == [.component([.int(6)])]}) {
        print("Decoder key for the distress signal is \((divider1Index+1) * (divider2Index+1))")
    }
}

part1()
part2()
