//
//  debounceTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “过滤掉高频产生的元素”
 
 “debounce 操作符将发出这种元素，在 Observable 产生这种元素后，一段时间内没有新元素产生。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books. 
 */

import XCTest
import RxCocoa
import RxSwift

class debounceTests: XCTestCase {

    func testDebounce() {
        let subject = PublishSubject<Int>()
        
        let disposeBag = DisposeBag()
        
        subject
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe {
                print($0)
            }
            .disposed(by: disposeBag)
        
        subject.onNext(1)
        subject.onNext(2)
        
        subject.onNext(3)
        subject.onNext(4)
        subject.onNext(5)
    }
}
