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
    
    var interval: Observable<Int>!
    var subsription: Disposable!
    var bag: DisposeBag! = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        example1()
//        example2()
        example3()
    }

//    func example1() {
//        let eventNumberObservable = Observable.from(["1", "2", "3", "4", "5"]).map({ Int($0) })
//            .filter {
//                if let int = $0, int % 2 == 0 {
//                    return true
//                }
//
//                return false
//        }
//
////        eventNumberObservable.subscribe{ event in
////            print("Event: \(event)")
////        }
//        let disposeBag = DisposeBag()
//        eventNumberObservable.subscribe(onNext: { event in
//            print(event)
//        }).disposed(by: disposeBag)
//
//    }
    
//    func example2() {
//        var bag = DisposeBag()
//
//        let disposable = Observable<Int>.interval(1, scheduler: MainScheduler.instance).subscribe{
//            print($0)
//        }.disposed(by: bag)
//
//        delay(5) {
//            bag = DisposeBag()
//        }
//
//    }
//
//    func delay(_ time: Double, _ block: @escaping () -> ()) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
//            block()
//        }
//    }
    
    func example3() {
        self.interval = Observable.interval(0.5, scheduler: MainScheduler.instance)
        
        self.subsription = self.interval.map({ String($0) })
            .subscribe(onNext: { (string) in
                print(string)
            })
        self.subsription.disposed(by:bag)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bag = nil
    }

}

