//
//  ReplaySubjectTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “ReplaySubject 将对观察者发送全部的元素，无论观察者是何时进行订阅的。

 这里存在多个版本的 ReplaySubject，有的只会将最新的 n 个元素发送给观察者，有的只会将限制时间段内最新的元素发送给观察者。

 如果把 ReplaySubject 当作观察者来使用，注意不要在多个线程调用 onNext, onError 或 onCompleted。这样会导致无序调用，将造成意想不到的结果。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class ReplaySubjectTests: XCTestCase {
    
    func testReplaySubject() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        let disposeBag = DisposeBag()
        
        var subCount1 = 0;
        var subCount2 = 0;
        
        let replaySubject = ReplaySubject<String>.create(bufferSize: 1)
        
        replaySubject
            .subscribe(onNext: {
                
                subCount1 += 1
                print("Subscription: 1 Event:", $0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        replaySubject.onNext("🐶")
        replaySubject.onNext("🐱")
        
        replaySubject
            .subscribe(onNext: {
                subCount2 += 1
                print("Subscription: 2 Event:", $0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        replaySubject.onNext("🅰️")
        replaySubject.onNext("🅱️")

        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertEqual(subCount1, 4)
        XCTAssertEqual(subCount2, 3)
    }
}
