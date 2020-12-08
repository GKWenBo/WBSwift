//
//  PublishSubjectTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “PublishSubject 将对观察者发送订阅后产生的元素，而在订阅前发出的元素将不会发送给观察者。如果你希望观察者接收到所有的元素，你可以通过使用 Observable 的 create 方法来创建 Observable，或者使用 ReplaySubject。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class PublishSubjectTests: XCTestCase {

    
    func testPublishSubject() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        let disposeBag = DisposeBag()
        let subject = PublishSubject<String>()
        
        var subCount1 = 0;
        var subCount2 = 0;
        
        
        subject
            .subscribe(onNext: {
                print("subscribe1: \($0)")
                subCount1 += 1
                
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        subject.onNext("🐶")
        subject.onNext("🐱")
        
        subject
            .subscribe(onNext: {
                print("subscribe2: \($0)")
                subCount2 += 1
                
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        subject.onNext("🅰️")
        subject.onNext("🅱️")

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(subCount1, 4)
        XCTAssertEqual(subCount2, 2)
    }
}
