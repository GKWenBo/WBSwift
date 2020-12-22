import UIKit

// MARK: - Unwrapping optionals
var name: String? = nil

if let unwrapped = name {
    print("\(unwrapped.count) letters")
} else {
    print("Missing name.")
}

// MARK: - Unwrapping with guard


// MARK: - Force unwrapping
let num = Int("1")!

