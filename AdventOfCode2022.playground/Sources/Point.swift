import Foundation

public struct Point: Hashable {
    public var x: Int
    public var y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public func manhattanDistance(to point: Point) -> Int {
        return abs(self.x - point.x) + abs(self.y - point.y)
    }
}
