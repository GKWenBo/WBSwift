//
//  errorTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “error 操作符将创建一个 Observable，这个 Observable 只会产生一个 error 事件。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class errorTests: XCTestCase {

    enum TestError: Error {
        case test
    }
    
    func testError() {
        _ = Observable<Int>.error(TestError.test)
        
        // 相当于
        _ = Observable<Int>.create{ (observer) -> Disposable in
            observer.onError(TestError.test)
            return Disposables.create()
        }
    }
}
