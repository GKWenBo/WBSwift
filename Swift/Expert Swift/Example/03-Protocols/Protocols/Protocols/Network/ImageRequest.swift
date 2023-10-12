//
//  ImageRequest.swift
//  Protocols
//
//  Created by WENBO on 2022/5/10.
//

import Foundation

struct ImageRequest: Request {
    var url: URL
    
    var method: HTTPMethod { .get }
}
