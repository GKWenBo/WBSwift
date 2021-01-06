//
//  debugTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

import XCTest
import RxCocoa
import RxSwift

class debugTests: XCTestCase {
    
    func testDebug() {
        let disposeBag = DisposeBag()
        
        let o = Observable<String>.create { (observer) -> Disposable in
            observer.onNext("🍎")
            observer.onNext("🍐")
            observer.onCompleted()
            return Disposables.create()
        }
        
        o
        .debug("Fruit")
        .subscribe()
        .disposed(by: disposeBag)
        
    }
}
