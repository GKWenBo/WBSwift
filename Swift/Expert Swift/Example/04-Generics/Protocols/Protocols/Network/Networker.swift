//
//  Networker.swift
//  Protocols
//
//  Created by WENBO on 2022/5/10.
//

import Foundation
import Combine
import SwiftUI

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
    func fetch<R: Request>(_ request: R) -> AnyPublisher<R.Output, Error>
    func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, Error>
    func fetchWithCache<R: Request>(_ request: R) -> AnyPublisher<R.Output, Error> where R.Output == UIImage
}

class Networker: Networking {
    weak var delegate: NetworkDelegate?
    private let imageCache = RequestCache<UIImage>()
    
    func fetchWithCache<R>(_ request: R) -> AnyPublisher<R.Output, Error> where R : Request, R.Output == UIImage {
        if let response = imageCache.response(for: request) {
            return Just<R.Output>(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        // swiftlint:disable:next trailing_closure
        return fetch(request)
          .handleEvents(receiveOutput: {
            self.imageCache.saveResponse($0, for: request)
          })
          .eraseToAnyPublisher()
    }
    
    func fetch<T>(url: URL) -> AnyPublisher<T, Error> where T : Decodable {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetch<R: Request>(_ request: R) -> AnyPublisher<R.Output, Error> {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = delegate?.headers(for: self)
        
        var publiser = URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .compactMap({ $0.data })
            .eraseToAnyPublisher()
        
        if let delegate = delegate {
            publiser = delegate.networkging(self, transformPublisher: publiser)
        }
        
        return publiser
            .tryMap(request.decode(_:))
            .eraseToAnyPublisher()
    }
}
