import UIKit

enum Result<Value> {
    case value(Value)
    case error(Error)
}

class Promise<Value> {
    private var result: Result<Value>?
    
    init(value: Value? = nil) {
        result = value.map(Result.value)
    }
}
