//
//  startWithTests.swift
//  DemoTests
//
//  Created by WENBO on 2020/12/8.
//

/*
 “将一些元素插入到序列的头部”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 
 “startWith 操作符会在 Observable 头部插入一些元素。
 （如果你想在尾部加入一些元素可以用concat）”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class startWithTests: XCTestCase {
    
    func testStartWith() {
        let disposeBag = DisposeBag()
        
        Observable.of("🐶", "🐱", "🐭", "🐹")
            .startWith("1")
            .startWith("2")
            .startWith("3", "4")
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
