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


public extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}
