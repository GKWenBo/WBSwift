//
//  takeUntilTests.swift
//  DemoTests
//
//  Created by WENBO on 2020/12/8.
//

/*
 “忽略掉在第二个 Observable 产生事件后发出的那部分元素”
 
 “takeUntil 操作符将镜像源 Observable，它同时观测第二个 Observable。一旦第二个 Observable 发出一个元素或者产生一个终止事件，那个镜像的 Observable 将立即终止。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class takeUntilTests: XCTestCase {

    func testTakeUntil() {
        let disposeBag = DisposeBag()
        
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence
            .takeUntil(referenceSequence)
            .subscribe({
                print($0)
            })
            .disposed(by: disposeBag)
        
        sourceSequence.onNext("1")
        sourceSequence.onNext("2")
        
        referenceSequence.onNext("123")
        
        sourceSequence.onNext("3")
        sourceSequence.onNext("4")
    }
    
}
