import Foundation

// Implements Floyd Warshall Algorithm - given an adjacency matrix, computes the shortest path from each vertex to another
// e.g. value at [0][1] of distanceMatrix is the shortest path from node 0 to node 1
public func FloydWarshall(_ matrix: [[Int]]) -> [[Int]] {
    var distanceMatrix = matrix
    for i in 0..<matrix.count {
        for j in 0..<matrix.count {
            for k in 0..<matrix.count {
                distanceMatrix[j][k] = min(distanceMatrix[j][k], distanceMatrix[j][i] + distanceMatrix[i][k])
            }
        }
    }
    return distanceMatrix
}
