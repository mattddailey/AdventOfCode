class DoublyLinkedList<T> {

    var front: Node<T>?
    var back: Node<T>?
    var length = 0

    func add(_ value: T) -> Node<T> {
        let node = Node<T>(value: value)
        length += 1

        if isEmpty {
            front = node
            back = node
            node.next = node
            node.prev = node
        } else {
            back?.next = node
            front?.prev = node
            node.next = front
            node.prev = back
            back = node
        }
        return node
    }

    func nodeAtIndex(_ index: Int) -> Node<T>? {
        var current = 0
        var currentNode = front
        while current != index {
            currentNode = currentNode?.next
            current += 1
        }
        return currentNode
    }

    private var isEmpty: Bool {
        return front == nil
    }

}

extension DoublyLinkedList: CustomStringConvertible where T == Int {
    var description: String {
        var index = 1
        var str: String = front?.description ?? ""
        while index < self.length {
            if let node = self.nodeAtIndex(index) {
                str.append(contentsOf: "   =   \(node.description)")
            }
            index += 1
        }
        return str
    }
}