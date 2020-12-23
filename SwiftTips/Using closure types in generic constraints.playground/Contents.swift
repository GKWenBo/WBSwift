import UIKit

/*
 You can use closure types in generic constraints in Swift. Enables nice APIs for handling sequences of closures.
 */

extension Sequence where Element == () -> Void {
    func callAll() {
        forEach { $0() }
    }
}

extension Sequence where Element == () -> String {
    func joinedResults(separator: String) -> String {
        return map { $0() }.joined(separator: separator)
    }
}

//callbacks.callAll()
//let names = nameProviders.joinedResults(separator: ", ")
