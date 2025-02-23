import UIKit

// 数组和可变性
var mutableFibs = [0, 1, 1, 2, 3, 5]

mutableFibs.append(8)
mutableFibs.append(contentsOf: [13, 21])
mutableFibs // [0, 1, 1, 2, 3, 5, 8, 13, 21]

// map
let squares = mutableFibs.map { x in
    x * x
}

extension Array {
    func map<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []
        result.reserveCapacity(count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}

// split
extension Array {
    func split(where condition: (Element, Element) -> Bool) -> [[Element]] {
        var results: [[Element]] = self.isEmpty ? [] : [[self[0]]]
        for (previous, current) in zip(self, self.dropFirst()) {
            if condition(previous, current) {
                results.append([current])
            } else {
                results[results.endIndex - 1].append(current)
            }
        }
        return results
    }
}

let array: [Int] = [1, 2, 2, 3, 4, 4]
let parts = array.split(where: !=)


// accumulate
extension Array {
    func accumulate<Result>(_ initial: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initial
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}

[1, 2, 3, 4].accumulate(0, +)

// filter
extension Array {
    func filter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where isIncluded(x) {
            result.append(x)
        }
        return result
    }
}

(1..<10).map { $0 * $0 }.filter { $0 % 2 == 0 }

// reduce
extension Array {
    func reduce<Result>(_ initial: Result, _ nextPartialResult: (Result, Element) -> Result) -> Result {
        var running = initial
        for x in self {
            running = nextPartialResult(running, x)
        }
        return running
    }
}

let fibs = [0, 1, 1, 2, 3, 5]
fibs.reduce("") { str, num in str + "\(num)" }

// flatMap
extension Array {
    /// 展平的map
    func flatMap<T>(_ transform: (Element) -> [T]) -> [T] {
        var result: [T] = []
        for x in self {
            result.append(contentsOf: transform(x))
        }
        return result
    }
}

let suits = ["♠︎", "♥︎", "♣︎", "♦︎"]
let ranks = ["J","Q","K","A"]

let result = suits.flatMap { suit in
    ranks.map { rank in
        (suit, rank)
    }
}
