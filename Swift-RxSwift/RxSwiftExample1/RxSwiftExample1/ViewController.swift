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
//        example1()
//        example2()
//        example3()
//        example4()
//        example5()
//        example6()
//        example7()
//        example8()
        example9()
    }

    //MARK: 创建observable序列
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

    //MARK: 理解Observable dispose
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
    
    enum CustomError: Error {
        case somethingWrong
    }
    
    //MARK: 理解create和debug operator
    func example2() {
        let customOb = Observable<Int>.create { (observer) -> Disposable in
            observer.onNext(1)
            observer.onError(CustomError.somethingWrong)
            //completed event
            observer.onCompleted()
            return Disposables.create()
        }
        
        //do
        let bag = DisposeBag()
//        customOb.do(onNext: {
//            print("Intercepted: \($0)")
//        },onError: {
//            print("Intercepted: \($0)")
//        },
//          onCompleted: {
//            print("Intercepted: Completed")
//        },
//          onDispose: {
//            print("Intercepted: Game over")
//        }).subscribe(onNext: {
//            print($0)
//        },
//                           onError: {
//                            print($0)
//        },
//                           onCompleted: {
//                            print("Completed")
//        },
//                           onDisposed: {
//                            print("Game over")
//        }).disposed(by: bag)
        customOb.debug().subscribe(onNext: {
            print($0)
        },
                     onError: {
                        print($0)
        },
                     onCompleted: {
                        print("Completed")
        },
                     onDisposed: {
                        print("Game over")
        }).disposed(by: bag)
    }
    
    //MARK: 四种Subject的基本用法
    func example3() {
        //PublishSubject
        let subject = PublishSubject<String>()
        
        let sub1 = subject.subscribe(onNext: {
            print("Sub1 - what happened: \($0)")
        })
        
        subject.onNext("Episode1 updated")
        sub1.dispose()
        
        let sub2 = subject.subscribe({
            print("Sub2 - what happened: \($0)")
        })
        
        subject.onNext("Episode2 updated")
        subject.onNext("Episode3 updated")
        
        sub2.dispose()
    }
    
    func example4() {
        //BehaviorSubject
        /*
         如果你希望Subject从“会员制”变成“试用制”，就需要使用BehaviorSubject。它和PublisherSubject唯一的区别，就是只要有人订阅，它就会向订阅者发送最新的一次事件作为“试用”。
         */
        let subject = BehaviorSubject<String>(value: "RxSwift step by step")
        let sub1 = subject.subscribe(onNext: {
            print("Sub1 - what happened: \($0)")
        })
        subject.onNext("Episode1 updated")
        
        let sub2 = subject.subscribe(onNext: {
            print("Sub2 - what happened: \($0)")
        })
    }
    
    func example5() {
        //ReplaySubject
        /*
         ReplaySubject的行为和BehaviorSubject类似，都会给订阅者发送历史消息。不同地方有两点：
         
         ReplaySubject没有默认消息，订阅空的ReplaySubject不会收到任何消息；
         ReplaySubject自带一个缓冲区，当有订阅者订阅的时候，它会向订阅者发送缓冲区内的所有消息；
         */
        
        //ReplaySubject缓冲区的大小，是在创建的时候确定的
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        let sub1 = subject.subscribe(onNext: {
            print("Sub1 - what happened: \($0)")
        })
        
        subject.onNext("Episode1 updated")
        subject.onNext("Episode2 updated")
        subject.onNext("Episode3 updated")
        
        let sub2 = subject.subscribe(onNext: {
            print("Sub2 - what happened: \($0)")
        })
    }
    
    func example6() {
        //Variable
        /*
         除了事件序列之外，在平时的编程中我们还经常需遇到一类场景，就是需要某个值是有“响应式”特性的，例如可以通过设置这个值来动态控制按钮是否禁用，是否显示某些内容等。为了方便这个操作，RxSwift还提供了一个特殊的subject，叫做Variable。
         */
        let stringVariable = Variable("Episode1")
        let sub1 = stringVariable.asObservable()
                .asObservable()
            .subscribe({
                print("sub1: \($0)")
            })
        
        stringVariable.value = "Episode2"
    }
    
    //MARK: 常用的忽略事件操作符
    func example7() {
        //MARK: Ignore elements
        /*
         第一个要介绍的operator是ignoreElements，它会忽略序列中所有的.next事件
         */
//        let tasks = PublishSubject<String>()
//        let bag = DisposeBag()
//
//        tasks.ignoreElements().subscribe({
//            print($0)
//        }).disposed(by: bag)
//
//        tasks.onNext("T1");
//        tasks.onNext("T2");
//        tasks.onNext("T3");
//        tasks.onCompleted();
//
        //MARK: skip
        /*除了一次性忽略所有的.next之外，我们还可以选择忽略事件序列中特定个数的.next。例如，在我们的例子里，假设队列中前两个任务都是流水线上其它人完成的，而你只需要完成第三个任务，就可以这样*/
        
//        let tasks = PublishSubject<String>()
//        let bag = DisposeBag()
//
//        tasks.skip(2).subscribe({
//            print($0)
//        }).disposed(by: bag)
//
//        tasks.onNext("T1");
//        tasks.onNext("T2");
//        tasks.onNext("T3");
//        tasks.onCompleted();
        
        //MARK: skipWhile
        /*
         除了可以忽略指定个数的事件外，我们还可以通过一个closure自定义忽略的条件，这个operator叫做skipWhile。但它和我们想象中有些不同的是，它不会“遍历”事件序列上的所有事件，而是当遇到第一个不满足条件的事件之后，就不再忽略任何事件了
         */
//        let tasks = PublishSubject<String>()
//        let bag = DisposeBag()
//
//        tasks.skipWhile({
//            $0 != "T2"
//        }).subscribe({
//            print($0)
//        }).disposed(by: bag)
//
//        tasks.onNext("T1");
//        tasks.onNext("T2");
//        tasks.onNext("T3");
//        tasks.onCompleted();
        
        //MARK: skipUntil
        /*
         另外一个和skipWhile类似的operator是skipUntil，它不用一个closure指定忽略的条件，而是使用另外一个事件序列中的事件
         */
//        let tasks = PublishSubject<String>()
//        let bossIsAngry = PublishSubject<Void>()
//        let bag = DisposeBag()
//
//        tasks.skipUntil(bossIsAngry).subscribe({
//            print($0)
//        }).disposed(by: bag)
//
//        tasks.onNext("T1")
//        tasks.onNext("T2")
//        bossIsAngry.onNext(())
//        tasks.onNext("T3")
//        tasks.onCompleted()
        
        //MARK: distinctUntilChanged
        /*
         是通过distinctUntilChanged忽略序列中连续重复的事件
         */
        
        let tasks = PublishSubject<String>()
        let bag = DisposeBag()
        
        tasks.distinctUntilChanged()
            .subscribe {
                print($0)
            }
            .disposed(by:bag)
        
        tasks.onNext("T1")
        tasks.onNext("T2")
        tasks.onNext("T2")
        tasks.onNext("T3")
        tasks.onNext("T3")
        tasks.onNext("T4")
        tasks.onCompleted()
    }
    
    //MARK: 常用的获取事件操作符
    func example8() {
        //MARK: elementAt
        /*
         elementAt的参数和数组的索引一样，第一个任务的索引是0，而不是1
         */
//        let tasks = PublishSubject<String>()
//        let bag = DisposeBag()
//
//        tasks.elementAt(2)
//            .subscribe {
//                print($0)
//            }
//            .disposed(by:bag)
//
//        tasks.onNext("T1")
//        tasks.onNext("T2")
//        tasks.onNext("T2")
//        tasks.onNext("T3")
//        tasks.onNext("T3")
//        tasks.onNext("T4")
//        tasks.onCompleted()
        
        //MARK: filter
        /*
         除了用事件的索引来选择之外，我们也可以用一个closure设置选择事件的标准，这就是filter的作用，它会选择序列中所有满足条件的元素
         */
//        let tasks = PublishSubject<String>()
//        let bag = DisposeBag()
//
//        tasks.filter({
//            $0 == "T3"
//        })
//            .subscribe {
//                print($0)
//            }
//            .disposed(by:bag)
//
//        tasks.onNext("T1")
//        tasks.onNext("T2")
//        tasks.onNext("T2")
//        tasks.onNext("T3")
//        tasks.onNext("T3")
//        tasks.onNext("T4")
//        tasks.onCompleted()
        
        //MARK: take
        /*除了选择订阅单一事件之外，我们也可以选择一次性订阅多个事件*/
//        let tasks = PublishSubject<String>()
//        let bag = DisposeBag()
//
//        tasks.take(2)
//            .subscribe {
//                print($0)
//            }
//            .disposed(by:bag)
//
//        tasks.onNext("T1")
//        tasks.onNext("T2")
//        tasks.onNext("T2")
//        tasks.onNext("T3")
//        tasks.onNext("T3")
//        tasks.onNext("T4")
//        tasks.onCompleted()
        
        //MARK: takeWhile
        /*
         我们也可以用一个closure来指定“只要条件为true就一直订阅下去”这样的概念。例如，只要任务不是T3就一直订阅下去
         */
//        let tasks = PublishSubject<String>()
//        let bag = DisposeBag()
//
//        tasks.takeWhile({$0 != "T2"})
//            .subscribe {
//                print($0)
//            }
//            .disposed(by:bag)
//
//        tasks.onNext("T1")
//        tasks.onNext("T2")
//        tasks.onNext("T2")
//        tasks.onNext("T3")
//        tasks.onNext("T3")
//        tasks.onNext("T4")
//        tasks.onCompleted()

        //MARK: takeUntil
        /*
         除了使用closure表示订阅条件之外，我们也可以依赖另外一个外部事件，表达“直到某件事件发生前，一直订阅”这样的语义
         */
        let tasks = PublishSubject<String>()
        let boosHasGone = PublishSubject<Void>()
        let bag = DisposeBag()
        
        tasks.takeUntil(boosHasGone)
            .subscribe {
                print($0)
            }
            .disposed(by:bag)
        
        tasks.onNext("T1")
        tasks.onNext("T2")
        tasks.onNext("T2")
        tasks.onNext("T3")
        boosHasGone.onNext(())
        tasks.onNext("T3")
        tasks.onNext("T4")
        tasks.onCompleted()
    }
    
    //MARK: 了解常用的transform operators
    func example9() {
        //MARK: toArray
        let bag = DisposeBag()
//        Observable.of(1, 2, 3)
//                .toArray()
//            .subscribe({
//                // Array<Int>
//                print(type(of: $0))
//                // [1, 2, 3]
//                print($0)
//            }).disposed(by: bag)
        
//        let numbers = PublishSubject<Int>()
//
//        numbers.asObservable()
//            .toArray()
//            .subscribe({
//                print($0)
//            }).disposed(by: bag)
//
//        numbers.onNext(1)
//        numbers.onNext(2)
//        numbers.onNext(3)
//        numbers.onNext(4)
//        numbers.onCompleted()
        
        //MARK: scan
        /*
         第二个Transform operator是scan，在之前改进用户授权的代码里，我们已经用过它了
         */
//        Observable.of(1, 2, 3).scan(0) {accumulatedValue, value in
//            accumulatedValue + value
//            }.subscribe({
//                print($0)
//            }).disposed(by: bag)
        
//        let numbers = PublishSubject<Int>()
//        numbers.asObserver()
//            .scan(0) {
//                $0 + $1
//            }.subscribe({
//                print("Scan: \($0)")
//            }).disposed(by: bag)
//
//        numbers.onNext(1)
//        numbers.onNext(2)
//        numbers.onNext(3)
//        numbers.onNext(4)
        
        //MARK: 转换事件类型的map
//        Observable.of(1, 2, 3).map { value -> Int in
//                return value * 2
//            }.subscribe({
//                print($0)
//            }).disposed(by: bag)
        
        //mapWithIndex
        Observable.of(1, 2, 3).mapWithIndex { value, index in
                index < 1 ? value * 2 : value
            }.subscribe({
                print($0)
            }).disposed(by: bag)
    }
}

