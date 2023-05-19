//: [Previous](@previous)

import Foundation

//let initial = Date()
//
//Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
//    let now = Date()
//    print("Value:\(now)")
//    let diff = now.timeIntervalSince(initial)
//    if diff > 10 {
//        t.invalidate()
//    }
//}

var timerStream: AsyncStream<Date> {
    AsyncStream<Date> { continuation in
        let initial = Date()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            let now = Date()
            print("Call yield")
            continuation.yield(Date())
            let diff = now.timeIntervalSince(initial)
            if diff > 10 {
                print("Call finish")
                continuation.finish()
                t.invalidate()
            }
        }
        
        continuation.onTermination = { @Sendable state in
            print("onTermination:\(state)")
        }
    }
}
let t = Task {
    let timer = timerStream
    for await v in timer {
        print(v)
    }
}

//: [Next](@next)
