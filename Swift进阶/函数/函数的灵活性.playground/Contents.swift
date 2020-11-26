import UIKit

var str = "Hello, playground"

// “我们需要再写一个接受函数作为参数，并返回函数的函数。这个函数可以把类似 localizedStandardCompare 这种接受两个字符串并进行比较的普通函数，提升成比较两个字符串可选值的函数。如果两个比较值都是 nil，那么它们相等。如果左侧的值是 nil，而右侧不是的话，返回升序，相反的时候返回降序。最后，如果它们都不是 nil 的话，我们使用 compare 函数来对它们进行比较”

func lift<A>(_ compare:@escaping (A) -> (A) -> ComparisonResult) -> (A?) -> (A?) -> ComparisonResult {
    return { lhs in { rhs in
        switch (lhs, rhs) {
        case (nil, nil):
            return ComparisonResult.orderedSame
        case (nil, _):
            return ComparisonResult.orderedAscending
        case (_, nil):
            return ComparisonResult.orderedDescending
        case (let l?, let r?):
            return compare(l)(r)
            }
        }
    }
}

// MARK: - 函数作为代理
/// Cocoa风格的代理
//protocol AlertViewDelegate: AnyObject {
//    func buttonTapped(atIndex: Int)
//}
//
//class AlertView {
//    var buttons: [String]
//    weak var delegate: AlertViewDelegate?
//
//    init(buttons: [String] = ["OK", "Cancel"]) {
//        self.buttons = buttons
//    }
//
//    func fire() {
//        delegate?.buttonTapped(atIndex: 1)
//    }
//
//}
//
//class ViewController: AlertViewDelegate {
//    let alert: AlertView
//
//    init() {
//        alert = AlertView.init()
//        alert.delegate = self
//    }
//
//    func buttonTapped(atIndex: Int) {
//        print(atIndex)
//    }
//}

// MARK: - 结构体上实现代理
protocol AlertViewDelegate {
    mutating func buttonTapped(atIndex: Int)
}

class AlertView {
    var buttons: [String]
    var delegate: AlertViewDelegate?
    
    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }
    
    func fire() {
        delegate?.buttonTapped(atIndex: 1)
    }
}

struct TapLogger: AlertViewDelegate {
    var taps: [Int] = []
    mutating func buttonTapped(atIndex: Int) {
        taps.append(atIndex)
    }
}

let alert = AlertView()
var logger = TapLogger()
alert.delegate = logger
alert.fire()
logger.taps

