import UIKit

// MARK: - Arithmetic operators
let firstScore = 12
let secondScore = 4

let total = firstScore + secondScore
let difference = firstScore - secondScore
let product = firstScore * secondScore
let divided = firstScore / secondScore
let remainder = 13 % secondScore


let weeks = 465 / 7
print("There are \(weeks) until the event.")

let weeks1: Double = 465 / 7
print("There are \(weeks1) until the event.")


let weeks2 = 465 / 7
let days = 465 % 7
print("There are \(weeks2) weeks and \(days) days until the event.")

let number = 465
let isMultiple = number.isMultiple(of: 7)

// MARK: - Operator overloading
let meaningOfLife = 42
let doubleMeaning = 42 + 42

let str = "one" + "two"

let firstArray = ["1", "2"]
let secondArray = ["3", "4"]

let array = firstArray + secondArray

// MARK: - Compound assignment operators
var score = 96
score -= 5
print(score)

var quote = "The rain in Spin falls mainly on the"
quote += "Spaniards"

// MARK: - Comparison operators
let firstScore1 = 6
let secondScore1 = 4

firstScore1 == secondScore1
firstScore1 != secondScore1

firstScore1 < secondScore1
firstScore1 > secondScore1

firstScore1 >= secondScore1

"Toylor" <= "Swift"

let firstName = "Paul"
let secondName = "Sophie"

let firstAge = 40
let secondAge = 10

print(firstName == secondName)
print(firstName != secondName)
print(firstName < secondName)
print(secondName >= secondName)

//enum Sizes: Comparable {
//    case small
//    case medium
//    case large
//}
//
//let first = Sizes.small
//let second = Sizes.large
//print(first < second)


// MARK: - Conditions
let firstCard = 11
let secondCard = 10

if firstCard + secondCard == 21 {
    print("Blackjack!")
} else {
    print("Regular cards")
}

if firstCard + secondCard == 21 {
    print("Regular cards")
} else if firstCard + secondCard == 2 {
    print("Regular cards1")
} else {
    print("Regular cards2")
}

// MARK: - Combining conditions
let age1 = 12
let age2 = 21

if age1 > 18 && age2 > 18 {
    print("Both are over 18")
}

// MARK: - The ternary operator
let firstCard1 = 11
let secondCard1 = 10

print(firstCard1 == secondCard1 ? "Card are the same" : "Card are different")


// MARK: - Switch statements
let weather = "sunny"
switch weather {
case "rain":
    print("Bring an umbrella")
case "snow":
    print("Wrap up warm")
case "sunny":
    print("Wear sunscreen")
    fallthrough
default:
    print("Enjoy you day!")
}

// MARK: - Range operators
let score1 = 85
switch score1 {
case 0..<50:
    print("You failed badly.")
case 50..<85:
    print("You did OK.")
default:
    print("you did great!")
}

let names = ["Piper", "Alex", "Suzanne", "Gloria"]
print(names[0])

print(names[0...3])

print(names[1...])

