//
//  ViewController.swift
//  Demo
//
//  Created by wenbo on 2021/11/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let _ = foo()
        
//        test()
        
        test()
    }

    // MARK: - 非结构化的并发
    /*
     非结构化的并发
     
     不过，程序的结构化并不意味着并发也是结构化的。相反，Swift 现存的并发模型面临的问题，恰恰和当年 goto 的情况类似。Swift 当前的并发手段，最常见的要属使用 Dispatch 库将任务派发，并通过回调函数获取结果：
     */
//    func foo() -> Bool {
//        bar(completion: { print($0) })
//        baz(completion: { print($0) })
//        return true
//    }
//
//    func bar(completion: @escaping (Int) -> Void) {
//        DispatchQueue.global().async {
//            completion(1)
//        }
//    }
//
//    func baz(completion: @escaping (Int) -> Void) {
//        DispatchQueue.global().async {
//            completion(2)
//        }
//    }
    
    // MARK: - 结构化并发
    /*
     如果要用一句话概括，那就是即使进行并发操作，也要保证控制流路径的单一入口和单一出口。程序可以产生多个控制流来实现并发，但是所有的并发路径在出口时都应该处于完成 (或取消) 状态，并合并到一起。
     */
    
    // MARK: - 基于 Task 的结构化并发模型
//    func test() {
//        withUnsafeCurrentTask { task in
//            // 1
//            print(task as Any)  // => nil
//        }
//
//        Task {
//            // 2
//            await foo()
//        }
//    }
//
//    func foo() async {
//        withUnsafeCurrentTask { task in
//            // 3
//            if let task = task {
//                // 4
//                print("Cancelled: \(task.isCancelled)")
//                // => Cancelled: false
//
//                print(task.priority)
//                // TaskPriority(rawValue: 33)
//            } else {
//                print("No task")
//            }
//        }
//
//        syncFunc()
//    }
//
//    func syncFunc() {
//        withUnsafeCurrentTask { task in
//            print(task as Any)
//        }
//    }
    
    // MARK: - 任务层级
    /*
     上例中虽然 t1 和 t2 是在外层 Task 中再新生成并进行并发的，但是它们之间没有从属关系，并不是结构化的。这一点从 t: false 先于其他输出就可以看出，t1 和 t2 的执行都是在外层 Task 闭包结束后才进行的，它们逃逸出去了，这和结构化并发的收束规定不符。

     想要创建结构化的并发任务，就需要让内层的 t1 和 t2 与外层 Task 具有某种从属关系。你可以已经猜到了，外层任务作为根节点，内层任务作为叶子节点，就可以使用树的数据结构，来描述各个任务的从属关系，并进而构建结构化的并发了。这个层级关系，和 UI 开发时的 View 层级关系十分相似。

     通过用树的方式组织任务层级，我们可以获取下面这些有用特性：

     一个任务具有它自己的优先级和取消标识，它可以拥有若干个子任务 (叶子节点) 并在其中执行异步函数。
     当一个父任务被取消时，这个父任务的取消标识将被设置，并向下传递到所有的子任务中去。
     无论是正常完成还是抛出错误，子任务会将结果向上报告给父任务，在所有子任务正常完成或者抛出之前，父任务是不会被完成的。
     当任务的根节点退出时，我们通过等待所有的子节点，来保证并发任务都已经退出。树形结构允许我们在某个子节点扩展出更多的二层子节点，来组织更复杂的任务。这个子节点也许要遵守同样的规则，等待它的二层子节点们完成后，它自身才能完成。这样一来，在这棵树上的所有任务就都结构化了。

     在 Swift 并发中，在任务树上创建一个叶子节点，有两种方法：通过任务组 (task group) 或是通过 async let 的异步绑定语法。我们来看看两者的一些异同。
     */
    /*
     虽然被定义为 static var，但是它们并不表示针对所有 Task 类型通用的某个全局属性，而是表示当前任务的情况。因为一个异步函数的运行环境必须有且仅会有一个任务上下文，所以使用 static 变量来表示这唯一一个任务的特性，是可以理解的。相比于每次去获取 UnsafeCurrentTask，这种写法更加简单。
     */
    func test() {
        Task {
            let t1 = Task {
                print("t1: \(Task.isCancelled)")
            }
            
            let t2 = Task {
                print("t2: \(Task.isCancelled)")
            }
            
            t1.cancel()
            print("t: \(Task.isCancelled)")
        }
    }
}

