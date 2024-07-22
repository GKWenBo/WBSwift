//
//  CodablePropertyWrapperTests.swift
//  CodablePropertyWrapperTests
//
//  Created by wenbo22 on 2024/7/16.
//

import XCTest
@testable import CodablePropertyWrapper

final class CodablePropertyWrapperTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testDefault() {
        let json = ["name": "张三", "text1": "aaa"]
        let data = try! JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
        
        do {
            let test = try JSONDecoder().decode(TestStruct.self, from: data)
            XCTAssert(test.name == "张三")
            XCTAssert(test.text == "unknown")
        } catch {
            
        }
    }
}
