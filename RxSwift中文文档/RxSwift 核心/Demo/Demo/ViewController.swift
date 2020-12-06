//
//  ViewController.swift
//  Demo
//
//  Created by WENBO on 2020/12/6.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let bag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - 如何创建序列
    func create1() {
        let numbers = Observable<Int>.create { (oberver) -> Disposable in
            oberver.onNext(1)
            oberver.onCompleted()
            return Disposables.create()
        }
    }
    
    // 闭包回调
    func create2() {
        typealias JSON = Any
        
        enum DataError: Error {
            case cantParseJSON
        }
        
        let json = Observable<JSON>.create { (observer) -> Disposable in
            
            let task = URLSession.shared.dataTask(with: URL(string: "test.com")!) { (data, response, error) in
                guard error == nil else {
                    observer.onError(error!)
                    return
                }
                
                guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else {
                    observer.onError(DataError.cantParseJSON)
                    return
                }
                
                observer.onNext(jsonObject)
                observer.onCompleted()
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        
        json.subscribe { (json) in
            print(json)
        }
        onError: { (error) in
            print(error)
        }
        onCompleted: {
            
        }
        .disposed(by: bag)

        
    }
}

