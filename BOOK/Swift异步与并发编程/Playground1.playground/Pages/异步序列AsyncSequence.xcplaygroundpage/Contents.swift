//: [Previous](@previous)

import Foundation

struct AsyncFibonacciSequence: AsyncSequence {
    typealias Element = Int
    
    struct AsyncIterator: AsyncIteratorProtocol {
        
        var currentIndex = 0
        
        mutating func next() async throws -> Int? {
            defer { currentIndex += 1 }
            return try await loadFibNumber(at: currentIndex)
        }
        
        func loadFibNumber(at index: Int) async throws -> Int {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            return fibNumber(at: index)
        }
        
        func fibNumber(at index: Int) -> Int {
            if index == 0 {
                return 0
            }
            if index == 1 {
                return 1
            }
            return fibNumber(at: index - 2) + fibNumber(at: index - 1)
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        .init()
    }
}

let asyncFib = AsyncFibonacciSequence()
    .filter { $0.isMultiple(of: 2) }
    .prefix(5)
    .map { $0 * 2 }

//for try await v in asyncFib {
//    if v < 20 {
//        print("Async Fib:\(v)")
//    } else {
//        break
//    }
//}
    
for try await v in asyncFib {
    print(v)
}

extension AsyncSequence {
    func myContains(where predicate: (Self.Element) async throws -> Bool) async rethrows -> Bool {
        for try await v in self {
            if try await predicate(v) {
                return true
            }
        }
        return false
    }
}

//: [Next](@next)
