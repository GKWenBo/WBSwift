//
//  ViewController.swift
//  15 新增AsyncSequence异步序列
//
//  Created by wenbo on 2021/11/24.
//
/*
 1、AsyncSequence定义
 2、实现一个异步序列
 3、Cancellation
 4、AsyncSequence函数
 */

// MARK: - 1、AsyncSequence
/*
 public protocol AsyncSequence {
   associatedtype AsyncIterator: AsyncIteratorProtocol where AsyncIterator.Element == Element
   associatedtype Element
   __consuming func makeAsyncIterator() -> AsyncIterator
 }

 public protocol AsyncIteratorProtocol {
   associatedtype Element
   mutating func next() async throws -> Element?
 }
 */

// MARK: - 3、Cancellation
/*
 AsyncIteratorProtocol类型应该使用 structured concurrency 的一部分，Swift 的 Task API 提供的”取消”功能。正如那里面所描述的，迭代器可以选择如何响应“取消”。最常见的行为是抛出 CancellationError 或者让迭代器返回 nil。
 
 结束迭代：
 在 AsyncIteratorProtocol 类型的 next() 方法返回 nil 或抛出错误之后，后续所有对 next() 调用都必须返回 nil。 与 IteratorProtocol 类型的行为保持一致，这很重要，因为调用迭代器的 next() 方法是确定迭代是否完成的唯一方法。
 */

// MARK: - 4、AsyncSequence函数
/*
 contains(_ value: Element) async rethrows -> Bool
 contains(where: (Element) async throws -> Bool) async rethrows -> Bool
 first(where: (Element) async throws -> Bool) async rethrows -> Element?
 min() async rethrows -> Element?
 min(by: (Element, Element) async throws -> Bool) async rethrows -> Element?
 max() async rethrows -> Element?
 ...
 */

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Task {
            for await i in Counter(howHigh: 3) {
                print(i)
                // 结束迭代
                if i == 2 { break }
            }
            
            // min
            let min = await Counter(howHigh: 3).min()
            print(min as Any)
        }
    }

}

// MARK: - 2、实现一个异步序列
struct Counter: AsyncSequence {
    typealias Element = Int
    
    let howHigh: Int
    
    struct AsyncIterator: AsyncIteratorProtocol {
        let howHigh: Int
        var current = 1
        mutating func next() async -> Int? {
            guard current <= howHigh else {
                return nil
            }
            
            let result = current
            current += 1
            return result
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(howHigh: howHigh)
    }
}

