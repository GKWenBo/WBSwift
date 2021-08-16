//: [Previous](@previous)

import Foundation

//struct Poker {
//    enum Suit: Character {
//        case "♥"
//    }
//}

// MARK: 闭包表达式简写
//var fn = { (v1: Int, v2: Int) -> Int in
//    return v1 + v2
//}
//fn(10, 20)
//
//func exec(v1: Int, v2: Int, fn: (Int, Int) -> Int) {
//    print(fn(v1, v2))
//}
//
//exec(v1: 10, v2: 20) { v1, v2 in
//    v1 + v2
//}
//
//exec(v1: 10, v2: 20, fn: { $0 + $1 })
//
//exec(v1: 10, v2: 20, fn: + )

// MARK: - 尾随闭包
func exec(fn: (Int, Int) -> Int) {
    print(fn(1, 2))
}

exec(fn: { $0 + $1 })
exec() { $0 + $1 }
exec { $0 + $1 }

exec(fn: { _,_ in 10 })

// MARK: - 数组排序
func testSort() {
    var array = [1, 3, 45, 8, 23]
//    array.sort()
//    array.sort(by: > )
    array.sort { $0 > $1 }
    print(array)
}

testSort()

// MARK: - 闭包
typealias Fn = (Int) -> Int
func getFn() -> Fn {
    var num = 0
    func plus(_ i: Int) -> Int {
        num += i;
        return num
    }
    return plus
}

var fn = getFn()
print(fn(1))
print(fn(2))
print(fn(3))
print(fn(4))

class Closure {
    var num = 0
    func plus(_ i: Int) -> Int {
        num += 1
        return num
    }
}


//: [Next](@next)
