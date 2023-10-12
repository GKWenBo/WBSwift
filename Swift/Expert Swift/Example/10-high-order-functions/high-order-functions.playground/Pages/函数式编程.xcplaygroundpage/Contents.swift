//: [Previous](@previous)

import Foundation

// MARK: - FP实践-传统写法
func add(_ v1: Int, _ v2: Int) -> Int {
    v1 + v2
}

func sub(_ v1: Int, _ v2: Int) -> Int {
    v1 - v2
}

func multiple(_ v1: Int, _ v2: Int) -> Int {
    v1 * v2
}

func divide(_ v1: Int, _ v2: Int) -> Int {
    v1 / v2
}

func mod(_ v1: Int, _ v2: Int) -> Int {
    v1 % v2
}

var num = 1
divide(mod(sub(multiple(add(num, 3), 5), 1), 10), 2)

// MARK: - FP实践 - 函数式写法
func add(_ v1: Int) -> (Int) -> Int {
    return {
        $0 + v1
    }
}

func multiple(_ v1: Int) ->(Int) -> Int {
    return {
        $0 * v1
    }
}

func sub(_ v1: Int) -> (Int) -> Int {
    return {
        $0 - v1
    }
}

func divide(_ v1: Int) -> (Int) -> Int {
    return {
        $0 / v1
    }
}

func mod(_ v1: Int) -> (Int) -> Int {
    return {
        $0 % v1
    }
}

infix operator >>> : AdditionPrecedence
func >>><A, B, C>(_ f1: @escaping (A) -> B,
                  _ f2: @escaping (B) -> C) -> (A) -> C {
    return {
        f2(f1($0))
    }
}

var fn = add(3) >>> multiple(5) >>> sub(1) >>> mod(10) >>> divide(2)
fn(num)

// MARK: - 高阶函数
/*
 1、接受一个或多个函数作为输入（map、filter、reduce）
 2、返回一个函数
 */

// MARK: - 柯里化
// (A, B) -> C
func add1(_ v: Int, _ v1: Int) -> Int {
    v + v1
}

// (A, B, C) -> D
func add2(_ v1: Int, _ v2: Int, _ v3: Int) -> Int {
    v1 + v2 + v3
}

func curringAdd1(_ v: Int) -> (Int) -> Int { { $0 + v } }

curringAdd1(10)(20)

func currying<A, B, C>(_ fn: @escaping (A, B) -> C) -> (B) -> (A) -> C {
    return { b in
        return { a in
            fn(a, b)
        }
    }
}

func currying<A, B, C, D>(_ fn: @escaping (A, B, C) -> D) -> (C) -> (B) -> (A) -> D {
    return { c in
        return { b in
            return { a in
                fn(a, b, c)
            }
        }
    }
}

let curryingAdd1 = currying(add1)
print(curryingAdd1(10)(20))

let curryingAdd2 = currying(add2)
print(curryingAdd2(10)(20)(30))


prefix func ~<A, B, C>(_ fn: @escaping (A, B) -> C) -> (B) -> (A) -> C {
    return { b in
        return { a in
            fn(a, b)
        }
    }
}

var num1 = 1
var fn1 = (~add)(3) >>> (~multiple)(5) >>> (~sub)(1) >>> (~mod)(10) >>> (~divide)(2)
fn(num1)

//: [Next](@next)
