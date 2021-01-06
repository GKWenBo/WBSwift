//
//  filterTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “filter 操作符将通过你提供的判定方法过滤一个 Observable。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books. 
 */

import XCTest
import RxSwift
import RxCocoa

class filterTests: XCTestCase {

    func testFilter() {
        let disposeBag = DisposeBag()
        
        Observable.of(2, 30, 22, 5, 60, 1)
            .filter { $0 > 10}
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
}
