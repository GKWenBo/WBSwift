//
//  DriverTests.swift
//  DemoTests
//
//  Created by wenbo on 2020/12/7.
//

import XCTest
import RxSwift
import RxCocoa

/*
 “Driver（司机？） 是一个精心准备的特征序列。它主要是为了简化 UI 层的代码。不过如果你遇到的序列具有以下特征，你也可以使用它：

 不会产生 error 事件
 一定在 MainScheduler 监听（主线程监听）
 共享附加作用
 这些都是驱动 UI 的序列所具有的特征。”
 
 “任何可监听序列都可以被转换为 Driver，只要他满足 3 个条件：

 不会产生 error 事件
 一定在 MainScheduler 监听（主线程监听）
 共享附加作用”
 
 “asDriver(onErrorJustReturn: []) 相当于以下代码：

 let safeSequence = xs
   .observeOn(MainScheduler.instance)       // 主线程监听
   .catchErrorJustReturn(onErrorJustReturn) // 无法产生错误
   .share(replay: 1, scope: .whileConnected)// 共享附加作用
 return Driver(raw: safeSequence)           // 封装”

 摘录来自: Unknown. “RxSwift 中文文档。” Apple Books.
 */

class DriverTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    /// 模拟代码
    func testCommonBind() {
        let query = UITextField()
        let resultsTableView = UITableView()
        let resultCount = UILabel()
        
        
        let results = query.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest({ [unowned self] query in
                fetchAutoCompleteItems(query: query)
            })
        
        results
            .map({ "\($0.count)"})
            .bind(to: resultCount.rx.text)
            .disposed(by: disposeBag)
        
        results
            .bind(to: resultsTableView.rx.items(cellIdentifier: "cell")) { (_, result, cell) in
                cell.textLabel?.text = "\(result)"
            }
            .disposed(by: disposeBag)
    }
    
    /// “更好的方案”
    func testCommonBind1() {
        let query = UITextField()
        let resultsTableView = UITableView()
        let resultCount = UILabel()
        
        
        let results = query.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest({ [unowned self] query in
                fetchAutoCompleteItems(query: query)
            })
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn([])
            .share(replay: 1, scope: .whileConnected)
        
        results
            .map({ "\($0.count)"})
            .bind(to: resultCount.rx.text)
            .disposed(by: disposeBag)
        
        results
            .bind(to: resultsTableView.rx.items(cellIdentifier: "cell")) { (_, result, cell) in
                cell.textLabel?.text = "\(result)"
            }
            .disposed(by: disposeBag)
    }
    
    func testDriver() {
        let query = UITextField()
        let resultsTableView = UITableView()
        let resultCount = UILabel()
        
        let results = query.rx
            .text
            .asDriver()
            .throttle(0.3)
            .flatMapLatest({ [unowned self] query in
                fetchAutoCompleteItems(query: query)
                    .asDriver(onErrorJustReturn: [])
            })
        
        results
            .map({ "\($0.count)" })
            .drive(resultCount.rx.text)
            .disposed(by: disposeBag)
        
        results
            .drive(resultsTableView.rx.items(cellIdentifier: "celll")) { (_, result, cell) in
                cell.textLabel?.text = result
            }
            .disposed(by: disposeBag)
    }
        
    func fetchAutoCompleteItems(query: String?) -> Observable<[String]> {
        return Observable.create { (observer) -> Disposable in
            
            observer.onNext(["test"])
            
            return Disposables.create()
        }
    }
}
