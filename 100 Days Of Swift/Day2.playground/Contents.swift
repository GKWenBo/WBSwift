import UIKit

// MARK: - Set
let colors = Set(["red", "green", "blue"])

// MARK: - Tuples
var name = (first: "Taylor", last: "Swift")
print(name.0)
print(name.first)

var person = (name: "Paul", age: 40, isMarrid: true)

/// MARK: Arrays vs sets vs tuples
let address = (house: 555, street: "Taylor Swift Avenue", city: "America")

let set = Set(["addreee", "afdd", "addafda"])

let pythons = ["Eric", "John"]

// MARK: - Dictionaries
let heights = ["Taylor Swift" : 1.78,
               "Ed Sheeran" : 1.73]
print(heights["Taylor Swift"])

// MARK: - Dictionary default values
let favoriteIceCream = ["Paul" : "Chocolate", "Sophie" : "Vanilla"]
print(favoriteIceCream["Paul"])
print(favoriteIceCream["aa", default : "Unknown"])


// MARK: - Creating empty collections
var teams = [String : String]()
teams["Paul"] = "Red"

var results = [Int]()
var words = Set<String>()
var numbers1 = Set<Int>()

var scores = Dictionary<String, Int>()
var results1 = Array<Int>()

// MARK: - Enumerations
enum Result {
    case success
    case failure
}

let result = Result.failure

// MARK: - Enum associated values
enum Activity {
    case bored
    case running
    case taking
    case singing
}

enum Activity1 {
    case bored
    case runing(destination: String)
    case talking(topic: String)
    case singing(volume: Int)
}

let talking = Activity1.talking(topic: "football")

