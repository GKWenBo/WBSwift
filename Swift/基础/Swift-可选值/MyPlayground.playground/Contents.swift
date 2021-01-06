import UIKit

var array = ["one", "two", "three"]
let idx = array.firstIndex(of: "four")
//array.remove(at: idx)

/// 写法一
switch array.firstIndex(of: "four") {
case .some(let idx):
    array.remove(at: idx)
case .none:
    break
}

/// 写法二
switch array.firstIndex(of: "four") {
case let idx?:
    array.remove(at: idx)
case nil:
    break
}

/// 写法三
if let idx = array.firstIndex(of: "four") {
    array.remove(at: idx)
}

/// “你也可以在同一个 if 语句中绑定多个值”
let urlString = "https://www.wenbo.com"
if let url = URL(string: urlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
    let view = UIImageView(image: image)
}

if let url = URL(string: urlString), url.pathExtension == "png", let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
    let view = UIImageView(image: image)
}

/// - while let
while let line = readLine() {
    print(line)
}

//“和 if let 一样，你可以在可选绑定后面添加一个布尔值语句”
while let line = readLine(), !line.isEmpty {
    print(line)
}

let arr = [1, 2, 3]
var iterator = arr.makeIterator()
while let i = iterator.next() {
    print(i)
}

for i in 0..<10 where i % 2 == 0 {
    print(i)
}

var iterator2 = (0..<10).makeIterator()
while let i = iterator2.next() {
    guard i % 2 == 0 else {
        continue
    }
    print(i)
}

/// - 双重可选值
let stringNumbers = ["1", "2", "three"]
let maybeints = stringNumbers.map({ Int($0) })
for maybeint in maybeints {
    print(maybeint)
}
