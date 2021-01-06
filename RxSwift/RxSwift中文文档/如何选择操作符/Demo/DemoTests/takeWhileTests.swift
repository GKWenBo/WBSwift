//
//  takeWhileTests.swift
//  DemoTests
//
//  Created by WENBO on 2020/12/8.
//

/*
 “镜像一个 Observable 直到某个元素的判定为 false”
 
 “takeWhile 操作符将镜像源 Observable 直到某个元素的判定为 false。此时，这个镜像的 Observable 将立即终止。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class takeWhileTests: XCTestCase {

    func testTakeWhile() {
        
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 4, 5, 6)
            .takeWhile({ $0 < 4 })
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
    }
    
}
