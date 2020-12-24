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
    
    func testNotificationCenterPublisherWithRefObject() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        let refInstance = ExampleClass()
        refInstance.aProperty = "hello"
        
        let cancellable = NotificationCenter.default.publisher(for: .myExampleNontificaton, object: refInstance)
            .sink { receivedNotification in
                print("passed through: ", receivedNotification)
                XCTAssertNil(receivedNotification.userInfo)
                XCTAssertNotNil(receivedNotification.object)
                XCTAssertEqual(receivedNotification.description, "name = an-example-notification, object = Optional(UsingCombineTests.ExampleClass), userInfo = nil")
                expectation.fulfill()
            }
        
        NotificationCenter.default.post(name: .myExampleNontificaton, object: refInstance)
        XCTAssertNotNil(cancellable)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testNotificationCenterPublisherWithValueObject() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        let valInstance = ExampleStruct(aProperty: "hello")
        
        let cancellable = NotificationCenter.default.publisher(for: .myExampleNontificaton, object: nil)
            // can't use the object parameter to filter on a value reference, only class references, but
            // filtering on 'nil' only constrains to notification name, so value objects *can* be passed
            // in the notification itself.
            .sink { receivedNotification in
                print("passed through: ", receivedNotification)
                
                XCTAssertNil(receivedNotification.userInfo)
                XCTAssertNotNil(receivedNotification.object)
                XCTAssertEqual(receivedNotification.description, "name = an-example-notification, object = Optional(UsingCombineTests.ExampleStruct(aProperty: \"hello\")), userInfo = nil")
                expectation.fulfill()
            }
        
        NotificationCenter.default.post(name: .myExampleNontificaton, object: valInstance)
        XCTAssertNotNil(cancellable)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testNotificationCenterPublisherBareNotificationWithUserInfo() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        let myUserInfo = ["foo": "bar"]
        
        let cancellable = NotificationCenter.default.publisher(for: .myExampleNontificaton)
            .sink { receivedNotification in
                print("passed through: ", receivedNotification)
                XCTAssertNotNil(receivedNotification.userInfo)
                guard let localDict = receivedNotification.userInfo as? Dictionary<String, String> else {
                    XCTFail()
                    return
                }
                XCTAssertEqual(myUserInfo, localDict)
                XCTAssertNil(receivedNotification.object)
                XCTAssertEqual(receivedNotification.description, "name = an-example-notification, object = nil, userInfo = Optional([AnyHashable(\"foo\"): \"bar\"])")
                expectation.fulfill()
            }
        
        let note = Notification(name: .myExampleNontificaton, userInfo: myUserInfo)
        NotificationCenter.default.post(note)
        
        XCTAssertNotNil(cancellable)
        wait(for: [expectation], timeout: 5.0)
    }
}
