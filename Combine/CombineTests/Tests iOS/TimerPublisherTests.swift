//
//  TimerPublisherTests.swift
//  Tests iOS
//
//  Created by wenbo on 2020/12/24.
//

import UIKit
import XCTest

class TimerPublisherTests: XCTestCase {

    func testTimerPublisherWithAutoconnect() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        let q = DispatchQueue(label: self.debugDescription)
        var countOfReceivedEvents = 0
        
        let cancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { (receivedTimeStamp) in
                // type is Date
                print("passed through: ", receivedTimeStamp)
                XCTAssertNotNil(receivedTimeStamp)
                countOfReceivedEvents += 1
            }
        
        q.asyncAfter(deadline: .now() + 3.4) {
            expectation.fulfill()
        }
        
        XCTAssertNotNil(cancellable)
        wait(for: [expectation], timeout: 5)
                XCTAssertEqual(countOfReceivedEvents, 3)
    }
    
    func testTimerPublisherWithConnect() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        let q = DispatchQueue(label: self.debugDescription)
        var countOfReceivedEvents = 0
        
        let timerPublisher = Timer.publish(every: 1.0, on: .main, in: .common)
        
        let cancellable = timerPublisher
            .sink { (receivedTimeStamp) in
                // type is Date
                print("passed through: ", receivedTimeStamp)
                XCTAssertNotNil(receivedTimeStamp)
                countOfReceivedEvents += 1
            }
        
        q.asyncAfter(deadline: .now() + 1) {
            let connectCancellable = timerPublisher.connect()
            XCTAssertNotNil(connectCancellable)
        }
        
        q.asyncAfter(deadline: .now() + 3.4) {
            expectation.fulfill()
        }
        
        XCTAssertNotNil(cancellable)
        wait(for: [expectation], timeout: 5)
                XCTAssertEqual(countOfReceivedEvents, 2)
    }
}
