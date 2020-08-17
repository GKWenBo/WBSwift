//
//  ViewController.swift
//  Example1
//
//  Created by WENBO on 2020/8/4.
//  Copyright © 2020 WENBO. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        example1()
        example2()
    }

    func example1() {
        let eventNumberObservable = Observable.from(["1", "2", "3", "4", "5"]).map({ Int($0) })
            .filter {
                if let int = $0, int % 2 == 0 {
                    return true
                }
                
                return false
        }
        
//        eventNumberObservable.subscribe{ event in
//            print("Event: \(event)")
//        }
        let disposeBag = DisposeBag()
        eventNumberObservable.subscribe(onNext: { event in
            print(event)
        }).disposed(by: disposeBag)
        
    }
    
    func example2() {
        var bag = DisposeBag()
                
        let disposable = Observable<Int>.interval(1, scheduler: MainScheduler.instance).subscribe{
            print($0)
        }.disposed(by: bag)
        
        delay(5) {
            bag = DisposeBag()
        }
        
    }
    
    func delay(_ time: Double, _ block: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            block()
        }
    }

}

