import Foundation

public struct InputHelper {
    public let inputAsString: String
    
    public init(fileName: String) {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")!
        let stringContents = try! String(contentsOfFile: filePath)
        self.inputAsString = stringContents
    }
    
    public func inputAsArraySeparatedBy(_ separator: CharacterSet) -> [String] {
        return inputAsString.components(separatedBy: separator).filter { !$0.isEmpty }
    }
    
}

public func transpose(_ input: [[Int]]) -> [[Int]] {
    guard !input.isEmpty else { return input }
    var result = [[Int]]()
    for index in 0..<input.first!.count {
        result.append(input.map{$0[index]})
    }
    return result

}

public extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}

// XOR
public extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}
