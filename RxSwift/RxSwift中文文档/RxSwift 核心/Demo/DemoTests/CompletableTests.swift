//
//  CompletableTests.swift
//  DemoTests
//
//  Created by WENBO on 2020/12/6.
//

/*
 “Completable 是 Observable 的另外一个版本。不像 Observable 可以发出多个元素，它要么只能产生一个 completed 事件，要么产生一个 error 事件。

 发出零个元素
 发出一个 completed 事件或者一个 error 事件
 不会共享附加作用
 Completable 适用于那种你只关心任务是否完成，而不需要在意任务返回值的情况。它和 Observable<Void> 有点相似。”
 
 “订阅提供一个 CompletableEvent 的枚举：

 public enum CompletableEvent {
     case error(Swift.Error)
     case completed
 }”

 */

import XCTest
import RxSwift
import RxCocoa

class CompletableTests: XCTestCase {

    enum DataError: Error {
        case cantParseJSON
    }
    
    let disposeBag = DisposeBag()
    
    /// “如何创建 Completable”
    func cacheLocally(repo: String) -> Completable {
        return Completable.create { (completable) -> Disposable in
            let url = URL(string: "https://api.github.com/repos/\(repo)")!
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completable(.error(error))
                    
                    return
                }
                
                guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else {
                    completable(.error(DataError.cantParseJSON))
                    return
                }
                
                completable(.completed)
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func testCompletable() {
        
        let expectation = XCTestExpectation(description: self.debugDescription)
        
        
        cacheLocally(repo: "ReactiveX/RxSwift")
            .subscribe {
                print("finished!")
                expectation.fulfill()
            }
            onError: { (error) in
                print(error)
                expectation.fulfill()
            }
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5.0)
    }
}
