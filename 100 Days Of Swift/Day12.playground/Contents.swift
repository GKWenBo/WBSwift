import UIKit

// MARK: - Unwrapping optionals
var name: String? = nil

if let unwrapped = name {
    print("\(unwrapped.count) letters")
} else {
    print("Missing name.")
}

// MARK: - Unwrapping with guard


// MARK: - Force unwrapping
let num = Int("1")!


// MARK: - Nil coalescing
func username(for id: Int) -> String? {
    if id == 1 {
        return "Talor Swift"
    } else {
        return nil
    }
}

let user = username(for: 15) ?? "Anonymous"

// MARK: - When should you use nil coalescing in Swift?
let scores = ["Picard": 800, "Data": 9000, "Troi": 900]

let crusherScore = scores["Crusher"] ?? 0

let crusherScore1 = scores["Crusher", default: 0]


// MARK: - Optional chaining
let names = ["John", "Paul", "George", "Ringo"]

let beatle = names.first?.uppercased()


// MARK: - Optional try
enum PasswordError: Error {
    case obvious
}

func checkPassword(_ passwrod: String) throws -> Bool {
    if passwrod == "password" {
        throw PasswordError.obvious
    }
    return true
}

do {
    try checkPassword("password")
} catch {
    print("You can't use that password.")
}

if let result = try? checkPassword("password") {
    print("Result was \(result)")
} else {
    print("D'oh.")
}

try! checkPassword("sekrit")
print("OK!")

// MARK: - Failable initializers
struct Person {
    var id: String
    
    init?(id: String) {
        if id.count == 9 {
            self.id = id
        } else {
            return nil
        }
    }
}

// MARK: - Typecasting
class Animal {}
class Fish: Animal {
    
}
class Dog: Animal {
    func makeNoise() {
        print("Woof!")
    }
}

let pets = [Fish(), Dog(), Fish(), Dog()]
for pet in pets {
    if let dog = pet as? Dog {
        dog.makeNoise()
    }
}
