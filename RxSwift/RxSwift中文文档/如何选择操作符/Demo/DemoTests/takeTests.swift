//
//  takeTests.swift
//  DemoTests
//
//  Created by WENBO on 2020/12/8.
//

/*
 “仅仅从 Observable 中发出头 n 个元素”
 
 “通过 take 操作符你可以只发出头 n 个元素。并且忽略掉后面的元素，直接结束序列。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class takeTests: XCTestCase {

    
    func testTake() {
        let disposeBag = DisposeBag()
        
        Observable.of("1", "2", "3", "4")
            .take(3)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
