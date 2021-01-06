//
//  justTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “创建 Observable 发出唯一的一个元素”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class justTests: XCTestCase {

    func testJust() {
        _ = Observable.just(0)
        
        /// 相当于
        _ = Observable<Int>.create({ (observer) -> Disposable in
            observer.onNext(0)
            observer.onCompleted()
            return Disposables.create()
        })
    }
}
