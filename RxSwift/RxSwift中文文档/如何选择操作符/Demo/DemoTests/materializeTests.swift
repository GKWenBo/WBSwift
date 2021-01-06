//
//  materializeTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “将序列产生的事件，转换成元素”
 
 “通常，一个有限的 Observable 将产生零个或者多个 onNext 事件，然后产生一个 onCompleted 或者 onError 事件。

 materialize 操作符将 Observable 产生的这些事件全部转换成元素，然后发送出来。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class materializeTests: XCTestCase {

    enum TestError: Error {
        case test
    }
    
    func testMaterialize() {
        
        let disposeBag = DisposeBag()
        
        let observable = Observable<Int>.create { (observer) -> Disposable in
            
            observer.onNext(1)
            observer.onError(TestError.test)
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        observable
            .materialize()
            .subscribe {
                print($0)
            }
            .disposed(by: disposeBag)
    }
}
