import Foundation

class Node<T>: Equatable {
    static func == (lhs: Node<T>, rhs: Node<T>) -> Bool {
        lhs.id == rhs.id
    }
    
    var value: T
    var next: Node?
    var prev: Node?

    private var id = UUID()
    
    init(value: T, next: Node? = nil, prev: Node? = nil) {
        self.value = value
        self.next = next
        self.prev = prev
    }
}

extension Node: CustomStringConvertible where T == Int {
    var description: String {
        String(self.value)
    }
}