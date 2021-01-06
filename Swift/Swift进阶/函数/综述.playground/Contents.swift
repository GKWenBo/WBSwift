import UIKit
import CoreLocation

//func printInt(i: Int) {
//    print("Your passed \(i)")
//}
//
///// 将函数赋值给一个变量
//let funVar = printInt
//funVar(2)
//
//
///// 接受函数作为参数的函数
//func useFunction(function:(Int) -> ()) {
//    function(3)
//}
//
//useFunction(function: printInt)
//useFunction(function: funVar)
//
///// 函数返回其他函数
//func retunFunc() -> (Int) -> String {
//    func innerFunc(i: Int) -> String {
//        return "your passed \(i)"
//    }
//    return innerFunc
//}
//
//let myFunc = retunFunc()
//myFunc(6)
//
///// MARK: - 函数可以捕获存在于它们作用域之外的变量
//func counterFunc() -> (Int) -> String {
//    var counter = 0
//    func innerFunc(i: Int) -> String {
//        counter += i
//        return "Running total: \(counter)"
//    }
//    return innerFunc
//}
//
//let f = counterFunc()
//f(3)
//f(4)
//
//let g = counterFunc()
//g(2)
//g(2)
//
//f(2)
//
///// MARK: - 函数可以使用{}来声明闭包表达式
///// 使用func
//func doubler(i: Int) -> Int {
//    return i * 2
//}
//
//let mapR = [1, 2, 3, 4].map(doubler)
//print(mapR)
//
///// 使用闭包
//let doublerAlt = { (i: Int) -> Int in
//    return i * 2
//}
//print([1, 3, 3, 5].map(doublerAlt))
//
//let mapArray = [1, 2, 3]
//mapArray.map({(i: Int) -> Int in
//    return i * 2
//})
//mapArray.map({ i in return i * 2 })
//mapArray.map({ i in i * 2 })
//mapArray.map({ $0 * 2 })
//mapArray.map() { $0 * 2 }
//mapArray.map{ $0 * 2}
//
//(0..<3).map{ _ in Int.random(in: 1..<100)}
//
//// MARK: - 函数的灵活性
//let myArray = [3, 1, 2]
//myArray.sorted()
//myArray.sorted(by: >)
//
//var numberStrings = [(2, "two"), (1, "one"), (3, "three")]
//numberStrings.sorted(by: <)
//
//let animals = ["elephant", "zebra", "dog"]
//animals.sorted{ lhs, rhs in
//    let l = lhs.reversed()
//    let r = rhs.reversed()
//    return l.lexicographicallyPrecedes(r)
//}
//
//@objcMembers final class Person: NSObject {
//    let first: String
//    let last: String
//    let yearOfBirth: Int
//    init(first: String, last: String, yearOfBirth: Int) {
//        self.first = first;
//        self.last = last;
//        self.yearOfBirth = yearOfBirth
//    }
//}
//
//let people = [
//    Person(first: "Emily", last: "Young", yearOfBirth: 2002),
//    Person(first: "David", last: "Gray", yearOfBirth: 1991),
//    Person(first: "Robert", last: "Barnes", yearOfBirth: 1985),
//    Person(first: "Ava", last: "Barnes", yearOfBirth: 2000),
//    Person(first: "Joanne", last: "Miller", yearOfBirth: 1994),
//    Person(first: "Ava", last: "Barnes", yearOfBirth: 1998),
//]
//
//let lastDescriptor = NSSortDescriptor(key: #keyPath(Person.last), ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
//let firstDescriptor = NSSortDescriptor(key: #keyPath(Person.first), ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
//let yearDescriptor = NSSortDescriptor(key: #keyPath(Person.yearOfBirth), ascending: true)
//
//let descriptors = [lastDescriptor, firstDescriptor, lastDescriptor]
//(people as NSArray).sortedArray(using: descriptors)
//
//
//var strings = ["Hello", "hallo", "Hallo", "hello"]
//strings.sort{ $0.localizedStandardCompare($1) == .orderedAscending}
//people.sorted{ $0.yearOfBirth < $1.yearOfBirth }
//
//people.sorted(by: { p0, p1 in
//    let left = [p0.last, p0.first]
//    let right = [p1.last, p1.first]
//    return left.lexicographicallyPrecedes(right) {
//        $0.localizedStandardCompare($1) == .orderedAscending
//    }
//
//
//})
//
//// MARK: - 函数作为数据
//typealias SortDescriptor<Root> = (Root, Root) -> Bool
//let sortByYear: SortDescriptor<Person> = {
//    $0.yearOfBirth < $1.yearOfBirth
//}
//
//func sortDescriptor<Root, Value>(key: @escaping (Root) -> Value, by areInIncreasingOrder: @escaping (Value, Value) -> Bool) -> SortDescriptor<Root> {
//    return {areInIncreasingOrder(key($0), key($1))}
//}
//
//// MARK: - 函数作为代理
//protocol AlertViewDelegate: AnyObject {
//    func buttonTap(atIndex: Int)
//}
//
//class AlertView {
//    var buttons: [String]
//    weak var delegate: AlertViewDelegate?
//
//    init(buttons: [String]) {
//        self.buttons = buttons
//    }
//
//    func fire() {
//        delegate?.buttonTap(atIndex: 1)
//    }
//
//}
//
//class ViewController: AlertViewDelegate {
//    let alert: AlertView
//
//    init() {
//        alert = AlertView(buttons: ["cancel", "confirm"])
//        alert.delegate = self
//    }
//
//    func buttonTap(atIndex: Int) {
//        print("Button tapend:\(atIndex)")
//    }
//}
//
//// MARK: - 结构体上实现代理
//protocol AlertViewDelegate1 {
//    mutating func buttonTapped(atIndex: Int)
//}
//
//class AlertView1 {
//    var buttons: [String]
//    var delegate: AlertViewDelegate?
//
//    init(buttons: [String]) {
//        self.buttons = buttons
//    }
//
//    func fire() {
//        delegate?.buttonTap(atIndex: 1)
//    }
//}
//
//// MARK: - 使用函数，而非代理
//class AlertView2 {
//    var buttons: [String]
//    var buttonTapped: ((_ buttonIndex: Int) -> ())?
//
//    init(buttons: [String] = ["ok", "cancel"]) {
//        self.buttons = buttons
//    }
//
//    func fire() {
//        buttonTapped?(1)
//    }
//}

