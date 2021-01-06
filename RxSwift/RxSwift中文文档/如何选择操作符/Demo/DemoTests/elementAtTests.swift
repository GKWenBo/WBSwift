//
//  elementAtTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “只发出 Observable 中的第 n 个元素”
 
 “elementAt 操作符将拉取 Observable 序列中指定索引数的元素，然后将它作为唯一的元素发出。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class elementAtTests: XCTestCase {

    func testElementAt() {
        let disposeBag = DisposeBag()
        
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .elementAt(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
}
