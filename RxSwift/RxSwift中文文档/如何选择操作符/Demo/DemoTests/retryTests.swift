//
//  retryTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “如果源 Observable 产生一个错误事件，重新对它进行订阅，希望它不会再次产生错误”
 
 “retry 操作符将不会将 error 事件，传递给观察者，然而，它会从新订阅源 Observable，给这个 Observable 一个重试的机会，让它有机会不产生 error 事件。retry 总是对观察者发出 next 事件，即便源序列产生了一个 error 事件，所以这样可能会产生重复的元素”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class retryTests: XCTestCase {

    enum TestError: Error {
        case error
    }
    
    func testRetry() {
        let disposeBag = DisposeBag()
        var count = 1
        
        let sequenceThatError = Observable<Int>.create { (observer) -> Disposable in
            
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            
            if count == 1 {
                observer.onError(TestError.error)
                print("An error encountered")
                count += 1
            }
            
            observer.onNext(4)
            observer.onNext(5)
            observer.onNext(6)
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        sequenceThatError
            .retry()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