// MARK: - inout 参数和可变方法
func increment(value: inout Int) {
    value += 1
}

var i = 0
increment(value: &i)

var array = [0, 1, 2]
increment(value: &array[0])
print(array)


// MARK: - 嵌套函数和inout
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

// MARK: - &不意味inout的情况
func incref(pointer: UnsafeMutablePointer<Int>) -> () -> Int {
    return {
        pointer.pointee += 1
        return pointer.pointee
    }
}

let fun: () -> Int
do {
    var array = [0]
    fun = incref(pointer: &array)
}
fun

// MARK: - 属性
struct GPSTrack {
//    var record: [(CLLocation, Date)] = []
    /// 外部只读，内部可读写
    private(set) var record: [(CLLocation, Date)] = []
    
}

extension GPSTrack {
    var timestamps: [Date] {
        return record.map { $0.1 }
    }
}

// MARK: -变更观察者
class Robot {
    enum State {
        case stopped, movingForward, turningRight
    }
    var state = State.stopped
}

class ObservableRobot: Robot {
    override var state: Robot.State {
        willSet {
            print("Transitioning from \(state) to \(newValue)")
        }
    }
}

var robot = ObservableRobot()
robot.state = .movingForward

// MARK: - 下标
let fibs = [0, 1, 2, 3, 6]
let first = fibs[0]
fibs[1..<3]

extension Collection {
    subscript(indices indexList: Index...) -> [Element] {
        var result: [Element] = []
        for index in indexList {
            result.append(self[index])
        }
        return result
    }
}

// MARK: - 建路径
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
print(streetKeyPath)

let nameKeyPath = \Person.name
print(nameKeyPath)

let simpsonResidence = Address(street: "1094 Evergreen Terrace", city: "Springfield", zipCode: 97979)
var lisa = Person(name: "Lisa Simpson", address: simpsonResidence)

print(lisa[keyPath: nameKeyPath])

// MARK: - 可写键路径
extension NSObjectProtocol where Self: NSObject {
    func observe<A, Other>(_ keyPath: KeyPath<Self, A>,
                           writeTo other: Other,
                           _ otherKeyPath: ReferenceWritableKeyPath<Other, A>) -> NSKeyValueObservation where A: Equatable, Other: NSObjectProtocol {
        return observe(keyPath, options: .new, changeHandler: {_, chage in
            guard let newValue = chage.newValue, other[keyPath: otherKeyPath] != newValue else { return  }
            other[keyPath: otherKeyPath] = newValue
        })
    }
}

extension NSObjectProtocol where Self: NSObject {
    func bind<A, Other>(_ keyPath: ReferenceWritableKeyPath<Self, A>,
                        to other: Other,
                        _ otherKeyPath: ReferenceWritableKeyPath<Other, A>) -> (NSKeyValueObservation, NSKeyValueObservation) where A: Equatable, Other: NSObject {
        let one = observe(keyPath, writeTo: other, otherKeyPath)
        let two = other.observe(otherKeyPath, writeTo: self, keyPath)
        return (one, two)
    }
}

final class Person1: NSObject {
    @objc dynamic var name: String = ""
}

class TextField: NSObject {
    @objc dynamic var text: String = ""
}

let person = Person1()
let textField = TextField()

let observation = person.bind(\.name, to: textField, \.text)

person.name = "wenbo"
print(textField.text)
