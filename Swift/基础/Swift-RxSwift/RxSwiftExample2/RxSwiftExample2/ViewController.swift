//
//  ViewController.swift
//  RxSwiftExample2
//
//  Created by WenBo on 2019/9/6.
//  Copyright © 2019 wenbo. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    struct TestError: Error {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        example1()
//        example2()
//        example3()
//        example4()
//        example5()
//        example6()
//        example7()
//        example8()
//        example9()
//        example10()
//        example12()
//        example13()
        example14()
    }
    
    //MARK: 操作符
    
    //MARK: catchError
    func example1() {
        let bag = DisposeBag()
        /*
         catchError 操作符将会拦截一个 error 事件，将它替换成其他的元素或者一组元素，然后传递给观察者。这样可以使得 Observable 正常结束，或者根本都不需要结束。
         */
        let sequenceThatFails = PublishSubject<String>()
        let recoverySequence = PublishSubject<String>()
        
        sequenceThatFails
            .catchError({
                print("Error: \($0)")
                return recoverySequence
            })
            .subscribe({
                print($0)
            })
            .disposed(by: bag)
        
        sequenceThatFails.onNext("😬")
        sequenceThatFails.onNext("😨")
        sequenceThatFails.onNext("😡")
        sequenceThatFails.onNext("🔴")
        sequenceThatFails.onError(TestError())
        recoverySequence.onNext("😊")
    }
    
    //MARK: catchErrorJustReturn
    func example2() {
        /*catchErrorJustReturn 操作符会将error 事件替换成其他的一个元素，然后结束该序列。*/
        let bag = DisposeBag()
        let sequenceThatFails = PublishSubject<String>()
        sequenceThatFails
            .catchErrorJustReturn("😆")
            .subscribe({
                print($0)
            })
            .disposed(by: bag)
        
        sequenceThatFails.onNext("😬")
        sequenceThatFails.onNext("😨")
        sequenceThatFails.onNext("😡")
        sequenceThatFails.onNext("🔴")
        sequenceThatFails.onError(TestError())
    }
    
    //MARK: combineLatest
    func example3() {
        /*
         当多个 Observables 中任何一个发出一个元素，就发出一个元素。这个元素是由这些 Observables 中最新的元素，通过一个函数组合起来的
         */
        let bag = DisposeBag()
        let first = PublishSubject<String>()
        let second = PublishSubject<String>()
        
        Observable.combineLatest(first, second){
                $0 + $1
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: bag)
        
        first.onNext("1")
        second.onNext("A")
        first.onNext("2")
        second.onNext("B")
        second.onNext("C")
        second.onNext("D")
        first.onNext("3")
        first.onNext("4")
    }
    
    //MARK: concat
    func example4() {
       /*
         让两个或多个 Observables 按顺序串连起来
         concat 操作符将多个 Observables 按顺序串联起来，当前一个 Observable 元素发送完毕后，后一个 Observable 才可以开始发出元素。
         */
        let bag = DisposeBag()
        
        let subject1 = BehaviorSubject(value: "🍎")
        let subject2 = BehaviorSubject(value: "🐩")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .concat()
            .subscribe({
                print($0)
            })
            .disposed(by: bag)
        
        subject1.onNext("🍐")
        subject1.onNext("🍊")
        
        variable.value = subject2
        
        subject2.onNext("I would be ignored")
        subject2.onNext("🐱")
        
        subject1.onCompleted()
        
        subject2.onNext("🐭")
    }
    
    //MARK: concatMap
    /*
     将 Observable 的元素转换成其他的 Observable，然后将这些 Observables 串连起来
     concatMap 操作符将源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。然后让这些 Observables 按顺序的发出元素，当前一个 Observable 元素发送完毕后，后一个 Observable 才可以开始发出元素。等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。
     */
    func example5() {
        let bag = DisposeBag()
        
        let subject1 = BehaviorSubject(value: "🍎")
        let subject2 = BehaviorSubject(value: "🐶")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .concatMap { $0 }
            .subscribe { print($0) }
            .disposed(by: bag)
        
        subject1.onNext("🍐")
        subject1.onNext("🍊")
        
        variable.value = subject2
        
        subject2.onNext("I would be ignored")
        subject2.onNext("🐱")
        
        subject1.onCompleted()
        
        subject2.onNext("🐭")
    }
    
    //MARK: connect
    func example6() {
        /*
         ConnectableObservable 和普通的 Observable 十分相似，不过在被订阅后不会发出元素，直到 connect 操作符被应用为止。这样一来你可以等所有观察者全部订阅完成后，才发出元素。
         */
        let intSequence = Observable<Int>.interval(.seconds(1) , scheduler: MainScheduler.instance)
            .publish()
        
        _ = intSequence
            .subscribe(onNext: {
                print("Subscription 1:, Event: \($0)")
            })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            _ = intSequence.connect()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            _ = intSequence
                .subscribe(onNext: { print("Subscription 2:, Event: \($0)") })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            _ = intSequence
                .subscribe(onNext: { print("Subscription 3:, Event: \($0)") })
        }
    }
    
    //MARK: create
    func example7() {
        let bag = DisposeBag()
        let observable = Observable<Int>.create { (observer) -> Disposable in
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onCompleted()
            return Disposables.create()
        }
        
        observable.subscribe({
            print($0)
        })
            .disposed(by: bag)
    }
    
    //MARK: debug
    func example8() {
        let bag = DisposeBag()
        
        let sequence = Observable<Int>.create { (observer) -> Disposable in
            observer.onNext(1)
            observer.onNext(2)
            observer.onCompleted()
            return Disposables.create()
        }
        
        sequence
            .debug()
            .subscribe({
                print($0)
            })
            .disposed(by: bag)
    }
    
    //MARK: distinctUntilChanged
    func example9() {
        /*
         distinctUntilChanged 操作符将阻止 Observable 发出相同的元素。如果后一个元素和前一个元素是相同的，那么这个元素将不会被发出来。如果后一个元素和前一个元素不相同，那么这个元素才会被发出来。
         */
        let bag = DisposeBag()
        Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱")
            .distinctUntilChanged()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: bag)
    }
    
    //MARK: empty
    /*
     empty 操作符将创建一个 Observable，这个 Observable 只有一个完成事件
     */
    func example10() {
        let observable = Observable<Int>.empty()
        
        //相当于
        let id = Observable<Int>.create { (observer) -> Disposable in
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    //MARK: error
    /*
     error 操作符将创建一个 Observable，这个 Observable 只会产生一个 error 事件。
     */
    func example11() {
        let error: TestError = TestError()
        let _ = Observable<Int>.error(error)
        
        //相当于
        let _ = Observable<Int>.create { (observer) -> Disposable in
            observer.onError(error)
            return Disposables.create()
        }
        
    }
    
    //MARK: filter
    /*
     filter 操作符将通过你提供的判定方法过滤一个 Observable
     */
    func example12() {
        let bag = DisposeBag()
        
        Observable.of(1, 2, 3, 4 , 6)
            .filter({ $0 > 4})
            .subscribe(onNext: { print($0) })
            .disposed(by: bag)
    }
    
    //MARK: flatMap
    /*
     flatMap 操作符将源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。
     
     这个操作符是非常有用的，例如，当 Observable 的元素本身拥有其他的 Observable 时，你可以将所有子 Observables 的元素发送出来。
     */
    func example13() {
        let bag = DisposeBag()
        
        let first = BehaviorSubject(value: "👦")
        let second = BehaviorSubject(value: "👧")
        
        let variable = Variable(first)
        
        variable.asObservable()
            .flatMap({ $0 })
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: bag)
        
        first.onNext("🐱")
        variable.value = second
        second.onNext("🅱️")
        first.onNext("🐶")
    }
    
    //MARK: flatMapLatest
    /*
     flatMapLatest 操作符将源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。一旦转换出一个新的 Observable，就只发出它的元素，旧的 Observables 的元素将被忽略掉。
     */
    func example14() {
        let bag = DisposeBag()
        
        let first = BehaviorSubject(value: "👦")
        let second = BehaviorSubject(value: "👧")
        
        let variable = Variable(first)
        
        variable.asObservable()
            .flatMapLatest({ $0 })
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: bag)
        
        first.onNext("🐱")
        variable.value = second
        second.onNext("🅱️")
        first.onNext("🐶")
    }
    
    //MARK: from
    /*
     当你在使用 Observable 时，如果能够直接将其他类型转换为 Observable，这将是非常省事的。from 操作符就提供了这种功能
     */
    func example15() {
        let _ = Observable.from([1, 2, 3])
        //相当于
        let _ = Observable<Int>.create { (oberver) -> Disposable in
            oberver.onNext(0)
            oberver.onNext(1)
            oberver.onNext(2)
            oberver.onCompleted()
            return Disposables.create()
        }
        
        //可选值
        let optional: Int? = 1
        let _ = Observable.from(optional: optional)
        
        //相当于
        let _ = Observable<Int>.create { (observer) -> Disposable in
            if let element = optional {
                observer.onNext(element)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    //MARK: just
    /*
     just 操作符将某一个元素转换为 Observable
     */
    func example16() {
        let _ = Observable.just(6)
        
        //相当于
        let _ = Observable<Int>.create { (observer) -> Disposable in
            
            return Disposables.create()
        }
        
    }
}

