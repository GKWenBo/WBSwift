//
//  ChangingErrorTests.swift
//  Tests iOS
//
//  Created by wenbo on 2020/12/25.
//

import UIKit
import Combine
import XCTest

class ChangingErrorTests: XCTestCase {
    
    enum TestExampleError: Error {
        case example
    }
    
    enum APIError: Error, LocalizedError {
        case unknown, apiError(reason: String), parserError(reason: String), networkError(from: URLError)
        
        var errorDescription: String? {
            switch self {
            case .unknown:
                return "Unknown error"
            case .apiError(let reason), .parserError(let reason):
                return reason
            case .networkError(let from):
                return from.localizedDescription
            }
        }
    }
    
    func fetch(url: URL) -> AnyPublisher<Data, APIError> {
        let request = URLRequest(url: url)
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { (data, response) in
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
            .mapError { error in
                // if it's our kind of error already, we can return it directly
                if let error = error as? APIError {
                    return error
                }
                // if it is a TestExampleError, convert it into our new error type
                if error is TestExampleError {
                    return APIError.parserError(reason: "Our example error")
                }
                // if it is a URLError, we can convert it into our more general error kind
                if let urlerror = error as? URLError {
                    return APIError.networkError(from: urlerror)
                }
                // if all else fails, return the unknown error condition
                return APIError.unknown
            }
            .eraseToAnyPublisher()
    }
    
    func testMapError() {
        let expectaion = XCTestExpectation(description: self.debugDescription)
        
        let publisher = Fail<String, TestExampleError>(error: TestExampleError.example)
        
        let cancellable = publisher
            .mapError { (error) -> APIError in
                if let error = error as? APIError {
                    return error
                }
                
                if let urlerror = error as? URLError {
                    return APIError.networkError(from: urlerror)
                }
                return APIError.unknown
            }
            .sink { (completion) in
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(let anError):
                    print("received error: ", anError)
                    if !(anError is APIError) {
                        // fail if this is anything BUT an APIError
                        XCTFail()
                    }
                }
                expectaion.fulfill()
            } receiveValue: { (responseValue) in
                print(".sink() data received \(responseValue)")
                XCTFail()
            }
        
        wait(for: [expectaion], timeout: 3.0)
        XCTAssertNotNil(cancellable)
    }
    
    func testReplaceError() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        let publisher = Fail<String, ChangingErrorTests.TestExampleError>(error: TestExampleError.example)
        
        let cancellable = publisher
            .replaceError(with: "foo")
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let anError):
                    print("received error: ", anError)
                    XCTFail()
                    break
                }
                expectation.fulfill()
            } receiveValue: { (someValue) in
                print(".sink() data received \(someValue)")
                XCTAssertEqual(someValue, "foo")
            }

        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(cancellable)
        
    }
}
