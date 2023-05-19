//: [Previous](@previous)

import Foundation

@completionHandlerAsync("calculate(input:)")
func calculate(input: Int, completion: @escaping (Int) -> Void) {
    completion(input + 100)
}

func calculate(input: Int) async -> Int {
    return input + 100
}

//: [Next](@next)
