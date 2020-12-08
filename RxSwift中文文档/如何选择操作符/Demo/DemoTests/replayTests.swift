//
//  replayTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/8.
//

/*
 “确保观察者接收到同样的序列，即使是在 Observable 发出元素后才订阅”
 
 “可被连接的 Observable 和普通的 Observable 十分相似，不过在被订阅后不会发出元素，直到 connect 操作符被应用为止。这样一来你可以控制 Observable 在什么时候开始发出元素。

 replay 操作符将 Observable 转换为可被连接的 Observable，并且这个可被连接的 Observable 将缓存最新的 n 个元素。当有新的观察者对它进行订阅时，它就把这些被缓存的元素发送给观察者。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class replayTests: XCTestCase {
    
    func testReplay() {
        let intSequence = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .replay(5)

        _ = intSequence
            .subscribe(onNext: { print("Subscription 1:, Event: \($0)") })

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            _ = intSequence.connect()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
          _ = intSequence
              .subscribe(onNext: { print("Subscription 2:, Event: \($0)") })
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
          _ = intSequence
              .subscribe(onNext: { print("Subscription 3:, Event: \($0)") })
        }

    }
}
