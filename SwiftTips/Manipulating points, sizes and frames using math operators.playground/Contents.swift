import UIKit

/*
 I'm always careful with operator overloading, but for manipulating things like sizes, points & frames I find them super useful.
 */

extension CGSize {
    static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}

let button = UIButton()
button.frame.size = button.frame.size * 2

