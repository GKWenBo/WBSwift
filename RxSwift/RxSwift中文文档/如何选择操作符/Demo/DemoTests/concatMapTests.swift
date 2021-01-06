//
//  concatMapTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “将 Observable 的元素转换成其他的 Observable，然后将这些 Observables 串连起来”
 
 “concatMap 操作符将源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。然后让这些 Observables 按顺序的发出元素，当前一个 Observable 元素发送完毕后，后一个 Observable 才可以开始发出元素。等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxCocoa
import RxSwift

class concatMapTests: XCTestCase {

    func testConcatMap() {
        let disposeBag = DisposeBag()

        let subject1 = BehaviorSubject(value: "🍎")
        let subject2 = BehaviorSubject(value: "🐶")

        let variable = Variable(subject1)

        variable.asObservable()
                .concatMap { $0 }
                .subscribe { print($0) }
                .disposed(by: disposeBag)

        subject1.onNext("🍐")
        subject1.onNext("🍊")

        variable.value = subject2

        subject2.onNext("I would be ignored")
        subject2.onNext("🐱")

        subject1.onCompleted()

        subject2.onNext("🐭")

    }
}
