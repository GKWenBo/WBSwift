//
//  zipTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “通过一个函数将多个 Observables 的元素组合起来，然后将每一个组合的结果发出来”
 
 “zip 操作符将多个(最多不超过8个) Observables 的元素通过一个函数组合起来，然后将这个组合的结果发出来。它会严格的按照序列的索引数进行组合。例如，返回的 Observable 的第一个元素，是由每一个源 Observables 的第一个元素组合出来的。它的第二个元素 ，是由每一个源 Observables 的第二个元素组合出来的。它的第三个元素 ，是由每一个源 Observables 的第三个元素组合出来的，以此类推。它的元素数量等于源 Observables 中元素数量最少的那个。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxCocoa
import RxSwift

class zipTests: XCTestCase {
    
    func testZip() {
        let disposeBag = DisposeBag()
        
        let first = PublishSubject<String>()
        let second = PublishSubject<String>()
        
        Observable.zip(first, second)
            .subscribe{
                print($0 + $1)
            }
            .disposed(by: disposeBag)
        
        first.onNext("1")
        second.onNext("A")
        first.onNext("2")
        second.onNext("B")
        second.onNext("C")
        second.onNext("D")
        first.onNext("3")
        first.onNext("4")
    }
}
