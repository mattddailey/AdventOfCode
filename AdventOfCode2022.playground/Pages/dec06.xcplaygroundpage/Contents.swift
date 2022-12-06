import Foundation

//MARK: - Shared

func locateMarker(in dataStream: String, markerSize: Int) -> Int {
    var index = 0
    while index+markerSize < dataStream.count {
        let slidingGroup = dataStream[index..<index+markerSize]
        var marker = Set<Character>()
        let duplicates = slidingGroup.filter { !marker.insert($0).inserted }
        if duplicates.isEmpty {
            // marker found
            break
        }
        index += 1
    }
    return index+markerSize
}

//MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "dec06Input")
    let dataStream = helper.inputAsString.replacingOccurrences(of: "\n", with: "")
    
    return locateMarker(in: dataStream, markerSize: 4)
}

//MARK: - Part 2

func part2() -> Int {
    let helper = InputHelper(fileName: "dec06Input")
    let dataStream = helper.inputAsString.replacingOccurrences(of: "\n", with: "")
    
    return locateMarker(in: dataStream, markerSize: 14)
}

print(part1())
print(part2())
