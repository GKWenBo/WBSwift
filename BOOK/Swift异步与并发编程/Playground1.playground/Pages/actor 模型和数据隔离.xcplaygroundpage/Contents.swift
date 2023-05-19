//: [Previous](@previous)

import Foundation

class Holder {
    private let queue = DispatchQueue(label: "resultholder.queue")
    private var results: [String] = []
    
    func getResutls() -> [String] {
        queue.sync {
            results
        }
    }
    
    func setResults(_ results: [String]) {
        queue.sync {
            self.results = results
        }
    }
    
    func append(_ value: String) {
        queue.sync {
            self.results.append(value)
        }
    }
}

class ActorHolder {
    var results: [String] = []
    
    
    func setResults(_ results: [String]) {
        self.results = results
    }
    
    func append(_ value: String) {
        self.results.append(value)
    }
}

//: [Next](@next)
