import UIKit

MemoryLayout<Int>.size
MemoryLayout<Int>.alignment
MemoryLayout<Int>.stride

MemoryLayout<Int16>.size
MemoryLayout<Int16>.alignment
MemoryLayout<Int16>.stride

MemoryLayout<Bool>.size
MemoryLayout<Bool>.alignment
MemoryLayout<Bool>.stride

MemoryLayout<Float>.size
MemoryLayout<Float>.alignment
MemoryLayout<Float>.stride

MemoryLayout<Double>.size
MemoryLayout<Double>.alignment
MemoryLayout<Double>.stride

MemoryLayout<String>.size
MemoryLayout<String>.alignment
MemoryLayout<String>.stride

let zero = 0.0
MemoryLayout.size(ofValue: zero)

struct IntBoolStruct {
    var intValue: Int
    var boolValue: Bool
}


MemoryLayout<IntBoolStruct>.size
MemoryLayout<IntBoolStruct>.alignment
MemoryLayout<IntBoolStruct>.stride


struct IntBoolStruct1 {
    var boolValue: Bool
    var intValue: Int
}


MemoryLayout<IntBoolStruct1>.size
MemoryLayout<IntBoolStruct1>.alignment
MemoryLayout<IntBoolStruct1>.stride

struct EmptyStruct {
    
}

MemoryLayout<EmptyStruct>.size
MemoryLayout<EmptyStruct>.alignment
MemoryLayout<EmptyStruct>.stride

// MARK: - 引用类型
class IntBoolClass {
  var intValue: Int = 0
  var boolValue: Bool = false
}

MemoryLayout<IntBoolClass>.size       // returns 8
MemoryLayout<IntBoolClass>.alignment  // returns 8
MemoryLayout<IntBoolClass>.stride     // returns 8

class BoolIntClass {
  var boolValue: Bool = false
  var intValue: Int = 0
}

MemoryLayout<BoolIntClass>.size       // returns 8
MemoryLayout<BoolIntClass>.alignment  // returns 8
MemoryLayout<BoolIntClass>.stride     // returns 8

class EmptyClass {}

MemoryLayout<EmptyClass>.size       // returns 8
MemoryLayout<EmptyClass>.alignment  // returns 8
MemoryLayout<EmptyClass>.stride     // returns 8

// MARK: - Raw pointers
var int16Value: UInt16 = 0x1122
MemoryLayout.size(ofValue: int16Value)
MemoryLayout.stride(ofValue: int16Value)
MemoryLayout.alignment(ofValue: int16Value)

let int16bytesPoint = UnsafeMutableRawPointer.allocate(byteCount: 2, alignment: 2)
defer {
    int16bytesPoint.deallocate()
}

int16bytesPoint.storeBytes(of: 0x1122, as: Int16.self)

let fisrtByte = int16bytesPoint.load(as: Int8.self)

let offsetPointer = int16bytesPoint + 1
let secondByte = offsetPointer.load(as: UInt8.self)

// MARK: - Unsafety of raw pointers
let offsetPointer2 = int16bytesPoint + 2
let thirdByte = offsetPointer2.load(as: Int8.self)

// this is a more dangerous operation
offsetPointer2.storeBytes(of: 0x3344, as: UInt16.self)

// Swift/UnsafeRawPointer.swift:900: Fatal error: load from misaligned raw pointer
//let misalignedUInt16 = offsetPointer.load(as: UInt16.self)

// MARK: - Raw buffer pointers
let size = MemoryLayout<UInt>.size
let alignment = MemoryLayout<UInt>.alignment

let bytesPointer = UnsafeMutableRawPointer.allocate(byteCount: size, alignment: alignment)

defer {
    bytesPointer.deallocate()
}

bytesPointer.storeBytes(of: 0x0102030405060708, as: UInt.self)

let bufferPointer = UnsafeRawBufferPointer(start: bytesPointer, count: 8)
for (offset, byte) in bufferPointer.enumerated() {
    print("byte \(offset): \(byte)")
}

// MARK: - Typed pointers
let count = 4
let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
pointer.initialize(repeating: 0, count: count)
defer {
    pointer.deinitialize(count: count)
    pointer.deallocate()
}

// 3
pointer.pointee = 10001
pointer.advanced(by: 1).pointee = 10002
(pointer + 2).pointee = 10003
pointer.advanced(by: 3).pointee = 10004

let bufferPointer1 = UnsafeBufferPointer(start: pointer, count: count)
for (offset, value) in bufferPointer1.enumerated() {
    print("value \(offset): \(value)")
}


// MARK: - Unsafe operations
//var safeString: String? = nil
//print(safeString!)

//var safeString: String? = nil
//print(safeString.unsafelyUnwrapped)

//UInt8.max + 1

UInt8.max &+ 1 // 0

Int8.max &+ 1 // -128
Int8.max &* 1 // 127

Int8.min &- 1 // 127
