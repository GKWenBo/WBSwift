//: [Previous](@previous)

import Foundation
import UIKit

// MARK: - 可变和带有状态的闭包
extension Array {
    func accumulate<Result>(_ initialResult: Result, 
                            _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}

[1,2,3,4].accumulate(0, +)

// MARK: - filter
let lazyFilter = [1,2,3,4,5,6].lazy.filter { $0 % 2 == 0 }
let filter = [1,2,3,4,5,6].filter { $0 % 2 == 0 }

// MARK: - reduce
let fibs = [0, 1, 1, 2, 3, 5]
let sum = fibs.reduce(0, +)

// MARK: - 在字符串插值中使用可选值
infix operator ???: NilCoalescingPrecedence
public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    guard let value = optional else { return defaultValue() }
    return String(describing: value)
}

let bodyTemperature: Double? = 37.0
let bloodGlucose: Double? = nil
print(bodyTemperature) // Optional(37.0)”
print("Body Temperature: \(bodyTemperature ??? "N/A")")
print("Blood Glucose: \(bloodGlucose ??? "N/A")")

// MARK: - 改进强制解包错误信息
infix operator !!
func !!<T>(wrappered: T?, failureText: @autoclosure () -> String) -> T {
    if let x = wrappered {
        return x
    }
    fatalError(failureText())
}

let s = "foo"
//let i = Int(s) !! "Expecting integer, got \"\(s)\""

// MARK: - 在调试版本中使用断言
infix operator !?
func !?<T>(wrappered: T?, nilDefault: @autoclosure () -> (value: T, text: String)) -> T {
    assert(wrappered != nil, nilDefault().text)
    return wrappered ?? nilDefault().value
}


// MARK: - 属性包装
class MyView: UIView {
    @Invalidating(.layout) var pageSize: CGSize = .init(width: 800, height: 200)
}

@propertyWrapper
class Box<A> {
    var wrappedValue: A
    init(wrappedValue: A) {
        self.wrappedValue = wrappedValue
    }
}

struct Checkbox {
    @Box var isOn: Bool = false
    func didTap() {
        isOn.toggle()
    }
}


//@propertyWrapper
//class Reference<A> {
//    private var _get: () -> A
//    private var _set: (A) -> ()
//    var wrappedValue: A {
//        get { _get() }
//        set { _set(newValue) }
//    }
//    init(get: @escaping () -> A, set: @escaping (A) -> ()) {
//        _get = get
//        _set = set
//    }
//}
//
//extension Box {
//    var projectedValue: Reference<A> {
//        Reference<A>(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
//    }
//}
//
//struct Person {
//    var name: String
//}
//
//struct PersonEditor {
//    @Reference var person: Person
//}
//
//func makeEditor() -> PersonEditor {
//    @Box var person = Person(name: "Chris")
//    PersonEditor(person: $person)
//}

// MARK: - 键路径
struct Address {
    var street: String
    var city: String
    var zipCode: Int
}

struct Person {
    let name: String
    var address: Address
}

let streetKeyPath = \Person.address.street
let nameKeyPath = \Person.name

"Hello"[keyPath: \.count]
"Hello".count

let simpsonResidence = Address(street: "Evergreen Terrace", city: "Springfield", zipCode: 12345)
var lisa = Person(name: "Lisa", address: simpsonResidence)

lisa[keyPath: nameKeyPath]

var bart = Person(name: "Bart", address: simpsonResidence)
let people = [lisa, bart]
people[keyPath: \.[1].name]

//“Key Paths Can Be Modeled with Functions”
people.map(\.name)

// MARK: - unowned引用
class Window {
    var rootView: View?
    deinit {
        print("Window deinit")
    }
}

class View {
    unowned var window: Window
    init(window: Window) {
        self.window = window
    }
    deinit {
        print("View deinit")
    }
}

var window: Window? = Window()
var view: View? = View(window: window!)
window?.rootView = view

view = nil
window = nil

//: [Next](@next)
