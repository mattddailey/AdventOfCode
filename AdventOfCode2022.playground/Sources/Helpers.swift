import Foundation

public struct InputHelper {
    public let inputAsString: String
    
    public init(fileName: String) {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")!
        let stringContents = try! String(contentsOfFile: filePath)
        self.inputAsString = stringContents
    }
    
    public func inputAsArraySeparatedBy(_ separator: CharacterSet) -> [String] {
        return inputAsString.components(separatedBy: separator)
    }
    
}
