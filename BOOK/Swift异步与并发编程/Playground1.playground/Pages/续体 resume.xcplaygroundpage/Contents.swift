//: [Previous](@previous)

import Foundation

func load(completion: @escaping([String]?, Error?) -> Void) {}

func laod() async throws -> [String] {
    try await withCheckedThrowingContinuation({ continuation in
        load { values, error in
            if let error {
                continuation.resume(throwing: error)
            } else if let values {
                continuation.resume(returning: values)
            } else {
                assertionFailure("Both parameters are nil")
            }
        }
    })
}

//: [Next](@next)
