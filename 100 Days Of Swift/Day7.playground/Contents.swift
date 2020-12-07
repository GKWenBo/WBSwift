import UIKit

// MARK: - Using closures as parameters when they accept parameters
//func travel(action: (String) -> Void) {
//    print("I'm getting ready to go.")
//    action("London")
//    print("I arrived")
//}
//
//travel { (place: String) in
//    print("I'm going to \(place) in my car")
//}


// MARK: - Using closures as parameters when they return values
//func travel(action: (String) -> String) {
//    print("I'm geting ready to go.")
//    let description = action("London")
//    print(description)
//    print("I arrived!")
//}
//
//travel { (place: String) -> String in
//    return "I'm going to \(place) in my car"
//}
//
//// MARK: - When would you use closures with return values as parameters to a function?
//func reduce(_ values: [Int], using closure: (Int, Int) -> Int) -> Int {
//    var current = values[0]
//
//    for value in values[1...] {
//        current = closure(current, value)
//    }
//    return current
//}
//
//
//let numbers = [10, 20, 30]
//let sum = reduce(numbers) { (runningTotal, next) -> Int in
//    runningTotal + next
//}
//print(sum)
//
//
//let multiplied = reduce(numbers, using: {
//    $0 * $1
//})
//print(multiplied)
//
//let sum1 = reduce(numbers, using: +)

// MARK: - Shorthand parameter names
//func travel(action: (String) -> String) {
//    print("I'm getting ready to go.")
//    let description = action("London")
//    print(description)
//    print("I arrived!")
//}
//
//travel { (place: String) -> String in
//    return "I'm going to \(place) in my car"
//}
//
//travel { place in
//    return "I'm going to \(place) in my car"
//}
//
//travel {
//    return "I'm going to \($0) in my car"
//}

// MARK: - Returning closures from functions
//func travel() -> (String) -> Void {
//    return {
//        print("I'm going to \($0)")
//    }
//}
//
//let result = travel()
//result("London")
//
//let results2 = travel()("London")

// MARK: - Capturing values
//func travel() -> (String) -> Void {
//    var counter = 1
//
//    return {
//        print("I'm going to \($0)")
//        counter += 1
//    }
//}
//
//let result = travel()
//result("London")
//
//result("London")
//result("London")
//result("London")

// MARK: - Why do Swift’s closures capture values?
func makeRamdomNumberGenerrator() -> () -> Int {
    var previousNumber = 0
    return {
       
        var newNumber: Int
        
        repeat {
            newNumber = Int.random(in: 1...3)
        } while newNumber == previousNumber
        
        previousNumber = newNumber
        return newNumber
    }
}

let generator = makeRamdomNumberGenerrator()

for _ in 0...10 {
    print(generator())
}

