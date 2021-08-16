//: [Previous](@previous)

import Foundation

let age = 10
var num = 20

//: # 元组
let error = (404, "Not Found")
error.0
error.1

let (statusCode, statusMessage) = error
print(statusCode)


//: [Next](@next)
