//
//  main.swift
//  汇编分析枚举的内存布局
//
//  Created by WENBO on 2021/7/24.
//

import Foundation

/*
 简单枚举占用一个字节
 */
enum TestEnum {
    case test1, test2, test3
}

enum TestEnum1: Int {
    case test1 = 1, test2 = 2, test3 = 3
}

enum TestEnum2 {
    case test1(Int, Int, Int)
    case test2(Int, Int)
    case test3(Int)
    case test4(Bool)
    case test5
}

enum TestEnum3 {
    case test1(Int)
}

//var t = TestEnum.test1 // 0
//print(Mems.ptr(ofVal: &t))
//t = .test2
//t = .test3
//print(Mems.ptr(ofVal: &t))
//
//print(MemoryLayout<TestEnum>.size)
//print(MemoryLayout<TestEnum>.alignment)
//print(MemoryLayout<TestEnum>.stride)

//var e = TestEnum2.test1(1, 2, 3)
//print(Mems.ptr(ofVal: &e))
//
//print(MemoryLayout<TestEnum2>.size) // 25
//print(MemoryLayout<TestEnum2>.alignment) // 8
//print(MemoryLayout<TestEnum2>.stride) // 32


print(MemoryLayout<TestEnum3>.size) // 8
print(MemoryLayout<TestEnum3>.alignment) // 8
print(MemoryLayout<TestEnum3>.stride) // 8
