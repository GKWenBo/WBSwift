import UIKit

//全局函数的匹配顺序
func mod(_ m : Double, by n: Double) -> Double {
    print("Double ver.")
    return m.truncatingRemainder(dividingBy: n)
}

func mod(_ m: Float, by n: Float) ->Float {
    print("Float ver.")
    return m.truncatingRemainder(dividingBy: n)
}

func mod<T: Integer>(_ m: T, by n: T) -> T {
    print("Generic ver.")
    return m % n
}

