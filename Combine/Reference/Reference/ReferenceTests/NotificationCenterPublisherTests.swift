//
//  NotificationCenterPublisherTests.swift
//  ReferenceTests
//
//  Created by wenbo on 2020/12/24.
//

import UIKit
import XCTest

extension Notification.Name {
    static let myExampleNontificaton = Notification.Name("an-example-notification")
}

class ExampleClass {
    var aProperty: String = ""
}

struct ExampleStruct {
    var aProperty: String = ""
}

class NotificationCenterPublisherTests: XCTestCase {

    func testNotificationCenterPublisherBareNotification() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        let cancellable = NotificationCenter.default.publisher(for: .myExampleNontificaton)
            .sink { (receivedNotification) in
                print("passed through: ", receivedNotification)
                XCTAssertNil(receivedNotification.userInfo)
                XCTAssertNil(receivedNotification.object)
                
                XCTAssertEqual(receivedNotification.description, "name = an-example-notification, object = nil, userInfo = nil")
                
                expectation.fulfill()
            }
        
        let note = Notification(name: .myExampleNontificaton)
        NotificationCenter.default.post(note)
        
        XCTAssertNotNil(cancellable)
        wait(for: [expectation], timeout: 5)
        
    }
    
}
