//
//  catchErrorTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “从一个错误事件中恢复，将错误事件替换成一个备选序列”
 
 “catchError 操作符将会拦截一个 error 事件，将它替换成其他的元素或者一组元素，然后传递给观察者。这样可以使得 Observable 正常结束，或者根本都不需要结束。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class catchErrorTests: XCTestCase {
    
    enum TestError: Error {
        case test
    }

    func testCatchError() {
        let sequenceThatFails = PublishSubject<String>()
        let recoverySequence = PublishSubject<String>()
        
        let disposeBag = DisposeBag()
        
        sequenceThatFails
            .catchError {_ in
                return recoverySequence
            }
            .subscribe{
                print($0)
            }
            .disposed(by: disposeBag)
        
        sequenceThatFails.onNext("😬")
        sequenceThatFails.onNext("😨")
        sequenceThatFails.onNext("😡")
        sequenceThatFails.onNext("🔴")
        sequenceThatFails.onError(TestError.test)

        recoverySequence.onNext("😊")
    }
}
