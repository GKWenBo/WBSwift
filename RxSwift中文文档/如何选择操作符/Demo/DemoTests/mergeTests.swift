//
//  mergeTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “将多个 Observables 合并成一个
 ”

 “通过使用 merge 操作符你可以将多个 Observables 合并成一个，当某一个 Observable 发出一个元素时，他就将这个元素发出。

 如果，某一个 Observable 发出一个 onError 事件，那么被合并的 Observable 也会将它发出，并且立即终止序列。”
 
 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class mergeTests: XCTestCase {

    func testMerge() {
        let disposeBag = DisposeBag()
        
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        subject1.onNext("🅰️")

        subject1.onNext("🅱️")

        subject2.onNext("①")

        subject2.onNext("②")

        subject1.onNext("🆎")

        subject2.onNext("③")

    }
    
}
