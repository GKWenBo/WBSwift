import UIKit

/*
 “一个 inout 参数持有一个传递给函数的值，函数可以改变这个值，然后从函数中传出并替换掉原来的值。”

 摘录来自: Chris Eidhof. “Swift 进阶。” Apple Books.
 */

func increment(value: inout Int) {
    value += 1
}

var i = 0
increment(value: &i)
print(i)


var array = [0, 1, 2]
increment(value: &array[0])
print(array)

/*
 “如果一个属性是只读的 (也就是说，只有 get 可用)，我们将不能将其用于 inout 参数”

 摘录来自: Chris Eidhof. “Swift 进阶。” Apple Books.
 */

struct Point {
    var x: Int
    var y: Int
}

var point = Point(x: 0, y: 0)
increment(value: &point.x)


extension Point {
    var squaredDistance: Int {
        return x * x + y * y
    }
}

/// error
//increment(value: &point.squaredDistance)

// MARK: - “嵌套函数和 inout”
func incrementTenTimes(value: inout Int) {
    func inc() {
        value += 1
    }
    
    for _ in 0..<10 {
        inc()
    }
}

var x = 0
incrementTenTimes(value: &x)
print(x)

/*
 “不过，你不能够让这个 inout 参数逃逸 (我们会在本章最后详细讨论逃逸函数的内容)：

 func escapeIncrement(value: inout Int) -> () -> () {
     func inc() {
         value += 1
     }
     // error: 嵌套函数不能捕获 inout 参数然后让其逃逸
     return inc
 }”
 */


// MARK: - “& 不意味 inout 的情况”
/*
 “说到不安全 (unsafe) 的函数，你应该小心 & 的另一种含义：把一个函数参数转换为一个不安全指针。

 如果一个函数接受 UnsafeMutablePointer 作为参数，你可以用和 inout 参数类似的方法，在一个 var 变量前面加上 & 传递给它。在这种情况下，你确实在传递引用，更确切地说，是在传递指针。”
 */
func incref(pointer: UnsafeMutablePointer<Int>) -> () -> Int {
    return {
        pointer.pointee += 1
        return pointer.pointee
    }
}

let fun:() -> Int
do {
    var array = [0]
    fun = incref(pointer: &array)
}
fun()
