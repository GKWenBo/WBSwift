//
//  DeferredPublisherTests.swift
//  ReferenceTests
//
//  Created by wenbo on 2020/12/3.
//

import XCTest
import Combine

class DeferredPublisherTests: XCTestCase {
    enum TestFailureCondition: Error {
        case anErrorExample
    }
    
    // example of a asynchronous function to be called from within a Future and its completion closure
    func asyncAPICall(sabotage: Bool, completion completionBlock: @escaping ((Bool, Error?) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            let delay = Int.random(in: 1...3)
            print(" * making async call (delay of \(delay) seconds)")
            sleep(UInt32(delay))
            if sabotage {
                completionBlock(false, TestFailureCondition.anErrorExample)
            }
            completionBlock(true, nil)
        }
    }
    
    func testDeferredFuturePublisher() {
        var outputValue = false
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        let defferredPublisher = Deferred {
            return Future<Bool, Error> { promise in
                self.asyncAPICall(sabotage: false) { (grantedAccess, error) in
                    if let error = error {
                        return promise(.failure(error))
                    }
                    return promise(.success(grantedAccess))
                }
            }
        }.eraseToAnyPublisher()
        
        let cancellable = defferredPublisher.sink { (error) in
            expectation.fulfill()
        }
        receiveValue: { (value) in
            outputValue = value
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertTrue(outputValue)
        XCTAssertNotNil(cancellable)
    }
    
    func testDeferredPublisher() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        let deferredPublisher = Deferred {
            return Just("hello")
        }
        .eraseToAnyPublisher()
        
        let cancellable = deferredPublisher
            .sink { (completion) in
                switch completion {
                case .finished: break
                case .failure(let anError):
                    XCTFail()
                    print("received error: ", anError)
                }
                expectation.fulfill()
            }
            receiveValue: { (value) in
                XCTAssertLessThanOrEqual(value, "hello")
            }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(cancellable)
    }
}
