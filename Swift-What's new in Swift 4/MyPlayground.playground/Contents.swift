import UIKit

//更智能安全的Key Value Coding
class Foo: NSObject {
    var bar = "bar"
    var barz = [1, 2, 3]
}

var foo = Foo()
//print(foo.bar)
//foo.bar = "BAR"
//
//var bar = foo.value(forKeyPath: #keyPath(Foo.bar))
//foo.setValue("BAR", forKeyPath: #keyPath(Foo.bar))

let barKeyPath = \Foo.bar
var bar1 = foo[keyPath: barKeyPath]
foo[keyPath: barKeyPath] = "BAR"
//foo[KeyPath: \Foo.barz[1]]



//Dictionary初始化以及常用操作的诸多改进
let numberSet = Set(1...100)
let evets = numberSet.lazy.filter({
    $0 % 2 == 0
})

type(of: evets)

let evetnSet = Set(numberSet)

evetnSet.isSubset(of: numberSet)

let numberDictionary =
    ["one": 1, "two": 2, "three": 3, "four": 4]
let evenColl = numberDictionary.lazy.filter({
    $0.1 % 2 == 0
})

let evenDictionary = Dictionary(uniqueKeysWithValues:
    evenColl.map { (key: $0.0, value: $0.1) })

let numbers = ["ONE", "TWO", "THREE"]
var numbersDict = Dictionary(uniqueKeysWithValues:
    numbers.enumerated().map { ($0.0 + 1, $0.1) })




