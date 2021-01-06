//
//  mapTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “通过一个转换函数，将 Observable 的每个元素转换一遍”
 
 “map 操作符将源 Observable 的每个元素应用你提供的转换方法，然后返回含有转换结果的 Observable”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class mapTests: XCTestCase {

    func testMap() {
        let disposeBag = DisposeBag()
        
        Observable.of(2, 2, 6)
            .map { $0 * 10}
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
}
