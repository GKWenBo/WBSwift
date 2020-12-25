//
//  FilteringOperatorTests.swift
//  Tests iOS
//
//  Created by wenbo on 2020/12/25.
//

import UIKit
import XCTest
import Combine

class FilteringOperatorTests: XCTestCase {
    
    enum TestExampleError: Error {
        case example
    }
    
    func testReplaceNil() {
        let passSubj = PassthroughSubject<String?, Never>()
        
        var receiveList: [String] = []
        
        let cancellable = passSubj
            .print(self.debugDescription)
            .replaceNil(with: "-replacement-")
            .sink { (someValue) in
                print("value updated to: ", someValue)
                receiveList.append(someValue)
            }
        
        passSubj.send("one")
        passSubj.send(nil)
        passSubj.send("")
        passSubj.send(nil)
        passSubj.send("five")
        passSubj.send(completion: .finished)
        XCTAssertEqual(receiveList, ["one", "-replacement-", "", "-replacement-", "five"])
        XCTAssertNotNil(cancellable)
    }
    
    func testReplaceEmptyWithValues() {
        let passSubj = PassthroughSubject<String?, Never>()
        
        var receiveList: [String?] = []
        
        let cancellable = passSubj
            .print(self.debugDescription)
            .replaceEmpty(with: "-replacement-")
            .sink { (someValue) in
                print("value updated to: ", someValue as Any)
                receiveList.append(someValue)
            }
        
        passSubj.send(completion: .finished)
        XCTAssertEqual(receiveList, ["-replacement-"])
        XCTAssertNotNil(cancellable)
    }
    
    func testReplaceEmptyWithFailure() {
        let passSubj = PassthroughSubject<String, Error>()
        // no initial value is propagated from a PassthroughSubject
        var receivedList: [String] = []
        
        let cancellable = passSubj
            .print(self.debugDescription)
            .replaceEmpty(with: "-replacement-")
            .sink { (completion) in
                print(".sink() received the completion", String(describing: completion))
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(let anError):
                    print("received error: ", anError)
                }
            } receiveValue: { (responseValue) in
                print(".sink() data received \(responseValue)")
                receivedList.append(responseValue)
                XCTFail()
            }
        
        passSubj.send(completion: .failure(TestExampleError.example))
        
        XCTAssertEqual(receivedList, [])
        XCTAssertNotNil(cancellable)
    }
    
    func testCompactMap() {
        let passSubj = PassthroughSubject<String?, Never>()
        // no initial value is propagated from a PassthroughSubject
        var receivedList: [String] = []
        
        let cancellable = passSubj
            .print(self.debugDescription)
            .compactMap {
                return $0
            }
            .sink { (someValue) in
                print("value updated to: ", someValue as Any)
                receivedList.append(someValue)
            }
        
        passSubj.send("one")
        passSubj.send(nil)
        passSubj.send("")
        passSubj.send(completion: Subscribers.Completion.finished)
        
        XCTAssertEqual(receivedList, ["one", ""])
        XCTAssertNotNil(cancellable)
    }
    
    func testTryCompactMap() {
        let passSubj = PassthroughSubject<String?, Never>()
        // no initial value is propagated from a PassthroughSubject
        var receivedList: [String] = []
        
        let cancellable = passSubj
            .tryCompactMap { (someVal) -> String? in
                if someVal == "boom" {
                    throw TestExampleError.example
                }
                return someVal
            }
            .sink { (completion) in
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(let anError):
                    print("received error: ", anError)
                }
            } receiveValue: { (responseValue) in
                receivedList.append(responseValue)
                print(".sink() data received \(responseValue)")
            }
        
        
        passSubj.send("one")
        passSubj.send(nil)
        passSubj.send("")
        passSubj.send("boom")
        passSubj.send(completion: Subscribers.Completion.finished)
        
        XCTAssertEqual(receivedList, ["one", ""])
        XCTAssertNotNil(cancellable)
    }
}
