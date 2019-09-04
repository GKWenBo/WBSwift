//
//  ViewController.swift
//  RxSwiftExample1
//
//  Created by 文波 on 2019/9/4.
//  Copyright © 2019 文波. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        example()
        example1()
    }

    
    func example() {
        let evenNumberObservable = Observable.of("1", "2", "3", "4", "5", "6", "7", "8")
                .map({
                    Int($0)
                })
                .filter({
                    if let item = $0, item % 2 == 0 {
                        print("Even \(item)")
                        return true
                    }
                    return false
                })
        
        evenNumberObservable.skip(2).subscribe({event in
            print("Event: \(event)")
        })
        
        //or
//        Observable.from(["1", "2", "3", "4", "5", "6", "7", "8"])
    }

    func example1()  {
        //理解Observable dispose
        
        var bag = DisposeBag()
        _ = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: {
            print(print("Subscribed: \($0)"))
        },onDisposed: {
            print(print("The queue was disposed."))
        })
        .disposed(by: bag)
//        dispatchMain()
        
        delay(5) { () -> (Void) in
//            disposable.dispose()
            bag = DisposeBag()
        }
    }
    
    
    public func delay(_ delay: Double, closure: @escaping () -> (Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
}

