struct Queue<T> {
    
    private var front: Node<T>?
    private var back: Node<T>?
    
    var isEmpty: Bool {
        return front == nil
    }
    
    mutating func dequeue() -> T? {
        defer {
            front = front?.next
            if isEmpty {
                back = nil
            }
        }
    
        return front?.value
    }
    
    mutating func enqueue(_ value: T) {
        if isEmpty {
            self.push(value)
            return
        }
        
        back?.next = Node(value: value)
        back = back?.next
    }
    
    mutating private func push(_ value: T) {
        front = Node(value: value, next: front)
        if back == nil {
            back = front
        }
    }
}

class Node<T> {
    
    var value: T
    var next: Node?
    
    init(value: T, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}