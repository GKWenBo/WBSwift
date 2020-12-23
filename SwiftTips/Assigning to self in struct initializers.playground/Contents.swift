import UIKit

/*
 It's so nice that you can assign directly to self in struct initializers in Swift. Very useful when adding conformance to protocols.
 */

protocol AnswerConvertible {}

extension Bool: AnswerConvertible {
    public init(input: String) throws {
        switch input.lowercased() {
        case "y", "yes", "👍":
            self = true
        default:
            self = false
        }
    }
}
