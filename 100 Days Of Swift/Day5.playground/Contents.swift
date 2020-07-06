import UIKit

// MARK: - Writing functions
func printHelp() {
    let message = """
Welcome to MyApp!

Run this app inside a directory of images and
MyApp will resize them all into thumbnails
"""

    print(message)
}

printHelp()

// MARK: - Accepting parameters
func square(number: Int) {
    print(number * number)
}
square(number: 8)

// MARK: - Returning values
func squre(number: Int) -> Int {
    return number * number
}

let result = squre(number: 8)
print(result)

func getUser() -> (first: String, last: String) {
    (first: "first", last: "Swift")
}
let user = getUser()
print(user.first)

// MARK: - Parameter labels
func sayHello(to name: String) {
    print("Hello, \(name)!")
}

sayHello(to: "Taylor")

// MARK: - Default parameters
func greet(_ person: String, nicely: Bool = true) {
    if nicely == true {
        print("Hello, \(person)!")
    } else {
        print("Oh no, it's \(person) again...")
    }
}

greet("Taylor")
greet("Taylor", nicely: false)

// MARK: - Variadic functions
print("Haters", "gonna", "hate")
func square(numbers: Int...) {
    for number in numbers {
        print("\(number) squred is \(number * number)")
    }
}

square(numbers: 1, 2, 3, 4, 5)

// MARK: - Writing throwing functions
enum PasswirdErrir: Error {
    case obvious
}

func checkPassword(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswirdErrir.obvious
    }
    return true
}

// MARK: - Running throwing functions
do {
    try checkPassword("password")
    print("That password is good!")
} catch {
    print("You can't user that password.")
}

// MARK: - inout parameters
func doubleInPlace(number: inout Int) {
    number *= 2
}

var myNum = 10
doubleInPlace(number: &myNum)
print(myNum)

