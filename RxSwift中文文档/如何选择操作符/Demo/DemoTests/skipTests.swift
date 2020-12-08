//
//  skipTests.swift
//  DemoTests
//
//  Created by WENBO on 2020/12/8.
//

/*
 “跳过 Observable 中头 n 个元素”
 
 “skip 操作符可以让你跳过 Observable 中头 n 个元素，只关注后面的元素。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class skipTests: XCTestCase {

    func testSkip() {
        let disposeBag = DisposeBag()
        
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .skip(2)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
    }
}
