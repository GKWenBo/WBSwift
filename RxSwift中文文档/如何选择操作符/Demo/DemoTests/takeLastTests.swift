//
//  takeLastTests.swift
//  DemoTests
//
//  Created by WENBO on 2020/12/8.
//

import XCTest
import RxSwift
import RxCocoa

class takeLastTests: XCTestCase {

    func testTakeLast() {
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 4, 5)
            .takeLast(3)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
