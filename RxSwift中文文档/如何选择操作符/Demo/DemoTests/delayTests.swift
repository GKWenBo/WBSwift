//
//  delayTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “将 Observable 的每一个元素拖延一段时间后发出”
 
 “delay 操作符将修改一个 Observable，它会将 Observable 的所有元素都拖延一段设定好的时间， 然后才将它们发送出来。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxCocoa
import RxSwift

class delayTests: XCTestCase {

    func testDelay() {
        let disposeBag = DisposeBag()
        
        let subject = PublishSubject<Int>()
        
        subject
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe {
                print($0)
            }
            .disposed(by: disposeBag)
        
        subject.onNext(1)
        subject.onNext(2)
        subject.onNext(3)
    }
}
