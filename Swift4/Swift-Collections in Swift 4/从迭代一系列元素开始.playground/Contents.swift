import UIKit

protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
}

struct Ones: IteratorProtocol {
    mutating func next() -> Int? {
        return 1
    }
}

var ones = Ones()

ones.next()
ones.next()
ones.next()

