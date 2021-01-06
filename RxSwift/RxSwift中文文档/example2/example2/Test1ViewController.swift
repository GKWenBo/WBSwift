//
//  Test1ViewController.swift
//  example2
//
//  Created by wenbo on 2020/8/18.
//  Copyright © 2020 WENBO. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Test1ViewController: UIViewController {

    let minimalUsernameLength: Int = 2
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var enterBtn: UIButton!
    var disposeable: Disposable!
    
    deinit {
        disposeable.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let userNameValidObservable = textField.rx.text.orEmpty.map({ (input: String) -> Bool in
            return input.lengthOfBytes(using: .utf8) >= self.minimalUsernameLength
        })
        
        disposeable = userNameValidObservable
            .subscribeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.instance)
            .bind(to: enterBtn.rx.isHidden)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
