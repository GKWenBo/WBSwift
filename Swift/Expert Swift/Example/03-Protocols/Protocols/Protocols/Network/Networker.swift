//
//  Networker.swift
//  Protocols
//
//  Created by WENBO on 2022/5/10.
//

import Foundation
import Combine

protocol NetworkDelegate: AnyObject {
    func headers(for networking: Networking) -> [String : String]
    func networkging(_ networkging: Networking, transformPublisher publisher: AnyPublisher<Data, URLError>) -> AnyPublisher<Data, URLError>
}

extension NetworkDelegate {
    func headers(for networking: Networking) -> [String : String] {
        [:]
    }
    
    func networkging(_ networkging: Networking, transformPublisher publisher: AnyPublisher<Data, URLError>) -> AnyPublisher<Data, URLError> {
        publisher
    }
}

protocol Networking {
    var delegate: NetworkDelegate? { get set }
    func fetch(_ request: Request) -> AnyPublisher<Data, URLError>
}

class Networker: Networking {
    weak var delegate: NetworkDelegate?
    
    func fetch(_ request: Request) -> AnyPublisher<Data, URLError> {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = delegate?.headers(for: self)
        
        let publiser = URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .compactMap({ $0.data })
            .eraseToAnyPublisher()
        
        if let delegate = delegate {
            return delegate.networkging(self, transformPublisher: publiser)
        } else {
            return publiser
        }
    }
}
