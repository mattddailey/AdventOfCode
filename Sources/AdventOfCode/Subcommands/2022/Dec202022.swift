import ArgumentParser

struct Dec202022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - 2022 December 20", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec202022.txt"

    // MARK: - Lifecycle

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        // create circular doubly linked list data structure
        let linkedList = DoublyLinkedList<Int>()
        var nodes: [Node<Int>] = []
        lines
            .compactMap({Int($0)})
            .forEach {
                let node = linkedList.add($0)
                nodes.append(node)
            }

        return findGroveCoordinates(linkedList, nodes)
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        // create circular doubly linked list data structure
        let linkedList = DoublyLinkedList<Int>()
        var nodes: [Node<Int>] = []
        lines
            .compactMap({Int($0)})
            .forEach {
                let node = linkedList.add($0)
                node.value *= 811589153
                nodes.append(node)
            }

        return findGroveCoordinates(linkedList, nodes, 10)
    }

    func findGroveCoordinates(_ linkedList: DoublyLinkedList<Int>, _ nodes: [Node<Int>], _ iterations: Int = 1) -> Int {
        var mutableList = linkedList
        // swap nodes as needed
        for _ in 0..<iterations {
            for node in nodes {
                var swapCount = abs(node.value) % (linkedList.length - 1)
                for _ in 0..<swapCount {
                    node.value < 0 ? node.swapBack(&mutableList) : node.swapForward(&mutableList)
                }
            }
        }
        
        // set zero index to the front, to leverage nodeAtIndex(_:) function 
        if let zeroIndex = mutableList.zeroIndex {
            mutableList.front = mutableList.nodeAtIndex(zeroIndex)
        }

        // find 1000th, 2000th, 3000th values and return sum
        if let x = mutableList.nodeAtIndex(1000)?.value,
           let y = mutableList.nodeAtIndex(2000)?.value,
           let z = mutableList.nodeAtIndex(3000)?.value {
            return x + y + z
        }

        // fallback
        return 0
    }
}

fileprivate extension DoublyLinkedList where T == Int {
    // finds index of 0 value in linked list
    var zeroIndex: Int? {
        var current = self.front
        var index = 0
        while current?.value != 0 {
            current = current?.next
            index += 1
        }
        return index
    }
}

fileprivate extension Node {
    func swapBack(_ list: inout DoublyLinkedList<T>) {
        let prev = self.prev

        prev?.prev?.next = self
        self.next?.prev = prev
        prev?.next = self.next
        self.next = prev
        self.prev = prev?.prev
        prev?.prev = self
    }

    func swapForward(_ list: inout DoublyLinkedList<T>) {
        let next = self.next

        self.prev?.next = next
        next?.next?.prev = self
        next?.prev = self.prev
        self.next = next?.next
        self.prev = next
        next?.next = self
    }
}

