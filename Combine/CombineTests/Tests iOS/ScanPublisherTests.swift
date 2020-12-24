//
//  ScanPublisherTests.swift
//  Tests iOS
//
//  Created by wenbo on 2020/12/24.
//

import XCTest
import Combine

class ScanPublisherTests: XCTestCase {

    func testScanInt() {
        let simplePublisher = PassthroughSubject<Int, Error>()
        
        var outputHolder = 0
        let cancellable = simplePublisher
            .scan(0) { (a, b) -> Int in
                return a + b
            }
            .print(self.debugDescription)
            .sink { (completion) in
                print(".sink() received the completion:", String(describing: completion))
                switch completion {
                case .failure(let anError):
                    print(".sink() received completion error: ", anError)
                    XCTFail("no error should be received")
                    break
                case .finished:
                    break
                }
            } receiveValue: { (receivedValue) in
                print(".sink() received \(receivedValue)")
                outputHolder = receivedValue
            }
        
        simplePublisher.send(1)
        XCTAssertEqual(outputHolder, 1)
        
        
        simplePublisher.send(2)
        XCTAssertEqual(outputHolder, 3)
        
        simplePublisher.send(completion: .finished)
        XCTAssertEqual(outputHolder, 3)
        
        XCTAssertNotNil(cancellable)
    }
    
    func testScanString() {
        let simplePublisher = PassthroughSubject<String, Error>()
        
        var outputHolder: String?
        let cancellable = simplePublisher
            .scan("") { (a, b) -> String in
                return a + b
            }
            .print(self.debugDescription)
            .sink { (completion) in
                print(".sink() received the completion:", String(describing: completion))
                switch completion {
                case .failure(let anError):
                    print(".sink() received completion error: ", anError)
                    XCTFail("no error should be received")
                    break
                case .finished:
                    break
                }
            } receiveValue: { (receivedValue) in
                print(".sink() received \(receivedValue)")
                outputHolder = receivedValue
            }
        
        simplePublisher.send("a")
        XCTAssertEqual(outputHolder, "a")
        
        
        simplePublisher.send("b")
        XCTAssertEqual(outputHolder, "ab")
        
        simplePublisher.send(completion: .finished)
        XCTAssertEqual(outputHolder, "ab")
        
        XCTAssertNotNil(cancellable)
    }
    
    func testScanCounter() {
        let simplePublisher = PassthroughSubject<String, Error>()
        
        var outputHolder: Int?
        let cancellable = simplePublisher
            .scan(0) { (a, b) -> Int in
                return a + b.count
            }
            .print(self.debugDescription)
            .sink { (completion) in
                print(".sink() received the completion:", String(describing: completion))
                switch completion {
                case .failure(let anError):
                    print(".sink() received completion error: ", anError)
                    XCTFail("no error should be received")
                    break
                case .finished:
                    break
                }
            } receiveValue: { (receivedValue) in
                print(".sink() received \(receivedValue)")
                outputHolder = receivedValue
            }
        
        simplePublisher.send("a")
        XCTAssertEqual(outputHolder, 1)
        
        
        simplePublisher.send("b")
        XCTAssertEqual(outputHolder, 2)
        
        simplePublisher.send("c")
        XCTAssertEqual(outputHolder, 3)
        
        simplePublisher.send(completion: .finished)
        XCTAssertEqual(outputHolder, 3)
        
        XCTAssertNotNil(cancellable)
    }
    
    func testTryScanString() {
        enum TestFailure: Error {
            case boom
        }
        
        let simplePublisher = PassthroughSubject<String, Error>()
        
        var outputHolder: String?
        var erroredFromUpdates: Bool = false
        let cancellable = simplePublisher
            .tryScan("") { (preVal, newValueFromPublisher) -> String in
                if preVal == "ab" {
                    throw TestFailure.boom
                }
                return preVal + newValueFromPublisher
            }
            .print(self.debugDescription)
            .sink { (completeion) in
                switch completeion {
                case .failure(let anError):
                    print(".sink() received completion error: ", anError)
                    erroredFromUpdates = true
                    break
                case .finished:
                    XCTFail()
                    break
                }
            } receiveValue: { (receivedValue) in
                print(".sink() received \(receivedValue)")
                               outputHolder = receivedValue
            }

        simplePublisher.send("a")
        XCTAssertEqual(outputHolder, "a")
        XCTAssertFalse(erroredFromUpdates)
        
        simplePublisher.send("b")
        XCTAssertEqual(outputHolder, "ab")
        XCTAssertFalse(erroredFromUpdates)
        
        simplePublisher.send("c")
        XCTAssertEqual(outputHolder, "ab")
        XCTAssertTrue(erroredFromUpdates)
        
        simplePublisher.send(completion: .finished)
        XCTAssertEqual(outputHolder, "ab")
        XCTAssertNotNil(cancellable)
    }
}
