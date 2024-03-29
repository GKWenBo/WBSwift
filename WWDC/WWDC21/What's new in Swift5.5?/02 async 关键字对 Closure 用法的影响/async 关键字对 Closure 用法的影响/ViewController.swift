//
//  ViewController.swift
//  async 关键字对 Closure 用法的影响
//
//  Created by WENBO on 2021/11/20.
//

/*
 1、async 对函数重载的影响
 2、async对Closure用法的影响
 */

import UIKit

struct Dinner {
    
    /// 修饰初始化方法
    init() async {
        print("Plan the menu.")
    }
    
    func chopVegetable() async {
        print("Chopping vegetables")
    }
    
    func marinateMeat() async throws {
        print("Marinate meat")
    }
    
    // MARK: - 1、async 对函数重载的影响
    /*
     Swift采取了更加精致的策略，编译器会判断调用函数时的上下文环境。在同步环境中选择同步的版本，异步的环境中选择异步的版本。
     */
    func preheatOven(_ completionHandler: (() -> Void)? = nil) {
        print("Preheat oven with completion handler.")
    }
    
    func preheatOven() async {
        print("Preheat oven asynchronously.")
    }
    
    func cook(_ process: () async -> Void) async {
        await process()
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*
         { () async -> Void in
             
         }
         */
        
        Task {
            let dinner = await Dinner()
            
            await dinner.cook({ () async -> Void in // implicitly async
                await dinner.chopVegetable()
                try? await dinner.marinateMeat()
                await dinner.preheatOven()
            })
            
            // 或者
            await dinner.cook { // implicitly async
                await dinner.chopVegetable()
                try? await dinner.marinateMeat()
                await dinner.preheatOven()
            }
            
            // 或则
            await dinner.cook(myCook)
        }
    }

    func myCook() async {
        print("My own cooking approach.")
    }

}

