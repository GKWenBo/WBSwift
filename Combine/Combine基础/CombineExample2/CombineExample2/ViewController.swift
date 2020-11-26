//
//  ViewController.swift
//  CombineExample2
//
//  Created by wenbo on 2020/11/26.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    enum APIError: Error, LocalizedError {
        case unknown, apiError(reason: String), parserError(reason: String), networkError(from: URLError)
        
        var errorDescription: String? {
            switch self {
            case .unknown:
                return "Unknown"
            case .apiError(let reason), .parserError(let reason):
                return reason
            case .networkError(let from):
                return from.localizedDescription
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        example1()
    }

    // MARK: - Normalizing errors from a dataTaskPublisher
    func example1() {
        fetch(url: URL(string: "test_url")!).sink { result in
            switch result {
            case .failure(let error):
                print(error)
            case .finished:
                print("请求完成")
            }
        } receiveValue: { (data) in
            print(data);
        }
    }
    
    func fetch(url: URL) -> AnyPublisher<Data, APIError> {
        let request = URLRequest.init(url: url)
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown
                }
                if (httpResponse.statusCode == 401) {
                    throw APIError.apiError(reason: "Unauthorized");
                }
                if (httpResponse.statusCode == 403) {
                    throw APIError.apiError(reason: "Resource forbidden");
                }
                if (httpResponse.statusCode == 404) {
                    throw APIError.apiError(reason: "Resource not found");
                }
                if (405..<500 ~= httpResponse.statusCode) {
                    throw APIError.apiError(reason: "client error");
                }
                if (500..<600 ~= httpResponse.statusCode) {
                    throw APIError.apiError(reason: "server error");
                }
                return data
            }
            .mapError({ error in
                // if it's our kind of error already, we can return it directly
                if let error = error as? APIError {
                    return error
                }
                // if it is a TestExampleError, convert it into our new error type
                if error is APIError {
                    return APIError.parserError(reason: "Our example error")
                }
                // if it is a URLError, we can convert it into our more general error kind
                if let urlerror = error as? URLError {
                    return APIError.networkError(from: urlerror)
                }
                // if all else fails, return the unknown error condition
                return APIError.unknown
            })
            .eraseToAnyPublisher()
    }
    
}

