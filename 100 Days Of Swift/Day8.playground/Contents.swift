import UIKit

struct Sport {
    var name: String
}

var tennis = Sport(name: "Tennis")
print(tennis.name)

tennis.name = "Lwan tennis"

// MARK: - Property observers
struct Progress {
    var task: String
    var amount: Int {
        didSet {
            print("\(task) is now \(amount)% complete")
        }
    }
}

// MARK: - Mutating methods
struct Persion {
    var name: String
    
    mutating func makeAnonymous() {
        name = "aaaa"
    }
}

var persion = Persion(name: "Ed")
persion.makeAnonymous()

// MARK: - Properties and methods of strings
let string = "Do or do not, there is no try."
print(string.count)
print(string.hasPrefix("Do"))
print(string.uppercased())
print(string.sorted())


// MARK: - Properties and methods of arrays
var toys = ["Woody"]

print(toys.count)
toys.append("Buzz")
toys.firstIndex(of: "Buzz")
print(toys.sorted())
toys.remove(at: 0)

