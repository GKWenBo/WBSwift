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
        
        let emailObservable = self.emailTF.rx.text.orEmpty.map({ (input: String) -> Bool  in
            return InputValidator.isValidEmail(email: input)
        })
        
        emailObservable.map({ (valid: Bool) -> UIColor in
            let color = valid ? UIColor.green : UIColor.clear
            return color
        })
        .subscribe(onNext: {
                self.emailTF.layer.borderColor = $0.cgColor
        })
        .disposed(by: bag)
        
        /// passwordObservable
        let passwordObservable = self.passwordTF.rx.text.orEmpty.map({ (input: String) -> Bool  in
            return InputValidator.isValidPassword(password: input)
        })
        
        passwordObservable.map({ (valid: Bool) -> UIColor in
            let color = valid ? UIColor.green : UIColor.clear
            return color
        })
        .subscribe(onNext: {
                self.passwordTF.layer.borderColor = $0.cgColor
        })
        .disposed(by: bag)
        
        /// button
        Observable.combineLatest(emailObservable,
                                 passwordObservable) { (validEmail: Bool, validPassword: Bool) -> [Bool] in
                                    return [validEmail, validPassword]
        }
        .map({ (input: [Bool]) -> Bool in
            let validValues = input.reduce(true, { $0 && $1 })
            return validValues
        })
        .subscribe(onNext: { (isEnabled) in
            self.registerBtn.isEnabled = isEnabled
        })
        .disposed(by: bag)
    }


}

