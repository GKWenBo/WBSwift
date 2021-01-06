//
//  skipWhileTests.swift
//  DemoTests
//
//  Created by WENBO on 2020/12/8.
//

/*
 “跳过 Observable 中头几个元素，直到元素的判定为否”
 
 “skipWhile 操作符可以让你忽略源 Observable 中头几个元素，直到元素的判定为否后，它才镜像源 Observable。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books. 
 */

import XCTest
import RxSwift
import RxCocoa

class skipWhileTests: XCTestCase {

    func testSkipWhile() {
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 4, 5, 6, 1)
            .skipWhile{ $0 < 5}
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
