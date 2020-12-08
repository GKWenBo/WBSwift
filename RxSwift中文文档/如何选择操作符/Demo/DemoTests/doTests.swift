//
//  doTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “当 Observable 产生某些事件时，执行某个操作
 ”
 
 “当 Observable 的某些事件产生时，你可以使用 do 操作符来注册一些回调操作。这些回调会被单独调用，它们会和 Observable 原本的回调分离。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class doTests: XCTestCase {

    
    func testDo() {
        let disposeBag = DisposeBag()
        
        Observable.of("1", "1", "2", "3", "4")
            .distinctUntilChanged()
            .do(onNext: { (string) in
                print("do:", string)
            })
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
    
}
