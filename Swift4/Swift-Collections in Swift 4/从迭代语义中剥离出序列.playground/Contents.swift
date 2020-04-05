import UIKit

protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
}

protocol Sequence {
    associatedtype Element
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Element
    
    func makeIterator() -> Iterator
}


struct Fibonacci: Sequence {
    typealias Element = Int
    
    func makeIterator() -> FiboIter {
        return FiboIter()
    }
}

struct FiboIter: IteratorProtocol {
    var state = (0, 1)
    
    mutating func next() -> Int? {
        let nextNumber = state.0
        self.state = (state.1, state.0 + state.1)
        
        return nextNumber
    }
}

var fib1 = Fibonacci().makeIterator()
fib1.next()
fib1.next()
fib1.next()
fib1.next()


