import UIKit

protocol Queue {
    associatedtype Element
    
    mutating func push(_ element: Element)
    mutating func pop() -> Element?
}

struct FIFOQueue<Element>: Queue {
    
    fileprivate var operation: [Element] = []
    fileprivate var storage: [Element] = []
    
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    
    mutating func pop() -> Element? {
        if operation.isEmpty {
            operation.reversed()
            operation.removeAll()
        }
        return operation.popLast()
    }

}

extension FIFOQueue: Collection {
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return operation.count + storage.count
    }
    
    func index(after i: Int) -> Int {
        precondition(i < endIndex)
        
        return i + 1
    }
    
    public subscript(pos: Int) -> Element {
        precondition((startIndex..<endIndex).contains(pos), "out of range")
        if pos < operation.endIndex {
            return operation[operation.count - 1 - pos]
        }
        return storage[pos - operation.count]
    }
}

var numberQueue = FIFOQueue<Int>()

for i in 1...10 {
    numberQueue.push(i)
}

for i in numberQueue {
    print(i)
}

var numerArray = Array<Int>()
numerArray.append(contentsOf: numberQueue)
print(numerArray)

numberQueue.isEmpty
numberQueue.count
numberQueue.first

numberQueue.map { $0 * 3 }
for i in numberQueue {
    print(i)
}
