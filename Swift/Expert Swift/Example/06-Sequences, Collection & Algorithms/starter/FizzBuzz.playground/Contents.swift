/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

struct FizzBuzz: Collection {
    typealias Index = Int
    
    var startIndex: Index { 1 }
    var endIndex: Index { 101 }
    
    subscript(position: Int) -> String {
        precondition(indices.contains(position), "out of 1-100")
        switch (position.isMultiple(of: 3), position.isMultiple(of: 5)) {
        case (false, false):
            return String(position)
        case (true, false):
            return "Fizz"
        case (false, true):
            return "Buzz"
        case (true, true):
            return "FizzBuzz"
        }
    }
}

extension FizzBuzz: BidirectionalCollection {
    func index(before i: Index) -> Index {
        print("Calling \(#function) with \(i)")
        return i - 1
    }
}

extension FizzBuzz: RandomAccessCollection {
    
}

// MARK: -
let fizzBuzz = FizzBuzz()
//for value in fizzBuzz {
//    print(value, terminator: " ")
//}
//
//let fizzBuzzPositions = fizzBuzz.enumerated().reduce(into: []) { list, item in
//    if item.element == "FizzBuzz" {
//        list.append(item.offset + fizzBuzz.startIndex)
//    }
//}
//print(fizzBuzzPositions)

print(fizzBuzz.dropLast(40).count)

// MARK: - Slices
let slice = fizzBuzz[20...30]
slice.startIndex
slice.endIndex
slice.count
for item in slice.enumerated() {
    print("\(item.offset):\(item.element)", terminator: " ")
}
print("")

let sliceOfSlice = slice[22...24]
sliceOfSlice.startIndex
sliceOfSlice[sliceOfSlice.startIndex]

// MARK: - Eager vs Lazy
let firstThree = FizzBuzz()
    .compactMap(Int.init)
    .filter { $0.isMultiple(of: 2)}
    .prefix(3)

print(firstThree)

let firstThreeLazy = FizzBuzz()
    .lazy
    .compactMap(Int.init)
    .filter{ $0.isMultiple(of: 3) }
    .prefix(3)

print(Array(firstThreeLazy))


// MARK: - Making an algorithm generic
let values: [Int] = [1, 3, 4, 1, 3, 4, 7, 5]

/*
extension Array {
    func chunks(ofCount chunkCount: Int) -> [[Element]] {
        var result: [[Element]] = []
        for index in stride(from: 0, to: count, by: chunkCount) {
            let lastIndex = Swift.min(count, index + chunkCount)
            result.append(Array(self[index..<lastIndex]))
        }
        return result
    }
}

values.chunks(ofCount: 3)
 */


// A more generic version
extension Collection {
    func chunks(ofCount chunckCount: Int) -> [SubSequence] {
        var result: [SubSequence] = []
        result.reserveCapacity(count / chunckCount + (count % chunckCount).signum())
        var idx = startIndex
        while idx < endIndex {
            let lastIndex = index(idx, offsetBy: chunckCount, limitedBy: endIndex) ?? endIndex
            result.append(self[idx..<lastIndex])
            idx = lastIndex
        }
        return result
    }
}

values.chunks(ofCount: 3)

Array(FizzBuzz().chunks(ofCount: 5).last!)
"Hello World".chunks(ofCount: 3)
