//: [Previous](@previous)

import Foundation

var age = 10

//MemoryLayout<Int>.size
//MemoryLayout<Int>.stride
//MemoryLayout<Int>.alignment

MemoryLayout.size(ofValue: age)
MemoryLayout.stride(ofValue: age)
MemoryLayout.alignment(ofValue: age)

enum Password {
    case number(Int, Int, Int, Int) /// 32 关联值
    case other // 1
}

var pwd = Password.number(1, 2, 3, 4);
pwd = .other

MemoryLayout<Password>.size /// 33，实际用到的空间大小
MemoryLayout<Password>.stride /// 40 分配占用空间大小
MemoryLayout<Password>.alignment /// 8 对齐参数

enum Season: Int {
    case spring, summer, autumn, winter
}

MemoryLayout<Season>.size /// 1，实际用到的空间大小
MemoryLayout<Season>.stride /// 1 分配占用空间大小
MemoryLayout<Season>.alignment /// 1 对齐参数

//: [Next](@next)
