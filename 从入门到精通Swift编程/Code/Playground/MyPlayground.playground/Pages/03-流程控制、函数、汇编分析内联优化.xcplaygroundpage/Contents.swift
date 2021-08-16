//: [Previous](@previous)

import Foundation

let names = ["aaa", "bbb", "ccc", "ddd"]


/// 闭区间运算符：a...b
for i in 0...3 {
    print(i)
}

let range = 1...3
for i in range {
    print(i)
}

for _ in range {
    print("1")
}

/// 半开区间 a..<b
for i in 0..<3 {
    print(i)
}


/// 单侧区间：让区间朝一个方向尽可能的远
for name in names[2...] {
    print(name)
}

let str = "a"
let a: Character = "a"
let stringRange1 = "cc"..."ff"
stringRange1.contains("df")


/// where
var numbers = [-1, 2]
for num in numbers where num > 0 {
    
}

// MARK: - 函数

/// 求和
/// - Parameters:
///   - v1: v1 description
///   - v2: v2 description
/// - Returns: 和
func sum(v1: Int, v2: Int) -> Int { v1 + v2 }

sum(v1: 10, v2: 20)

// MARK: - 输入输出参数inout
var number = 10
func add(num: inout Int) {
    num += 1
}

add(num: &number)
print(number)

//: [Next](@next)

