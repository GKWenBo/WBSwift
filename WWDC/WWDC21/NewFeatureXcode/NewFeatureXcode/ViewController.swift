//
//  ViewController.swift
//  NewFeatureXcode
//
//  Created by WENBO on 2021/11/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buildString()
    }
    
    // MARK: - 自动导入
    /*
     如果你在编写代码时使用了当前不可用的类型，Xcode 会自动帮你导入相关的框架。比如，如果你编写下面这样的代码：
     */
    func testAutoImport() {
        
    }

    // MARK: - 解包语句自动补全
    func greet(name: String?) {
//        if let name = name {
//
//        }
    }
    // MARK: - 更深路径的自动补全
    func path() {
        let view = UIView()
//        view.layer.cornerRadius
        
    }
    
    // MARK: - Switch case 自动补全
    enum Color {
        case red, green, orange
    }
    func testSwitch(color: Color) {
//        switch color {
//        case .red:
//            <#code#>
//        case .green:
//            <#code#>
//        case .orange:
//            <#code#>
//        }
    }
    
    // MARK: - 数组遍历语句自动补全
    func testFor() {
        let names = ["1", "2", "3"]
//        for name in names {
//
//        }
    }
    
    // MARK: - 列断点
    func first() -> String { "A" }
    func second() -> String { "B" }
    func third() -> String { "C" }
    func buildString() {
        first() + second() + second()
    }
}

