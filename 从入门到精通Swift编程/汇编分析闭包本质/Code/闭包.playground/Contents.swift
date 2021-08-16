import UIKit

typealias Fn = (Int) -> (Int, Int)

func getFn() -> (Fn, Fn) {
    var num1 = 0
    var num2 = 0
    
    func plus(_ i: Int) -> (Int, Int) {
        num1 += i
        num2 += i << 1
        return (num1, num2)
    }
    
    func minus(_ i: Int) -> (Int, Int) {
        num1 -= i
        num2 -= i << 1
        return (num1, num2)
    }
    
    return (plus, minus)
}


let (p, m) = getFn()

print(p(6))
print(m(5))
print(p(4))
print(m(3))

// MARK: - 自动闭包

/// <#Description#>
/// - Parameters:
///   - v1: <#v1 description#>
///   - v2: 自动闭包，有可能延迟执行
/// - Returns: Int
func getFirstPositive(_ v1: Int, _ v2: @autoclosure () -> Int) -> Int {
    return v1 > 0 ? v1 : v2()
}

getFirstPositive(10, 20)
