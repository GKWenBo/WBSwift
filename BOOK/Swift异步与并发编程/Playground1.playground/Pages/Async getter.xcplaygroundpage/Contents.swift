//: [Previous](@previous)

import Foundation

class File {
    var size: Int {
        get async throws {
            try await heavyOperation()
        }
    }
    
    func heavyOperation() async throws -> Int {
        return 10
    }
}

//: [Next](@next)
