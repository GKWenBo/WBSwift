import UIKit

//var str = "Hello, playground"
// MARK: - Creating basic closures
//let driving = {
//    print("I'm driving in my car")
//}
//
//driving()
//
//// MARK: - Accepting parameters in a closure
//let driving1 = { (place: String) in
//    print("I'm going to \(place) in my car")
//}
//
//driving1("China")

// MARK: - 为什么Swift的闭包参数放在花括号内？
//func pay(user: String, amount: Int) {
//
//}
//
//let payment = { (user: String, amount: Int) in
//
//}

// MARK: - Returning values from a closure
//let drivingWithReturn = { (place: String) -> String in
//    return "I'm going to \(place) in my car"
//}
//
//let message = drivingWithReturn("London")
//print(message)
//
//
//let payment = { (user: String) -> Bool in
//    print("Paying \(user)")
//    return true
//}
//
//let payment1 = { () -> Bool in
//    return false
//}


// MARK: - Closures as parameters
//let driving = {
//    print("test string")
//}
//
//func travel(action: () -> Void) {
//    print("I'm getting ready to go")
//    action()
//    print("I'm arrived!")
//}
//
//travel(action: driving)

// MARK: - Trailing closure syntax
func travel(action: () -> Void) {
    print("aaaa")
    action()
    print("bbbb")
}

travel() {
    print("cccc")
}

travel {
    print("cccc")
}
