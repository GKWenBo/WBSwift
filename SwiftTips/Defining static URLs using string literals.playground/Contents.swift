import UIKit

/*
 Tired of using URL(string: "url")! for static URLs? Make URL conform to ExpressibleByStringLiteral and you can now simply use "url" instead.
 */

extension URL: ExpressibleByStringLiteral {
    
    // By using 'StaticString' we disable string interpolation, for safety
        public init(stringLiteral value: StaticString) {
            self = URL(string: "\(value)")!
        }
}


// We can now define URLs using static string literals 🎉
let url: URL = "https://www.swiftbysundell.com"
let task = URLSession.shared.dataTask(with: "https://www.swiftbysundell.com")
