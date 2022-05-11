//
//  ArticleRequest.swift
//  Protocols
//
//  Created by WENBO on 2022/5/10.
//

import Foundation

struct ArticleRequest: Request {
    var url: URL {
        let baseURL = "https://api.raywenderlich.com/api"
        let path = "/contents?filter[content_types][]=article"
        return URL(string: baseURL + path)!
    }
    
    var method: HTTPMethod {
        return .get
    }
}
