//
//  ViewController.swift
//  async 关键字对 Swift 函数用法的影响
//
//  Created by WENBO on 2021/11/20.
//

/*
 1、那些函数可以定义成异步的
 2、定义可以抛出异常的异步函数
 3、异步 init 方法在继承关系中的用法
 4、async 对函数重载的影响
 5、和 async 相关的类型转换
 6、协议中的 async 约束
 */

import UIKit

// MARK: - 那些函数可以定义成异步的
/*
 1.全局函数是可以的
 2.第二类可以标记为 async 的，是自定义类型的 init 或者普通方法
 
 但要特别注意：
 deinit，下标操作符以及属性的 getter 和 setter 都不能标记为 async
 */

struct Dinner {
    
    /// 修饰初始化方法
    init() async {
        print("Plan the menu.")
    }
    
    func chopVegetable() {
        print("Chopping vegetables")
    }
    
    // MARK: - 定义可以抛出异常的异步函数
    func marinateMeat() async throws {
        print("Marinate meat")
    }
    
    // MARK: - async 对函数重载的影响
    /*
     Swift 采取了更加精致的策略，编译器会判断调用函数时的上下文环境。在同步环境中选择同步的版本，异步的环境中选择异步的版本。
     */
    func preheatOven(_ completionHandler: (() -> Void)? = nil) {
        print("Preheat oven with completion handler.")
    }
    
    func preheatOven() async {
        print("Preheat oven asynchronously.")
    }
}

// MARK: - 异步 init 方法在继承关系中的用法
/*
 基类中不会同时存在同步和异步的 init 方法
 */
class Tableware {
    var color: String
    var shape: String
    
    init(color: String = "white", shape: String = "round") {
        self.color = color
        self.shape = shape
        print("Prepare tableware: Color:\(color), Shape:\(shape)")
    }
}

class Dish: Tableware {
    /*
     异步的 init 方法调用了基类中同步的默认 init 方法。
     */
    init() async {
        print("Disinfection the dish before use.")
    }
}

// MARK: - 和 async 相关的类型转换
/*
 这个问题的答案，和 throws 有些类似：同步可以向异步转换，反之则不行
 */
struct FunctionTypes {
  var syncNonThrowing: () -> Void
  var syncThrowing: () throws -> Void
  var asyncNonThrowing: () async -> Void
  var asyncThrowing: () async throws -> Void
  
  mutating func demonstrateConversions() {
    // Okay to add 'async' and/or 'throws'
    asyncNonThrowing = syncNonThrowing
    asyncThrowing = syncThrowing
    syncThrowing = syncNonThrowing
    asyncThrowing = asyncNonThrowing
    
    // Error to remove 'async' or 'throws'
//    syncNonThrowing = asyncNonThrowing // error
//    syncThrowing = asyncThrowing       // error
//    syncNonThrowing = syncThrowing     // error
//    asyncNonThrowing = syncThrowing    // error
  }
}

// MARK: - 协议中的 async 约束
/*
 nc，那么这个约束可以由同步或异步函数实现。否则，就只能由同步方式实现。
 */
protocol Cook {
  func chopVegetable() async
  func marinateMeat() async
  func preheatOven() async
  func serve() // Can only be satisfied by a synchronous function
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // MARK: - 调用
        Task {
            let dinner = await Dinner()
            try await dinner.marinateMeat()
            
            await dinner.preheatOven()
            
            _ = await Dish()
        }
    }
}

