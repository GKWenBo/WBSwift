//
//  SignalTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/7.
//

/*
 “Signal 和 Driver 相似，唯一的区别是，Driver 会对新观察者回放（重新发送）上一个元素，而 Signal 不会对新观察者回放上一个元素。

 他有如下特性:

 不会产生 error 事件
 一定在 MainScheduler 监听（主线程监听）
 共享附加作用”
 
 结论
 一般情况下状态序列我们会选用 Driver 这个类型，事件序列我们会选用 Signal 这个类型

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxCocoa
import RxSwift

class SignalTests: XCTestCase {

    let disposeBag = DisposeBag()
    
    
    func testDriverExample() {
        let textFiled: UITextField = UITextField()
        let nameLabel: UILabel = UILabel()
        let nameSizeLabel: UILabel = UILabel()
        
        let state: Driver<String?> = textFiled.rx.text.asDriver()
        
        let observer = nameLabel.rx.text
        state.drive(observer)
            .disposed(by: disposeBag)
        
        /// “ 假设以下代码是在用户输入姓名后运行”
        let newObserver = nameSizeLabel.rx.text
        state.map({ $0?.count.description })
            .drive(newObserver)
            .disposed(by: disposeBag)
    }
    
    // Driver 会回放点击事件
    func testDriverEvent() {
        let button = UIButton()
        
        let event: Driver<Void> = button.rx.tap.asDriver()
        
        let observer: () -> Void = {
            print("show alert")
        }
        
        event.drive(onNext: observer)
            .disposed(by: disposeBag)
        
        
        let newObserver: () -> Void = {
            print("show alert1")
        }
        
        event.drive(onNext: newObserver)
            .disposed(by: disposeBag)
    }
    
    func testSignal() {
        let button = UIButton()
        
        let event: Signal<Void> = button.rx.tap.asSignal()
        
        let observer: () -> Void = {
            print("show alert")
        }
        event.emit(onNext: observer)
            .disposed(by: disposeBag)
        
        
        let newObserver: () -> Void = {
            print("show alert1")
        }
        event.emit(onNext: newObserver)
            .disposed(by: disposeBag)
    }
}
