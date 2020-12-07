//
//  ObserverTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/7.
//

/*
 如何创建观察者
 “和 Observable 一样，框架已经帮我们创建好了许多常用的观察者。例如：view 是否隐藏，button 是否可点击， label 的当前文本，imageView 的当前图片等等。”
 
 “创建观察者最直接的方法就是在 Observable 的 subscribe 方法后面描述，事件发生时，需要如何做出响应。而观察者就是由后面的 onNext，onError，onCompleted的这些闭包构建出来的”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxCocoa
import RxSwift

class ObserverTests: XCTestCase {

    let disposeBag = DisposeBag()
    
    func testRequest() {
        let url = URL(string: "test")!
        
        URLSession.shared.rx.data(request: URLRequest(url: url))
            .subscribe { (data) in
                print(data)
            }
            onError: { (error) in
                print(error)
            }
            onCompleted: {
                
            }
            .disposed(by: disposeBag)

    }
    
    func testAnyObserver() {
        let observer: AnyObserver<Data> = AnyObserver { event in
            
            switch event {
            case .next(let data):
                print(data)
            case .error(let error):
                print(error)
            default:
                break
            }
            
        }
        
        let url = URL(string: "test")!
        
        URLSession.shared.rx.data(request: URLRequest(url: url))
            .subscribe (observer)
            .disposed(by: disposeBag)
    }
}
