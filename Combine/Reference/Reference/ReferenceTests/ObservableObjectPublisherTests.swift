//
//  ObservableObjectPublisherTests.swift
//  ReferenceTests
//
//  Created by WENBO on 2020/12/3.
//

import XCTest
import Combine

class ObservableObjectPublisherTests: XCTestCase {
    
    func testCodeExample() {
        // class
        class Contact: ObservableObject {
            @Published var name: String
            @Published var age: Int
            
            init(name: String, age: Int) {
                self.name = name
                self.age = age
            }
            
            func haveBirthday() -> Int {
                age += 1
                return age
            }
        }
        
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        
        let john = Contact(name: "John", age: 24)
        let cancellable = john.objectWillChange.sink { _ in
            expectation.fulfill()
            print("will change")
        }
        
        print(john.haveBirthday())
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(cancellable)
    }
    
    class ExampleObject: ObservableObject {
        @Published var someProperty: String
        
        init(someProperty: String) {
            self.someProperty = someProperty
        }
        
        func shoutProperty() -> String {
            self.someProperty = self.someProperty.uppercased()
            return self.someProperty
        }
    }
    
    func testObservableObjectPublisher() {
        let expectation = XCTestExpectation(description: self.description)
        
        let example = ExampleObject(someProperty: "quietly, please")
        XCTAssertNotNil(example.objectWillChange)
        
        let cancellable = example.objectWillChange
            .print()
            .sink { (completion) in
                print(".sink() received the completion", String(describing: completion))
                switch completion {
                case .finished:
                    XCTFail()
                    break
                case .failure(let anError):
                    XCTFail()
                    print("received error: ", anError)
                    break
                }
            }
            receiveValue: { (value) in
                XCTAssertNotNil(value)
                expectation.fulfill()
                print(".sink() data received \(value)")
            }

        XCTAssertEqual(example.someProperty, "quietly, please")
        let result = example.shoutProperty()
        
        XCTAssertEqual(result, "QUIETLY, PLEASE")
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(cancellable)
    }
}
