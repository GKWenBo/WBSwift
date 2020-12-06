//
//  ViewController.swift
//  example2
//
//  Created by WENBO on 2020/8/17.
//  Copyright © 2020 WENBO. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class InputValidator {
    class func isValidEmail(email: String) -> Bool {
        let re = try? NSRegularExpression(pattern: "^\\S+@\\S+\\.\\S+$",
                                          options: .caseInsensitive)
        
        if let re = re {
            let range = NSMakeRange(0,
                                    email.lengthOfBytes(using: .utf8))
            
            let result = re.matches(in: email,
                                    options: .reportProgress,
                                    range: range)
            
            return result.count > 0
        }
        return false
    }
    
    class func isValidPassword(password: String) -> Bool {
        return password.count >= 8
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    var bag = DisposeBag()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.emailTF.layer.borderWidth = 1
        self.passwordTF.layer.borderWidth = 1
        
//        example1()
//        example2()
//        example3()
        example4()
    }
    
//    func example1() {
//        let emailObservable = self.emailTF.rx.text.orEmpty.map({ (input: String) -> Bool  in
//            return InputValidator.isValidEmail(email: input)
//        })
//
//        emailObservable.map({ (valid: Bool) -> UIColor in
//            let color = valid ? UIColor.green : UIColor.clear
//            return color
//        })
//        .subscribe(onNext: {
//                self.emailTF.layer.borderColor = $0.cgColor
//        })
//        .disposed(by: bag)
//
//        /// passwordObservable
//        let passwordObservable = self.passwordTF.rx.text.orEmpty.map({ (input: String) -> Bool  in
//            return InputValidator.isValidPassword(password: input)
//        })
//
//        passwordObservable.map({ (valid: Bool) -> UIColor in
//            let color = valid ? UIColor.green : UIColor.clear
//            return color
//        })
//        .subscribe(onNext: {
//                self.passwordTF.layer.borderColor = $0.cgColor
//        })
//        .disposed(by: bag)
//
//        /// button
//        Observable.combineLatest(emailObservable,
//                                 passwordObservable) { (validEmail: Bool, validPassword: Bool) -> [Bool] in
//                                    return [validEmail, validPassword]
//        }
//        .map({ (input: [Bool]) -> Bool in
//            let validValues = input.reduce(true, { $0 && $1 })
//            return validValues
//        })
//        .subscribe(onNext: { (isEnabled) in
//            self.registerBtn.isEnabled = isEnabled
//        })
//        .disposed(by: bag)
//
//        registerBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [unowned self] in
//            let vc = Test1ViewController()
//            self.present(vc, animated: true, completion: nil)
//        }).disposed(by: bag)
//    }
//
//    func example2() {
//        let observableInt: Observable<Int> = Observable.create { (observer) -> Disposable in
//            observer.onNext(1)
//            observer.onNext(2)
//            observer.onNext(3)
//            observer.onCompleted()
//            return Disposables.create()
//        }
//
//
//        observableInt.subscribe { (number) in
//            print(number)
//        }.disposed(by: bag)
//
//    }
//
//    func example3() {
//        typealias JSON = Any
//
//        enum CustomError: Error {
//            case cantParseJSON
//        }
//
//        let json: Observable<JSON> = Observable.create { (oberver) -> Disposable in
//
//            let dataTask = URLSession.shared.dataTask(with: URL(string: "www.baidu.com")!) { (data, _, error) in
//
//                guard error == nil else {
//                    oberver.onError(error as! Error)
//                    return
//                }
//
//                guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
//                    oberver.onError(CustomError.cantParseJSON)
//                    return
//                }
//
//                oberver.onNext(jsonObject)
//                oberver.onCompleted()
//            }
//
//            return Disposables.create { dataTask.cancel() }
//        }
//
//
//        json.subscribe(onNext: { (json) in
//            print("取得 json 成功: \(json)")
//        },
//                       onError: { (error) in
//
//        },
//                       onCompleted: {
//                        print("取得 json 任务成功完成")
//        }).disposed(by: bag)
//    }

    
    /// Single
    /*  发出一个元素，或一个 error 事件
        不会共享附加作用 */
    func example4() {
        getRepo().subscribe(onSuccess: { (json) in
            print(json)
        }) { (error) in
            
        }.disposed(by: bag)
    }
    
    func getRepo() -> Single<[String : Any]> {
        return Single<[String : Any]>.create { (singe) -> Disposable in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                singe(.success(["成功" : "数据"]))
            }
            
            return Disposables.create()
        }
    }
}

