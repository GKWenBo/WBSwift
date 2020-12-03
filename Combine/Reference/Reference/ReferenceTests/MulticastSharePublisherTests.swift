//
//  MulticastSharePublisherTests.swift
//  ReferenceTests
//
//  Created by wenbo on 2020/12/3.
//

import XCTest
import Combine

class MulticastSharePublisherTests: XCTestCase {
    var sourceValue = 0
    
    func sourceGenerator() -> Int {
        sourceValue += 1
        return sourceValue
    }
    
    enum TestFailureCondition: Error {
        case anErrorExample
    }
    
    // example of a asynchronous function to be called from within a Future and its completion closure
    func asyncAPICall(sabotage: Bool, completion completionBlock: @escaping ((Int, Error?) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            let delay = Int.random(in: 1...3)
            print(" * making async call (delay of \(delay) seconds)")
            sleep(UInt32(delay))
            if sabotage {
                completionBlock(0, TestFailureCondition.anErrorExample)
            }
            completionBlock(self.sourceGenerator(), nil)
        }
    }
    
    func testDeferredFuturePublisher() {
        // setup
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        // the creating the deferred, future publisher
        let pub = Deferred {
            Future<Int, Error> { promise in
                self.asyncAPICall(sabotage: false) { (grantedAccess, err) in
                    if let err = err {
                        promise(.failure(err))
                    } else {
                        promise(.success(grantedAccess))
                    }
                }
            }
        }
        
        // driving it by attaching it to .sink
        let cancellable = pub.sink(receiveCompletion: { completion in
            print(".sink() received the completion: ", String(describing: completion))
            expectation.fulfill()
        }, receiveValue: { value in
            print(".sink() received value: ", value)
            
        })
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(cancellable)
    }
    
    func testSharedDeferredFuturePublisher() {
        let firstCompletion = XCTestExpectation(description: self.debugDescription)
        firstCompletion.expectedFulfillmentCount = 2
        
        let secondCompletion = expectation(description: self.description)
        let secondValue = expectation(description: self.debugDescription)
        secondValue.isInverted = true
        
        let pub = Deferred {
            Future<Int, Error> { promise in
                self.asyncAPICall(sabotage: false) { (grantedAccess, err) in
                    if let err = err {
                        promise(.failure(err))
                    } else {
                        promise(.success(grantedAccess))
                    }
                }
            }
        }.share()
        
        var sinkValues = [Int]()
        
        let otherCancelable = pub.sink { (completion) in
            print(".sink() received the completion: ", String(describing: completion))
            firstCompletion.fulfill()
        }
        receiveValue: { (value) in
            print(".sink() received value: ", value)
            sinkValues.append(value)
        }
        
        let cancellable = pub.sink { (completion) in
            print(".sink() received the completion: ", String(describing: completion))
            firstCompletion.fulfill()
        }
        receiveValue: { (value) in
            print(".sink() received value: ", value)
            sinkValues.append(value)
        }
        
        wait(for: [firstCompletion], timeout: 5.0)
        
        
        let thirdCancellable = pub.sink { (completion) in
            secondCompletion.fulfill()
        }
        receiveValue: { (value) in
            sinkValues.append(value)
            secondValue.fulfill()
        }
        
        wait(for: [secondCompletion, secondValue], timeout: 5.0)
        XCTAssertEqual(sinkValues.count, 2)
        XCTAssertEqual(sinkValues[0], sinkValues[1])
        XCTAssertNotNil(otherCancelable)
        XCTAssertNotNil(cancellable)
        XCTAssertNotNil(thirdCancellable)
    }
    
    func testMulticastDeferredFuturePublisher() {
        let fisrtCompletion = XCTestExpectation(description: self.debugDescription)
        let firstValues = XCTestExpectation(description: self.debugDescription)
        
        fisrtCompletion.expectedFulfillmentCount = 2
        firstValues.expectedFulfillmentCount = 2
        
        let secondCompletion = expectation(description: self.debugDescription)
        let secondValue = expectation(description: self.debugDescription)
        secondValue.isInverted = true
        
        let pipelineFork = PassthroughSubject<Int, Error>()
        var cancellables = Set<AnyCancellable>()
        
        var sinkValus = [Int]()
        
        let publisher = Deferred {
            Future<Int, Error> { promise in
                self.asyncAPICall(sabotage: false) { (grantedAccess, err) in
                    if let err = err {
                        promise(.failure(err))
                    } else {
                        promise(.success(grantedAccess))
                    }
                }
            }
        }
        .multicast(subject: pipelineFork)
        
        /// 1
        publisher.sink { (completion) in
            fisrtCompletion.fulfill()
        }
        receiveValue: { (value) in
            sinkValus.append(value)
            firstValues.fulfill()
        }
        .store(in: &cancellables)
        
        /// 2
        publisher.sink { (completion) in
            fisrtCompletion.fulfill()
        }
        receiveValue: { (value) in
            sinkValus.append(value)
            firstValues.fulfill()
        }
        .store(in: &cancellables)
        
        publisher
            .connect()
            .store(in: &cancellables)
        
        wait(for: [fisrtCompletion, firstValues], timeout: 5.0)
        XCTAssertEqual(sinkValus.count, 2)
        XCTAssertEqual(sinkValus[0], sinkValus[1])
        
        publisher.sink { (completion) in
            print(".sink() received the completion: ", String(describing: completion))
            secondCompletion.fulfill()
        }
        receiveValue: { (value) in
            sinkValus.append(value)
            secondValue.fulfill()
        }
        .store(in: &cancellables)
        
        wait(for: [secondCompletion, secondValue], timeout: 1.0)
        XCTAssertEqual(sinkValus.count, 2)
    }
    
