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
        
        buttonTap()
    }

    // MARK: - Target Action
    func buttonTap() {
        let button = UIButton()
        
        button.rx
            .tap
            .subscribe(onNext: {
                
            })
            .disposed(by: bag)
    }
    
    // MARK: - 代理
    func scrollView() {
        let scrollView = UIScrollView()
        scrollView.rx
            .contentOffset
            .subscribe(onNext: { contentOffset in
                
            })
            .disposed(by: bag)
    }
    
    // MARK: - 闭包回调
    func network() {
        let url = "www.test.com"
        
        URLSession.shared.rx
            .data(request: URLRequest(url: URL(string: url)!))
            .subscribe { (data) in
                
            }
            onError: { (error) in
                
            }
            onCompleted: {
                
            }
            .disposed(by: bag)
    }
    
    // MARK: - 通知
    func notification() {
        NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .subscribe { (notification) in
                
            }
            .disposed(by: bag)

    }
    
    // MARK: - “多个任务之间有依赖关系”
    func moreTask() {
        
        struct UserInfo {
            
        }
        
        enum API {
            
            static func token(username: String, password: String) -> Observable<String> {
                return Observable<String>.create { (observable) -> Disposable in
                    
                    observable.onNext("json")
                    return Disposables.create()
                }
            }
            
            static func userInfo(token: String) -> Observable<UserInfo> {
                return Observable.create { (observer) -> Disposable in
                    observer.onNext(UserInfo())
                    return Disposables.create()
                }
            }
        }
        
        API.token(username: "aaa", password: "123456")
            .flatMapLatest(API.userInfo)
            .subscribe { (userInfo) in
                print(userInfo)
            }
            .disposed(by: bag)
    }
    
    // MARK: - “等待多个并发任务完成后处理结果”
    func zipTask() {
        struct Teacher {
            
        }
        
        struct Comment {
            
        }
        
        enum API {
            static func teacher(teacherId: Int) -> Observable<[Teacher]> {
                return Observable.create { (observer) -> Disposable in
                    observer.onNext([Teacher()])
                    return Disposables.create()
                }
            }
            
            static func tearchComments(teacherId: Int) -> Observable<[Comment]> {
                return Observable.create { (observer) -> Disposable in
                    observer.onNext([Comment()])
                    return Disposables.create()
                }
            }
        }
        
        
        Observable.zip(API.teacher(teacherId: 1),
                       API.tearchComments(teacherId: 1))
            .subscribe { (teacher, comment) in
                
            }
            onError: { (error) in
                
            }
            .disposed(by: bag)

    }
}

