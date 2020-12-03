//
//  TestingAndDebuggingTests.swift
//  TestingAndDebuggingTests
//
//  Created by wenbo on 2020/12/3.
//

import XCTest
import Combine
@testable import TestingAndDebugging

class TestingAndDebuggingTests: XCTestCase {
    
    private final class KVOAbleNSObject: NSObject {
        @objc dynamic var intValue: Int = 0
        @objc dynamic var boolValue: Bool = false
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    let testURL = "http://appblue.huibo.com/?apiname=my_cashlist&channel=ios&debugmode=&device_token=91840735cf6906bf90924f687895ab4839153583f950be18ea55a709d7695bbd&ios_local_ver=17&isDebug=true&mobilesys=ios&time=1606972594&token=&ver=v2.6.2"
    
    /// DataTaskPublisher
    /// - Throws: description
    func testDataTaskPublisher() throws {
        let expectation = XCTestExpectation(description: "Download from \(String(testURL))")
        let remoteDataPubliser = URLSession.shared.dataTaskPublisher(for: URL(string: testURL)!)
            .sink { (fini) in
                switch fini {
                case .finished: expectation.fulfill()
                case .failure: XCTFail()
                }
            }
            receiveValue: { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    XCTFail()
                    return
                }
                
                XCTAssertNotNil(data)
                XCTAssertNotNil(response)
                XCTAssertEqual(httpResponse.statusCode, 200)
            }

        XCTAssertNotNil(remoteDataPubliser)
        wait(for: [expectation], timeout: 5)
    }
    
    func testSinkReceiveDataThenError() {

        // setup - preconditions
        let expectedValues = ["firstStringValue", "secondStringValue"]
        enum TestFailureCondition: Error {
            case anErrorExample
        }
        var countValuesReceived = 0
        var countCompletionsReceived = 0

        // setup
        let simplePublisher = PassthroughSubject<String, Error>()

        let _ = simplePublisher
            .sink(receiveCompletion: { completion in
                countCompletionsReceived += 1
                switch completion {
                case .finished:
                    print(".sink() received the completion:", String(describing: completion))
                    // no associated data, but you can react to knowing the
                    // request has been completed
                    XCTFail("We should never receive the completion, the error should happen first")
                    break
                case .failure(let anError):
                    // do what you want with the error details, presenting,
                    // logging, or hiding as appropriate
                    print("received the error: ", anError)
                    XCTAssertEqual(anError.localizedDescription,
                                   TestFailureCondition.anErrorExample.localizedDescription)
                    break
                }
            }, receiveValue: { someValue in
                // do what you want with the resulting value passed down
                // be aware that depending on the data type being returned,
                // you may get this closure invoked multiple times.
                XCTAssertNotNil(someValue)
                XCTAssertTrue(expectedValues.contains(someValue))
                countValuesReceived += 1
                print(".sink() received \(someValue)")
            })

        // validate
        XCTAssertEqual(countValuesReceived, 0)
        XCTAssertEqual(countCompletionsReceived, 0)

        simplePublisher.send("firstStringValue")
        XCTAssertEqual(countValuesReceived, 1)
        XCTAssertEqual(countCompletionsReceived, 0)

        simplePublisher.send("secondStringValue")
        XCTAssertEqual(countValuesReceived, 2)
        XCTAssertEqual(countCompletionsReceived, 0)

        simplePublisher.send(completion: Subscribers.Completion.failure(TestFailureCondition.anErrorExample))
        XCTAssertEqual(countValuesReceived, 2)
        XCTAssertEqual(countCompletionsReceived, 1)

        // this data will never be seen by anything in the pipeline above because
        // we have already sent a completion
        simplePublisher.send(completion: Subscribers.Completion.finished)
        XCTAssertEqual(countValuesReceived, 2)
        XCTAssertEqual(countCompletionsReceived, 1)
    }
    
    func testKVOPublisher() {
        let expectaion = XCTestExpectation(description: "testKVOPublisher")
        let foo = KVOAbleNSObject()
        let q = DispatchQueue(label: "testKVOPublisher")
        
        let _ = foo.publisher(for: \.intValue)
            .print()
            .sink { (someValue) in
                print("value of intValue updated to: >>\(someValue)<<")
            }
        
        q.asyncAfter(deadline: .now() + 0.5) {
            print("Updating to foo.intValue on background queue")
            foo.intValue = 5
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 5.0)
        
    }

}
