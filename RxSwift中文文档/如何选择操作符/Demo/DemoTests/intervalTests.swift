//
//  intervalTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “创建一个 Observable 每隔一段时间，发出一个索引数”
 
 “interval 操作符将创建一个 Observable，它每隔一段设定的时间，发出一个索引数的元素。它将发出无数个元素。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class intervalTests: XCTestCase {
    
    func testInterval() {
        let disposeBag = DisposeBag()
        
        _ = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
}
