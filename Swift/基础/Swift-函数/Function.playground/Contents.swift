import UIKit

/*
 一个可变参数（variadic parameter）可以接受零个或多个值。函数调用时，你可以用可变参数来指定函数参数可以被传入不确定数量的输入值。通过在变量类型名后面加入（...）的方式来定义可变参数。
 可变参数的传入值在函数体中变为此类型的一个数组。例如，一个叫做 numbers 的 Double... 型可变参数，在函数体内可以当做一个叫 numbers 的 [Double] 型的数组常量


func arithmeticMean(_ numbers: Double...) -> Double {
    var total = 0.0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}

let result1 = arithmeticMean(1, 2, 3)
print(result1)
 
*/

/*
 输入输出参数

func swapTwoInts(_ a: inout Int, _ b: inout Int) -> Void {
    let tempInt = a
    a = b
    b = tempInt
}

var intA = 10
var IntB = 20


swap(&intA, &IntB)
print("intA is now \(intA), intB is now \(IntB)")
*/

/*
 使用函数类型
 在 Swift 中，使用函数类型就像使用其他类型一样。例如，你可以定义一个类型为函数的常量或变量，并将适当的函数赋值给它
 

func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}

func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}

var mathFunction:(Int, Int) -> Int = addTwoInts
print("mathFunction = \(mathFunction(5, 6))")
mathFunction = multiplyTwoInts
print("multiplyTwoInts = \(multiplyTwoInts(2, 3))")
 
 */

/*
 函数类型作为参数类型
 你可以用 (Int, Int) -> Int 这样的函数类型作为另一个函数的参数类型。这样你可以将函数的一部分实现留给函数的调用者来提供。


func printMathResult(_ mathFunction: (Int, Int) -> Int, a: Int, b: Int) {
    print("Result: \(mathFunction(a, b))")
}

printMathResult(addTwoInts, a: 6, b: 6)

*/

/*函数类型作为返回类型
 你可以用函数类型作为另一个函数的返回类型。你需要做的是在返回箭头（->）后写一个完整的函数类型。
 */

/*
func stepForward(_ input: Int) -> Int {
    return input + 1
}

func stepBackward(_ input: Int) -> Int {
    return input - 1
}


func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepBackward;
}
 */

/*
 嵌套函数
 到目前为止本章中你所见到的所有函数都叫全局函数（global functions），它们定义在全局域中。你也可以把函数定义在别的函数体中，称作 嵌套函数（nested functions）。
 默认情况下，嵌套函数是对外界不可见的，但是可以被它们的外围函数（enclosing function）调用。一个外围函数也可以返回它的某一个嵌套函数，使得这个函数可以在其他域中被使用。
 */
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(_ input: Int) -> Int {return input + 1}
    func stepBackward(_ input: Int) -> Int {return input - 1}
    return backward ? stepBackward : stepForward
}


var currentValue = 3
let moveToZero = chooseStepFunction(backward: currentValue > 0)
//print("\(currentValue)")

while currentValue != 0 {
    print("\(currentValue)")
    currentValue = moveToZero(currentValue)
}
print("zero")



