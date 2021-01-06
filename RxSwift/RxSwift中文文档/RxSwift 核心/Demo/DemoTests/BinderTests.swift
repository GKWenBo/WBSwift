//
//  BinderTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/7.
//

/*
 “Binder 主要有以下两个特征：

 不会处理错误事件
 确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
 一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

import XCTest
import RxSwift
import RxCocoa

class BinderTests: XCTestCase {

    let disposeBag = DisposeBag()
    
    func testAnyObserver() {
        let usernameValidOutlet = UILabel()
        let userNameTF = UITextField()
        
        let observer: AnyObserver<Bool> = AnyObserver { event in
            switch event {
            case .next(let isHidden):
                usernameValidOutlet.isHidden = isHidden
            default:
                break
            }
        }
        
        let userNameValid = userNameTF.rx
            .text
            .orEmpty
            .map({ $0.count > 0 })
        userNameValid
            .bind(to: observer)
            .disposed(by: disposeBag)
        
    }
    
    func testBinder() {
        let usernameValidOutlet = UILabel()
        let userNameTF = UITextField()
        
        let userNameValid = userNameTF.rx
            .text
            .orEmpty
            .map({ $0.count > 0 })
        
        let observer: Binder<Bool> = Binder(usernameValidOutlet) { (view, isHidden) in
            view.isHidden = isHidden
        }
        
        userNameValid
            .bind(to: observer)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - 复用
extension Reactive where Base: UIView {
    public var isHidden: Binder<Bool> {
        return Binder(self.base) { view, hidden in
            view.isHidden = hidden
        }
    }
}

extension Reactive where Base: UIControl {
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.isEnabled = value
        }
    }
}
