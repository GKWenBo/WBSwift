//
//  Codable+Ex.swift
//  CodablePropertyWrapper
//
//  Created by wenbo22 on 2024/7/16.
//

import Foundation

protocol DefaultValue {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

@propertyWrapper
struct Default<T: DefaultValue> {
    var wrappedValue: T.Value
}


extension Default: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: Default<T>.Type, forKey key: Key) throws -> Default<T> where T: DefaultValue {
        // 判断 key 缺失的情况，提供默认值
        (try decodeIfPresent(type, forKey: key)) ?? Default(wrappedValue: T.defaultValue)
    }
}

extension String {
    struct Unknown: DefaultValue {
        static var defaultValue = "unknown"
    }
    struct Unnamed: DefaultValue {
        static var defaultValue = "unnamed"
    }
}
