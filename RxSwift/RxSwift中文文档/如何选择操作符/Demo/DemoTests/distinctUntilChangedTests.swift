//
//  distinctUntilChangedTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “阻止 Observable 发出相同的元素
 ”

 “distinctUntilChanged 操作符将阻止 Observable 发出相同的元素。如果后一个元素和前一个元素是相同的，那么这个元素将不会被发出来。如果后一个元素和前一个元素不相同，那么这个元素才会被发出来。”
 
 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class distinctUntilChangedTests: XCTestCase {

    func testdistinctUntilChanged() {
        let disposeBag = DisposeBag()
        
        Observable.of("1", "1", "2", "3", "4")
            .distinctUntilChanged()
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
    
}
