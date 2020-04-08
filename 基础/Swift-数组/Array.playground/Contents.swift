import UIKit

let fibs = [0, 1, 2, 3]

/// 创建可变数组
var  mutableFibs = [0, 1, 2, 3]
mutableFibs.append(10)
mutableFibs.append(contentsOf: [14, 15])

/// 数组具有值语义
var x = [1, 2, 3]
var y = x

y.append(4)
print(x)
print(y)

// MARK: - 数组变形
/// Map
var fibs1 = [0, 1, 2, 3]
let fibs2 = fibs1.map({fib in fib * fib})
print(fibs2)


extension Array {
    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map({next in
            running = nextPartialResult(running, next)
            return running
        })
    }
}

[1,2,3,4].accumulate(0, +)

/// - filter
let nums = [1,2,3,4,5,6,7,8,9,10]
let nums1 = nums.filter({ $0 % 2 == 0 })
print(nums1)

/// 为了寻找所有 100 以内的偶平方数
let arr = (1..<10).map({ $0 * $0}).filter({ $0 % 2 == 0 })
print(arr)

/// - reduce
let fibs3 = [1, 2, 3, 4, 5]
let sum = fibs3.reduce(0){total, num in total + num }
print(sum)
fibs3.reduce(0, +)

/// 将一个整数列表转换为一个字符串
let str = fibs3.reduce("", { str, sum in
    str + "\(sum)$"
})
print(str)

/// - flatMap
let suits = ["♠︎", "♥︎", "♣︎", "♦︎"]
let ranks = ["J","Q","K","A"]
suits.compactMap({ suit in
    ranks.map({ rank in
        (suit, rank)
    })
})

/// - forEach
[1, 3, 4].forEach({ element in
    print(element)
})


/// 数组切片
let slice = fibs[1...]
type(of: slice)
let newArray = Array(slice)
type(of: newArray)
