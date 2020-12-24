//
//  EmptyPublisherTests.swift
//  ReferenceTests
//
//  Created by wenbo on 2020/12/3.
//

import UIKit
import XCTest
import Combine

class EmptyPublisherTests: XCTestCase {
    
    func testEmptyPulisher() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        let cancellable = Empty<String, Never>()
        
        _ = cancellable.sink { (completion) in
            switch completion {
            case .finished: expectation.fulfill()
            case .failure: XCTFail()
            }
        }
        receiveValue: { (value) in
            XCTFail()
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(cancellable)
    }
    
}
