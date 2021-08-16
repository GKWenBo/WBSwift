//: [Previous](@previous)

import Foundation

//var age: Int = 15
//print(age)
//
//var age1: Int? = 10
//print(age1)
//print(age1!)
//
//// MARK: - 可选项绑定
//if let number = Int("123") {
//    print("字符串转换成整数成功：\(number)")
//} else {
//    print("字符串转换整数失败")
//}
//
//enum Season: Int {
//    case spring = 1, summer
//}
//
//if let season = Season.init(rawValue: 6) {
//    switch season {
//    case .summer:
//        print("summer")
//    default: break
//    }
//} else {
//    print("no such season")
//}
//
//var a: Int? = nil
//let b: Int? = 2
//
//
//let c = a ?? 0
//let d = a ?? b

// MARK: - ??跟if let配合使用
//let a: Int? = nil
//let b: Int? = 2
//if let c = a ?? b {
//    print(c)
//}
//// 类似于 a != nil, b != nil
//
//var dict = ["age" : 10]
//let age0 = dict["age"]
//
//if let age = dict["age"] {
//    print(age)
//}

// MARK: - 多重可选项
var num1: Int? = 10
var num2: Int?? = num1
var num3: Int?? = 10
print(num1 == num2)
print(num2 == num3)

//: [Next](@next)
