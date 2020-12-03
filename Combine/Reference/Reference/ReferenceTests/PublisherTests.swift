//
//  PublisherTests.swift
//  ReferenceTests
//
//  Created by WENBO on 2020/12/3.
//

import XCTest

class PublisherTests: XCTestCase {
    
    class HoldingClass {
        @Published var username: String = ""
    }
    
    enum FailureCondition: Error {
        case selfDestruct
    }
    
    private final class KVOAbleNSObject: NSObject {
        @objc dynamic var intValue: Int = 0
        @objc dynamic var boolValue: Bool = false
    }
    
    func testPublisheOnClassInstance() {
        let expectation = XCTestExpectation(description: "async sink test")
        
        let foo = HoldingClass()
        
        let cancellable = foo.$username
            .sink { (someValue) in
                print("value of username updated to: >>\(someValue)<<")
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(cancellable)
    }
    
    func testPublishedOnClassWithChange() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        let foo = HoldingClass()
        
        let q = DispatchQueue(label: self.debugDescription)
        
        let cancellable = foo.$username
            .sink {
                print("value of username updated to: >>\($0)<<")
                if $0 == "redfish" {
                    expectation.fulfill()
                }
            }
        
        q.async {
            print("Updating to redfish on background queue")
            foo.username = "redfish"
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(cancellable)
    }
    
    func testPublishedOnClassWithTwoSubscribers() {
        let expection = XCTestExpectation(description: self.debugDescription)
        
        let foo = HoldingClass()
        let q = DispatchQueue(label: self.debugDescription)
        
        var coutOfHits = 0
        
        let cancellable1 = foo.$username
            .print("1111")
            .sink { (value) in
                print("first subscriber: value of username updated to: ", value)
                if value == "redfish" {
                    coutOfHits += 1
                }
            }
        
        let cancellable2 = foo.$username
            .print("2222")
            .sink { (value) in
                print("second subscriber: value of username updated to: ", value)
                if value == "bluefish" {
                    coutOfHits += 1
                    expection.fulfill()
                }
            }
        
        q.async {
            print("Updating to redfish on background queue")
            foo.username = "redfish"
        }
        
        q.asyncAfter(deadline: .now() + 0.5) {
            print("Updating to bluefish on background queue")
            foo.username = "bluefish"
        }
        
        wait(for: [expection], timeout: 5.0)
        
        XCTAssertEqual(coutOfHits, 2)
        XCTAssertNotNil(cancellable1)
        XCTAssertNotNil(cancellable2)
    }
    
    func testPublishedSinkWithError() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        let foo = HoldingClass()
        let q = DispatchQueue(label: self.debugDescription)
        
        let cancellable = foo.$username
            .print(self.debugDescription)
            .tryMap({ myValue -> String in
                if (myValue == "boom") {
                    throw FailureCondition.selfDestruct
                }
                return "mappedValue"
            })
            .sink(receiveCompletion: { completion in
                print(".sink() received the completion", String(describing: completion))
                switch completion {
                case .finished:
                    break
                case .failure(let anError):
                    print("received error: ", anError)
                    break
                }
            }, receiveValue: { postmanResponse in
                XCTAssertNotNil(postmanResponse)
                print(".sink() data received \(postmanResponse)")
            })
        
        q.async {
            print("Updating to redfish on background queue")
            foo.username = "redfish"
        }
        q.asyncAfter(deadline: .now() + 0.5, execute: {
            print("Updating to boom on background queue")
            foo.username = "boom"
        })
        // since the "boom" value will cause the error to be thrown with the
        // tryMap in the pipeline attached to the sink, the sink will send a
        // cancel message (visible in the test output for this test due to
        // the .print() operator), and no further changes will be published.
        q.asyncAfter(deadline: .now() + 1, execute: {
            print("Updating to bluefish on background queue")
            foo.username = "bluefish"
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(foo.username, "bluefish")
        XCTAssertNotNil(cancellable)
    }
    
    func testKVOPublisher() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        let foo = KVOAbleNSObject()
        let q = DispatchQueue(label: self.debugDescription)
        
        let cancellable = foo.publisher(for: \.intValue)
            .print()
            .sink { someValue in
                print("value of intValue updated to: >>\(someValue)<<")
            }
        
        q.asyncAfter(deadline: .now() + 0.5, execute: {
            print("Updating to foo.intValue on background queue")
            foo.intValue = 5
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(cancellable)
    }
}
