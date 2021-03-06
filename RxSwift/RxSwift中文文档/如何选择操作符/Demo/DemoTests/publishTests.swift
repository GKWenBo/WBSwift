//
//  publishTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “将 Observable 转换为可被连接的 Observable”
 
 “publish 会将 Observable 转换为可被连接的 Observable。可被连接的 Observable 和普通的 Observable 十分相似，不过在被订阅后不会发出元素，直到 connect 操作符被应用为止。这样一来你可以控制 Observable 在什么时候开始发出元素。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class publishTests: XCTestCase {

    func testPublish() {
        let intSequence = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .publish()

        _ = intSequence
            .subscribe(onNext: { print("Subscription 1:, Event: \($0)") })

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            _ = intSequence.connect()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
          _ = intSequence
              .subscribe(onNext: { print("Subscription 2:, Event: \($0)") })
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
          _ = intSequence
              .subscribe(onNext: { print("Subscription 3:, Event: \($0)") })
        }

    }
}
