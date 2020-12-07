//
//  MaybeTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/7.
//

/*
 “Maybe 是 Observable 的另外一个版本。它介于 Single 和 Completable 之间，它要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件。

 发出一个元素或者一个 completed 事件或者一个 error 事件
 不会共享附加作用
 如果你遇到那种可能需要发出一个元素，又可能不需要发出时，就可以使用 Maybe。”
 
 “Observable 调用 .asMaybe() 方法，将它转换为 Maybe。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class MaybeTests: XCTestCase {
    
    enum MyError: Error {
        case noError
    }
    
    var disposeBag = DisposeBag()
    
    
    func generateString() -> Maybe<String> {
        return Maybe.create { (maybe) -> Disposable in
            maybe(.success("RxSwift"))
            
            // or
            maybe(.completed)
            
            // or
            maybe(.error(MyError.noError))
            
            return Disposables.create()
        }
    }
    
    func testMaybe() {
        generateString()
            .subscribe { (string) in
                
            }
            onError: { (error) in
                
            }
            onCompleted: {
                
            }
            .disposed(by: self.disposeBag)

    }
}
