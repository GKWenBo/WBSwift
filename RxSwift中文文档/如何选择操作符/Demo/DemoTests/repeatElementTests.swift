//
//  repeatElement.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “创建 Observable 重复的发出某个元素”
 
 “repeatElement 操作符将创建一个 Observable，这个 Observable 将无止尽的发出同一个元素。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class repeatElementTests: XCTestCase {

    func testRepeatElement() {
        let disposeBag = DisposeBag()
        
        _ = Observable
            .repeatElement(6)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
}