    func testAltMulticastDeferredFuturePublisher() {
        // set up
        let expectation1 = XCTestExpectation(description: self.debugDescription)
        let expectation2 = XCTestExpectation(description: self.debugDescription)
        
        var cancellables = Set<AnyCancellable>()
        
        
        let publisher = Deferred {
            Future<Int, Error> { promise in
                self.asyncAPICall(sabotage: false) { (grantedAccess, err) in
                    if let err = err {
                        promise(.failure(err))
                    } else {
                        promise(.success(grantedAccess))
                    }
                }
            }
        }
        .multicast {
            PassthroughSubject<Int, Error>()
        }
        
        publisher.sink { (completion) in
            print(".sink() received the completion: ", String(describing: completion))
            expectation1.fulfill()
        }
        receiveValue: { (value) in
            print(".sink() received value: ", value)
        }
        .store(in: &cancellables)
        
        // driving it by attaching it to .sink
        publisher.sink { (completion) in
            print(".sink() received the completion: ", String(describing: completion))
            expectation2.fulfill()
        }
        receiveValue: { (value) in
            print(".sink() received value: ", value)
        }
        .store(in: &cancellables)
        
        publisher
            .connect()
            .store(in: &cancellables)
        
        wait(for: [expectation1, expectation2], timeout: 5.0)
    }
    
    // As the makeConnectable example above, but now with MultiCast we can include an error
    // Setup a "pipeline" inspector before handing the publisher back to the unsuspecting
    // original subscriber
    func testMulticastDeferredFutureAutoConnectPublisher() {
        // setup
        let doSomeSpyWork = expectation(description: self.debugDescription)
        let legitCompletion = expectation(description: self.debugDescription)
        let spyCompletion = expectation(description: self.debugDescription)
        let spyValueReceived = expectation(description: self.debugDescription)
        let legitValueReceived = expectation(description: self.debugDescription)
        
        var cancellables = Set<AnyCancellable>()
        
        // the creating the deferred, future publisher
        let publisher = Deferred {
            Future<Int, Error> { promise in
                self.asyncAPICall(sabotage: false) { (grantedAccess, err) in
                    if let err = err {
                        promise(.failure(err))
                    } else {
                        promise(.success(grantedAccess))
                    }
                }
            }
        }.multicast {
            // alternate way of using multicast that creates the relevant subject inline
            PassthroughSubject<Int, Error>()
        }
        
        // Attach our 'spy' subscriber. The publisher won't receive a 'send' .... yet
        publisher.sink(receiveCompletion: { completion in
            print(".sink() received the completion: ", String(describing: completion))
            spyCompletion.fulfill()
        }, receiveValue: { value in
            print(".sink() received value: ", value)
            spyValueReceived.fulfill()
        })
        .store(in: &cancellables) // Note: the spy needs to keep a reference to his own subscriber
        // Our spy has some work to do now before hands back the intercepted publisher
        doSomeSpyWork.fulfill()
        
        // Now hand off the publisher to the real subscriber
        let spyedPublisher = publisher.autoconnect()
        spyedPublisher.sink(receiveCompletion: { completion in
            print(".sink() received the completion: ", String(describing: completion))
            legitCompletion.fulfill()
        }, receiveValue: { value in
            print(".sink() received value: ", value)
            legitValueReceived.fulfill()
        })
        .store(in: &cancellables)
        
        wait(for: [doSomeSpyWork, spyValueReceived], timeout: 5.0, enforceOrder: true)
        wait(for: [legitValueReceived, legitCompletion, spyCompletion], timeout: 5.0)
    }
    
    func testMakeConnectable() {
        // setup
        let firstCompletion = expectation(description: self.debugDescription)
        
        let values = expectation(description: self.debugDescription)
        values.expectedFulfillmentCount = 4
        
        let waiting = expectation(description: self.debugDescription)
        
        var cancellables = Set<AnyCancellable>()
        
        let publisher = [1,2].publisher
            .makeConnectable()
        
        // driving it by attaching it to .sink
        publisher.sink(receiveCompletion: { completion in
            print(".sink1() received the completion: ", String(describing: completion))
            firstCompletion.fulfill()
        }, receiveValue: { value in
            print(".sink1() received value: ", value)
            values.fulfill()
        })
        .store(in: &cancellables)
        
        // Setup the order in our wait. The first completion won't have ooccured yet.
        waiting.fulfill()
        
        let autoPublisher = publisher.autoconnect()
        
        // driving it by attaching it to .sink
        autoPublisher.sink(receiveCompletion: { completion in
            print(".sink2() received the completion: ", String(describing: completion))
        }, receiveValue: { value in
            print(".sink2() received value: ", value)
            values.fulfill()
        })
        .store(in: &cancellables)
        
        // We should have fulfilled our mock "setup" before anyone received values
        wait(for: [waiting, values, firstCompletion], timeout: 5.0, enforceOrder: true)
    }
}
