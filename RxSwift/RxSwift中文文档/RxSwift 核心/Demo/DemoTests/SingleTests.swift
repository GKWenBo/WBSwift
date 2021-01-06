//
//  SigleTests.swift
//  DemoTests
//
//  Created by WENBO on 2020/12/6.
//

import XCTest
import RxSwift
import RxCocoa
/*
 “Single 是 Observable 的另外一个版本。不像 Observable 可以发出多个元素，它要么只能发出一个元素，要么产生一个 error 事件。

 发出一个元素，或一个 error 事件
 不会共享附加作用”
 
 “订阅提供一个 SingleEvent 的枚举：

 public enum SingleEvent<Element> {
     case success(Element)
     case error(Swift.Error)
 }”

 */

class SingleTests: XCTestCase {

    enum DataError: Error {
        case cantParseJSON
    }
    
    let disposeBag = DisposeBag()
    
    
    // 创建Single
    func getRepo(_ repo: String) -> Single<[String: Any]> {
        return Single.create { (single) -> Disposable in
            let url = URL(string: "https://api.github.com/repos/\(repo)")!
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    single(.error(error))
                    
                    return
                }
                
                guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else {
                    single(.error(DataError.cantParseJSON))
                    return
                }
                
                single(.success(jsonObject as! [String : Any]))
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func testSingle() {
        let expectation = XCTestExpectation(description: self.debugDescription)
        
            getRepo("ReactiveX/RxSwift")
            .subscribe { (json) in
                print(json)
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


