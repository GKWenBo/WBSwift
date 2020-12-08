//
//  catchErrorJustReturnTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “catchErrorJustReturn 操作符会将error 事件替换成其他的一个元素，然后结束该序列。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class catchErrorJustReturnTests: XCTestCase {

    enum TestError: Error {
        case test
    }
    
    func testCatchErrorJustReturn() {
        let disposeBag = DisposeBag()
        
        let sequenceThatFails = PublishSubject<String>()
        
        sequenceThatFails
            .catchErrorJustReturn("😊")
            .subscribe{
                print($0)
            }
            .disposed(by: disposeBag)
        
        sequenceThatFails.onNext("😬")
        sequenceThatFails.onNext("😨")
        sequenceThatFails.onNext("😡")
        sequenceThatFails.onNext("🔴")
        sequenceThatFails.onError(TestError.test)
    }
}
