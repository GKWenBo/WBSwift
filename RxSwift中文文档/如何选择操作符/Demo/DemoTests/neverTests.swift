//
//  neverTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “创建一个永远不会发出元素的 Observable”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class neverTests: XCTestCase {

    func testNever() {
        let id = Observable<Int>.never()
        
        /// 相当于
        let id1 = Observable<Int>.create { (observer) -> Disposable in
            return Disposables.create()
        }
        
    }
}
