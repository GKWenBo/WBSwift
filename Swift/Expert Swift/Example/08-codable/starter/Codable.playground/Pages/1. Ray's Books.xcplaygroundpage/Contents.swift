//: [Previous](@previous)

import UIKit
import PlaygroundSupport

struct Book: Decodable {
    let id: String
    let name: String
    let authors: [String]
    let storeLink: URL
    let imageBlob: Data
    var image: UIImage? {
        UIImage.init(data: imageBlob)
    }
}

extension JSONDecoder.KeyDecodingStrategy {
    static var convertFromKebabCase: JSONDecoder.KeyDecodingStrategy = .custom { codingPath in
        /// [_JSONKey(stringValue: "Index 0", intValue: 0), _JSONKey(stringValue: "store-link", intValue: nil)] 2

        print(codingPath, codingPath.count)
        let codingKey = codingPath.last!
        let key = codingKey.stringValue
        
        guard key.contains("-") else {
            return codingKey
        }
        
        let words = key.components(separatedBy: "-")
        let camelCased = words[0] + words[1...].map(\.capitalized).joined()
        return AnyCodingKey(stringValue: camelCased)!
    }
}

struct AnyCodingKey: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
    
}

let data = API.getData(for: .rwBooksKebab)
let decoder = JSONDecoder()
// 自定义key解析规则
decoder.keyDecodingStrategy = .convertFromKebabCase
decoder.dataDecodingStrategy = .base64

do {
    let books = try decoder.decode([Book].self, from: data)
    print("—— Example of: Books ——")
    for book in books {
        print("\(book.name) (\(book.id))",
              "by \(book.authors.joined(separator: ", ")).",
              "Get it at: \(book.storeLink)")
        _ = book.image
    }
    
} catch {
    print("Something went wrong \(error)")
}

//: [Next](@next)

/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

