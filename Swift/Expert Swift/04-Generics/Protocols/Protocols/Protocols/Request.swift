//
//  Request.swift
//  Protocols
//
//  Created by WENBO on 2022/5/10.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol Request {
    associatedtype Output
    
    var url: URL { get }
    var method: HTTPMethod { get }
    
    func decode(_ data: Data) throws -> Output
}

extension Request where Output: Decodable {
    func decode(_ data: Data) throws -> Output {
        let decoder = JSONDecoder()
        return try decoder.decode(Output.self, from: data);
    }
}

struct AnyRequest: Hashable {
    let url: URL
    let method: HTTPMethod
}
