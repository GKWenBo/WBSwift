import UIKit

/// where
for i in 0..<10 where i % 2 == 0 {
    print(i)
}

/// while
var iterator = (0..<10).makeIterator()
while let i = iterator.next() {
    guard i % 2 == 0 else {
        continue
    }
    print(i)
}

// MARK: -双重可选值
let stringNumbers = ["1", "2", "three"]
let maybeInts = stringNumbers.map({ Int($0) })
for maybeint in maybeInts {
    print(maybeint as Any)
}

/// 使用case进行模式匹配
for case let i? in maybeInts {
    print(i)
}
for case let nil in maybeInts {
    print("No Value")
}
for case let .some(i) in maybeInts {
    print("some i \(i)")
}

let j = 5

/// “基于 case 的模式匹配可以让我们把在 switch 的匹配中用到的规则同样地应用到 if，for 和 while 上去”
if case 0..<10 = 5 {
    print("\(j)在范围内")
}


// MARK: -If var and while var
let number = "1"
if var i = Int(number) {
    i += 1
    print(i)
}

// MARK: -解包后可选值的作用域
let array = [1, 2, 3]
if !array.isEmpty {
    print(array[0])
}

if let firstElement = array.first {
    print(firstElement)
}

extension String {
//    var fileExtension: String? {
//        let period: String.Index
//        if let idx = lastIndex(of: ".") {
//            period = idx
//        } else {
//            return nil
//        }
//
//        let extensionStart = index(after: period)
//        return String(self[extensionStart...])
//    }
    
    /// 优化
    var fileExtension: String? {
        guard let period = lastIndex(of: ".") else { return nil }
        
        let extensionStart = index(after: period)
        return String(self[extensionStart...])
    }
}

let path = "hello.text"
print(path.fileExtension)

func doStuff(withArray a: [Int]) {
    guard let firstElement = a.first else { return }
    
    /// firstElement 在这里已经被解包了
}

func unimplemented() -> Never {
    fatalError("This code path is not implemented yet.")
}

/// “比如上面的空数组的例子可以用 guard 重写为”
func doStuff1(withArray a: [Int]) {
    guard !a.isEmpty else {
        return
    }
    
    /// 现在可以安全使用a[0]或a.first!了
}

// MARK: 可选链
let str: String? = "Never say never"
let upper: String
if str != nil {
    upper = str!.uppercased()
} else {
    fatalError("no idea what to do new ...")
}

let lower = str?.uppercased().lowercased()
print(lower)

extension Int {
    var half: Int? {
        guard self < -1 || self > 1 else {
            return nil
        }
        return self / 2
    }
}

20.half?.half?.half

/// “可选链对下标操作也同样适用”
let dictArrays = ["nine" : [1, 2, 3, 4]]
let value =
dictArrays["nine"]?[3]
type(of: value)

let dictOfFunctions: [String : (Int, Int) -> Int] = [
    "add" : (+),
    "subtract" : (-)
]
dictOfFunctions["add"]!(1, 1)


/// “设想一个类在某个事件发生时，要通过调用存储在其中的回调函数来通知其所有者，上面的特性就会非常有用”
class TextFild {
    private(set) var text = ""
    var didChange: ((String) -> ())?
    
    func textDidChange(newText: String) {
        text = newText
        
        /// 如果不为nil，触发回调
        didChange?(text)
    }
}


/// “请注意 a = 10 和 a? = 10 的细微不同。前一种写法无条件地将一个新值赋给变量，而后一种写法只在 a 的值在赋值发生前不是 nil 的时候才生效”
var a: Int? = 5
a? = 10
print(a)

var b: Int? = nil
b? = 10
print(b)

/// MARK: - nil合并运算符
let stringInterger = "1"
let number1 = Int(stringInterger) ?? 0

let arr = [1, 3, 5]
arr.first ?? 0

extension Array {
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex..<endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}

arr[guarded: 5]

// MARK: - 可选值map
let characters: [Character] = ["a", "b", "c"]
String(characters[0])

var firstCharAsString: String? = nil
if let char = characters.first {
    firstCharAsString = String(char)
}

let firstChar = characters.first.map({ String($0) })
print(firstChar)

extension Array {
    func reduce(_ initialResult: Element, _ nextPartialResult: (Element, Element) -> Element) -> Element? {
        guard let fst = first else { return nil }
        return dropFirst().reduce(fst, nextPartialResult)
    }
}

// MARK - 可选值flatMap
let stringNumbers1 = ["1", "2", "3", "foo"]
let x = stringNumbers1.first.map({ Int($0) })
type(of: x)

let y = stringNumbers1.first.flatMap({ Int($0) })
type(of: y)

extension Optional {
    func flatMap<U>(transform: (Wrapped) -> U?) -> U? {
        if let value = self, let transfromed = transform(value) {
            return transfromed
        }
        return nil
    }
}

// MARK: - 使用compactMap过滤nil
let numbers = ["1", "2", "3", "foo"]
var sum = 0
for case let i? in numbers.map({ Int($0) }) {
    sum += i;
}
print(sum)

let sum1 =
numbers.map({ Int($0) }).reduce(0, { $0 + ($1 ?? 0) })
print(sum1)

let sum2 = numbers.compactMap({ Int($0) }).reduce(0, +)

// MARK: - 可选值判等
let regex = "^Hello$"
if regex.first == "^" {
    print("start with ^")
}

extension Optional: Equatable where Wrapped: Equatable {
    static func == (lhs: Wrapped?, rhs: Wrapped?) -> Bool {
        switch (lhs, rhs) {
        case (nil, nil):
            return true
        case let (x?, y?):
            return x == y
        case (_?, nil),(nil, _?):
            return false
        }
    }
}

if regex.first == Optional("^") {
    
}

// MARK: - 强制解包时机
let ages = ["Tim" : 53, "Angela" : 34]
ages.keys
.filter({ name in
    ages[name]! < 50
})
.sorted()

ages.filter({ (_, age) in
    age < 50
})
    .map({ (name, _) in
        name
    })
    .sorted()


// MARK: - 改进强制解包错误信息
infix operator !!

func !! <T>(wrapped: T?, failureText: @autoclosure () -> String) -> T {
    if let x = wrapped { return x }
    fatalError(failureText())
}

let s = "foo"
//let i = Int(s) !! "Expecting integer, got \"\(s)\""

