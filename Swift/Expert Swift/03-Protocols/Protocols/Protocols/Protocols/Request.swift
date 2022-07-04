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
    var url: URL { get }
    var method: HTTPMethod { get }
}
