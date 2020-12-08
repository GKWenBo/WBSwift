//
//  fromTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “将其他类型或者数据结构转换为 Observable”
 
 “当你在使用 Observable 时，如果能够直接将其他类型转换为 Observable，这将是非常省事的。from 操作符就提供了这种功能。”
 
 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class fromTests: XCTestCase {
    
    func testFrom() {
        _ = Observable.from([0, 1, 2])
        
        /// 相当于
        _ = Observable<Int>.create({ (observer) -> Disposable in
            observer.onNext(0)
            observer.onNext(1)
            observer.onNext(2)
            observer.onCompleted()
            return Disposables.create()
        })
        
    }
}
