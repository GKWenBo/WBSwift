//
//  RequestCache.swift
//  Protocols
//
//  Created by WENBO on 2022/5/12.
//

import Foundation

class RequestCache<Value> {
    private var store: [AnyRequest: Value] = [:]
    
    func response<R: Request>(for request: R) -> Value? where R.Output == Value {
        let eraseRequest = AnyRequest(url: request.url, method: request.method)
        return store[eraseRequest]
    }
    
    func saveResponse<R: Request>(_ response: Value, for request: R) {
        let eraseRequest = AnyRequest(url: request.url, method: request.method)
        store[eraseRequest] = response
    }
}
