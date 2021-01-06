//
//  emptyTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “empty 操作符将创建一个 Observable，这个 Observable 只有一个完成事件。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books. 
 */

import XCTest
import RxSwift
import RxCocoa

class emptyTests: XCTestCase {
    
    func testEmptyTests() {
        _ = Observable<Int>.empty()
        
        // 相当于
        _ = Observable<Int>.create { (observer) -> Disposable in
            observer.onCompleted()
            return Disposables.create()
        }
        
    }
}
