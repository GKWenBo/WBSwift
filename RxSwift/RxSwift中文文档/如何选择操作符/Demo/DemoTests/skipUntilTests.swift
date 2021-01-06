//
//  skipUntilTests.swift
//  DemoTests
//
//  Created by WENBO on 2020/12/8.
//

import XCTest
import RxSwift
import RxCocoa

class skipUntilTests: XCTestCase {
    
    func testSkipUntilTests() {
        let disposeBag = DisposeBag()
        
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence
            .skipUntil(referenceSequence)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        sourceSequence.onNext("🐱")
        sourceSequence.onNext("🐰")
        sourceSequence.onNext("🐶")

        referenceSequence.onNext("🔴")

        sourceSequence.onNext("🐸")
        sourceSequence.onNext("🐷")
        sourceSequence.onNext("🐵")

    }
}
