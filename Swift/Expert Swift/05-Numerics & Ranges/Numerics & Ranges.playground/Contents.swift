import UIKit

enum Number: Int, Comparable {
    case zero, one, two, three, four
    
    static func < (lhs: Number, rhs: Number) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

let longForm = Range<Number>(uncheckedBounds: (lower: .one, upper: .three))
let shortForm = Number.one ..< .three

longForm == shortForm

shortForm.contains(.zero) // false
shortForm.contains(.one) // true
shortForm.contains(.two) // true
shortForm.contains(.three) // false


let longFormClosed = ClosedRange<Number>.init(uncheckedBounds: (lower: .one, upper: .three))
let shortFormClosed = Number.one ... .three
longFormClosed == shortFormClosed

shortFormClosed.contains(.zero)
shortFormClosed.contains(.one)
shortFormClosed.contains(.two)
shortFormClosed.contains(.three)

let r1 = ...Number.three
let r2 = ..<Number.three
let r3 = Number.zero...


extension Number: Strideable {
    typealias Stride = Int
    
    func distance(to other: Number) -> Int {
        other.rawValue - rawValue
    }
    
    func advanced(by n: Int) -> Number {
        Number(rawValue: rawValue + n)!
    }
}


for i in 1..<3 {
    print(i)
}

for i in Number.one ..< .three {
    print(i)
}


for i in (Number.one ..< .three).reversed() {
    print(i)
}

for i in stride(from: Number.two, to: .zero, by: -1) {
    print(i)
}

for i in stride(from: Number.two, through: .one, by: -1) {
    print(i)
}

func find<R: RangeExpression>(value: R.Bound, in range: R) -> Bool {
    range.contains(value)
}

find(value: Number.one, in: Number.zero ... .two)
find(value: Number.one, in: ...Number.two)
find(value: Number.one, in: ..<Number.three)
