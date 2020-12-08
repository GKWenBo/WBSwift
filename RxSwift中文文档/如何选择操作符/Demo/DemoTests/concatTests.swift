//
//  concatTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

import XCTest
import RxCocoa
import RxSwift

class concatTests: XCTestCase {

    func testConcat() {
        let disposeBag = DisposeBag()
        
        let subject1 = BehaviorSubject(value: "🍎")
        let subject2 = BehaviorSubject(value: "🐶")
        
        subject1
            .concat(subject2)
            .subscribe {
                print($0)
            }
            .disposed(by: disposeBag)
        
//        let variable = Variable(subject1)
//        variable.asObservable()
//            .concat()
//            .subscribe {
//
//            }
//            .disposed(by: disposeBag)
        
        subject1.onNext("🍐")
        subject1.onNext("🍊")

//        variable.value = subject2;
        
        subject2.onNext("I would be ignored")
        subject2.onNext("🐱")

        subject1.onCompleted()
        
        subject2.onNext("🐭")
    }
}
