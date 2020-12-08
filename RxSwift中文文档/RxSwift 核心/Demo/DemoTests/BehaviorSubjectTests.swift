//
//  BehaviorSubjectTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “当观察者对 BehaviorSubject 进行订阅时，它会将源 Observable 中最新的元素发送出来（如果不存在最新的元素，就发出默认元素）。然后将随后产生的元素发送出来。”
 
 “如果源 Observable 因为产生了一个 error 事件而中止， BehaviorSubject 就不会发出任何元素，而是将这个 error 事件发送出来。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxCocoa
import RxSwift

class BehaviorSubjectTests: XCTestCase {

    func testBehaviorSubject() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        let disposeBag = DisposeBag()
        
        var subCount1 = 0;
        var subCount2 = 0;
        var subCount3 = 0;
        
        let subject = BehaviorSubject<String>(value: "🔴")
        
        subject
            .subscribe(onNext: {
                print("Subscription: 1 Event:", $0)
                subCount1 += 1
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        subject.onNext("🐶")
        subject.onNext("🐱")
        
        subject
            .subscribe(onNext: {
                print("Subscription: 2 Event:", $0)
                subCount2 += 1
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        subject.onNext("🅰️")
        subject.onNext("🅱️")

        subject
            .subscribe(onNext: {
                print("Subscription: 3 Event:", $0)
                subCount3 += 1
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        subject.onNext("🍐")
        subject.onNext("🍊")
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertEqual(subCount1, 7)
        XCTAssertEqual(subCount2, 5)
        XCTAssertEqual(subCount3, 3)
    }
    
}
