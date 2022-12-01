import Foundation

public func getInputData(from fileName: String) -> String {
    let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")!
    let file = try! String(contentsOfFile: filePath)

    return file
}
