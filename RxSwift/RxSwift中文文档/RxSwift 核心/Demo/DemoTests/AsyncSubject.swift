//
//  AsyncSubject.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “AsyncSubject 将在源 Observable 产生完成事件后，发出最后一个元素（仅仅只有最后一个元素），如果源 Observable 没有发出任何元素，只有一个完成事件。那 AsyncSubject 也只有一个完成事件。”
 
 “它会对随后的观察者发出最终元素。如果源 Observable 因为产生了一个 error 事件而中止， AsyncSubject 就不会发出任何元素，而是将这个 error 事件发送出来。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxCocoa
import RxSwift

class AsyncSubjectTests: XCTestCase {
    
    func testAsyncSubject() {
        
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        
        let disposeBag = DisposeBag()
        
        let subject = AsyncSubject<String>()
        
        subject.subscribe { (string) in
            print(string)
            XCTAssertEqual(string, "3")
        }
        onError: { (error) in
            print(error)
        }
        onCompleted: {
            expectation.fulfill()
        }
        .disposed(by: disposeBag)

        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        subject.onCompleted()
        
        wait(for: [expectation], timeout: 5.0)
    }
}
