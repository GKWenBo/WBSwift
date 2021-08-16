//
//  main.swift
//  汇编分析结构体、类的内存布局
//
//  Created by WENBO on 2021/7/24.
//

import Foundation

func testStruct() {
    struct Point {
        var x: Int
        var y: Int
        var z: Bool
    }
    
    _ = Point(x: 11, y: 22, z: false)
    
    print(MemoryLayout<Point>.size)
    print(MemoryLayout<Point>.stride)
    print(MemoryLayout<Point>.alignment)
}
//testStruct()


func testClassAndStruct() {
    class Size {
        var width = 10
        var height = 10
    }
    
    struct Point {
        var x: Int
        var y: Int
        var z: Bool
    }
    
    print(MemoryLayout<Point>.size) // 17
    print(MemoryLayout<Point>.stride) // 24
    print(MemoryLayout<Point>.alignment) // 8
        
    print(MemoryLayout<Size>.size) // 8
    print(MemoryLayout<Size>.stride) // 8
    print(MemoryLayout<Size>.alignment) // 8
}
testClassAndStruct()
