struct Point: Hashable {
    var x: Int
    var y: Int

    func manhattanDistance(to point: Point) -> Int {
        return abs(self.x - point.x) + abs(self.y - point.y)
    }
}