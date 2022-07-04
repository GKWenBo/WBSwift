//
//  URLSessionDecodable.swift
//  Protocols
//
//  Created by WENBO on 2022/5/10.
//

import Foundation

protocol URLSessionDecodable {
    init(from output: Data) throws
}
