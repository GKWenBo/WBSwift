import UIKit
/*
 The === operator lets you check if two objects are the same instance. Very useful when verifying that an array contains an instance in a test:
 */
protocol InstanceEquatable: class, Equatable {}

extension InstanceEquatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
}
