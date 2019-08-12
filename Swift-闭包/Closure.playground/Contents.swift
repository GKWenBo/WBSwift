import UIKit

/*
 闭包是自包含的函数代码块，可以在代码中被传递和使用。Swift 中的闭包与 C 和 Objective-C 中的代码块（blocks）以及其他一些编程语言中的匿名函数（Lambdas）比较相似。
 */

/*
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2;
}

var reversedNames = names.sorted(by: backward);
print(reversedNames)

reversedNames = names.sorted(by: {(s1: String, s2: String) -> Bool in
    return s1 > s2
})

print(reversedNames)

//单表达式闭包的隐式返回
reversedNames = names.sorted(by: { s1,s2 in s1 > s2 })
print(reversedNames)

//参数名称缩写
reversedNames = names.sorted(by: {$0 > $1})
print(reversedNames)

//运算符方法
reversedNames = names.sorted(by: >);
print(reversedNames)
 */


/*
//尾随闭包
let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

func someFunctionThatTakesAClosure(closure: () -> Void) {
    
}

someFunctionThatTakesAClosure {
    
}

let strings = numbers.map {
    (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}

print(strings)
 */

func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)

incrementByTen()
incrementByTen()
