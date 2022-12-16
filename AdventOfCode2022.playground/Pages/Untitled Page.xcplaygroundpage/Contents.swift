import Foundation

let max = 999

let test = [
    [0, 3, max, 5],
    [2, 0, max, 4],
    [max, 1 , 0, max],
    [max, max, 2, 0]
]
print(test)
print(FloydWarshall(test))
