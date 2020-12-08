//
//  createTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “create 操作符将创建一个 Observable，你需要提供一个构建函数，在构建函数里面描述事件（next，error，completed）的产生过程。

 通常情况下一个有限的序列，只会调用一次观察者的 onCompleted 或者 onError 方法。并且在调用它们后，不会再去调用观察者的其他方法。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxCocoa
import RxSwift

class createTests: XCTestCase {
    
    func testCreate() {
        let disposeBag = DisposeBag()
        
        
        let o = Observable<Int>.create { (observer) -> Disposable in
            
            observer.onNext(0)
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onNext(4)
            observer.onNext(5)
            observer.onNext(6)
            observer.onNext(7)
            observer.onNext(8)
            observer.onNext(9)
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        o.subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
    }
}
