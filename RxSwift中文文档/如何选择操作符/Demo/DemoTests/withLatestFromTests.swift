//
//  withLatestFromTests.swift
//  DemoTests
//
//  Created by WENBO on 2020/12/8.
//

/*
 “将两个 Observables 最新的元素通过一个函数组合起来，当第一个 Observable 发出一个元素，就将组合后的元素发送出来”
 
 “withLatestFrom 操作符将两个 Observables 中最新的元素通过一个函数组合起来，然后将这个组合的结果发出来。当第一个 Observable 发出一个元素时，就立即取出第二个 Observable 中最新的元素，通过一个组合函数将两个最新的元素合并后发送出去”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class withLatestFromTests: XCTestCase {

    func testWithLatestFrom() {
        let disposeBag = DisposeBag()
        let firstSubject = PublishSubject<String>()
        let secondSubject = PublishSubject<String>()

        firstSubject
            .withLatestFrom(secondSubject)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        firstSubject.onNext("🅰️")
        firstSubject.onNext("🅱️")
        secondSubject.onNext("1")
        secondSubject.onNext("2")
        firstSubject.onNext("🆎")

    }
    
    func testWithLatestFrom1() {
        let disposeBag = DisposeBag()
        let firstSubject = PublishSubject<String>()
        let secondSubject = PublishSubject<String>()

        firstSubject
            .withLatestFrom(secondSubject,
                            resultSelector: {
                                return $0 + $1
                            })
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        firstSubject.onNext("🅰️")
        firstSubject.onNext("🅱️")
        secondSubject.onNext("1")
        secondSubject.onNext("2")
        firstSubject.onNext("🆎")

    }
}
