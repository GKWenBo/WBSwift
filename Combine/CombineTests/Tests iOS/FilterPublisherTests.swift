//
//  FilterPublisherTests.swift
//  Tests iOS
//
//  Created by wenbo on 2020/12/25.
//

import UIKit
import XCTest
import Combine

class FilterPublisherTests: XCTestCase {
    
    func testFilter() {
        let simplePublisher = PassthroughSubject<String, Error>()
        
        let cancellable = simplePublisher
            .filter { (stringValue) -> Bool in
                if stringValue == "onefish" {
                    return true
                }
                return false
            }
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let anError):
                    print(".sink() received completion error: ", anError)
                    XCTFail("no error should be received")
                    break
                }
            } receiveValue: { (stringValue) in
                print(".sink() received \(stringValue)")
                XCTAssertEqual(stringValue, "onefish")
            }
        
        
        simplePublisher.send("onefish") // onefish will pass the filter
        simplePublisher.send("twofish") // twofish will not
        simplePublisher.send(completion: Subscribers.Completion.finished)
        XCTAssertNotNil(cancellable)
    }
    
    func testTryFilter() {
        
        enum TestFailure: Error {
            case boom
        }
        
        let simplePublisher = PassthroughSubject<String, Error>()
        
        let cancellable = simplePublisher
            .tryFilter { stringValue in
                if stringValue == "explode" {
                    throw TestFailure.boom
                }
                return stringValue == "onefish"
            }
            .print(self.debugDescription)
            .sink(receiveCompletion: { completion in
                print(".sink() received the completion:", String(describing: completion))
                switch completion {
                case .failure(let anError):
                    print(".sink() received completion error: ", anError)
                    break
                case .finished:
                    XCTFail("test sequence should fail before receiving finished")
                    break
                }
            }, receiveValue: { stringValue in
                print(".sink() received \(stringValue)")
                XCTAssertEqual(stringValue, "onefish")
            })
        
        simplePublisher.send("onefish") // onefish will pass the filter
        simplePublisher.send("twofish") // twofish will not
        simplePublisher.send("explode") // explode will trigger a failure
        simplePublisher.send(completion: Subscribers.Completion.finished)
        XCTAssertNotNil(cancellable)
    }
    
}
