//
//  ViewController.swift
//  理解和使用 detached task
//
//  Created by WENBO on 2021/11/20.
//

/*
 Detached task 是 Swift 结构化并发模型中另外一种独立运行的任务。不过，别被 detached 这个词迷惑，这种任务并不能像守护进程一样脱离开我们的主程序单独运行。这个 detached 是相对于结构化并发模型的作用域的。
 
 1、Detached 和 unstructured task 的区别
 2、detached task 不能修改 actor 的状态
 */

import UIKit

// MARK: - 2、detached task 不能修改 actor 的状态
actor AtomicIncrementor {
    private var value: Int = 0
    
    func current() -> Int {
        return value
    }
    
    func increment() {
        Task {
            value += 1
        }
        
        /*
         这是一个线程安全的自增计数器。在 increment 方法里，我们使用一个 unstructured task 把 value 的值加 1。刚才我们说过，Task 的上下文环境和 actor 是一样的，因此 Task 在 actor 里并不是并行的，所以我们可以在 Task 里修改 value。但如果我们用 detached task，就会发生错误了：
         */
//        Task.detached {
//            value += 2
//        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        test1()
        
//        test2()
    }
    
    func test1() {
        /*
         播放 BGM 和asyncFunc两个任务的执行顺序是不确定的，它们是两个并行的任务。
         */
        
        Task(priority: .userInitiated) {
            Task.detached {
                print("Start playing BGM.")
            }
            
            await asyncFunc()
            
            Task.detached {
                print("Stop playing BGM.")
            }
        }
    }
    
    func test2() {
        // MARK: - 优先级的区别
        /*
         可以看到，withUnsafeCurrentTask 接受一个 closure 参数。这个 closure 自身则有一个 UnsafeCurrentTask? 类型的参数，表示当前任务。我们可以通过这个参数，访问当前任务的若干属性。例如在我们的例子中，就打印了当前任务的优先级。
         
         这里，有两点值得我们注意：
         1、首先，playing 和 asyncFunc 的任务执行顺序，和我们定义的顺序并不相同，这刚好印证了之前我们说到的话题；
         2、其次，asyncFunc 任务继承了创建环境的 .high 优先级，而 playing 任务并没有，它仍旧是默认的 .medium 优先级，因为它没有继承创建任务时的上下文环境；
         */
        Task(priority: .userInitiated) {
            withUnsafeCurrentTask { task in
                let priority = task?.priority.description ?? "unknown"
                print("Start unstructured task at \(priority) priority.")
            }
            
            Task.detached {
                withUnsafeCurrentTask { task in
                    let priority = task?.priority.description ?? "unknown"
                    print("Start playing BGM at \(priority) priority.")
                }
               
            }
            
            Task {
                withUnsafeCurrentTask { task in
                    let priority = task?.priority.description ?? "unknown"
                    print("Start asyncFunc at \(priority) priority.")
                }
                await asyncFunc()
            }
                    
            Task.detached {
                print("Stop playing BGM.")
            }
        }
    }

    func asyncFunc() async {
        print("asyncFunc")
    }

    // MARK: - 1、Detached 和 unstructured task 的区别
    /*
     第一个区别是 unstructured task 会继承创建任务时的上下文环境。但是，detached task 不会。用 Swift 官方注释对 detached task 的描述就是：Run given throwing operation as part of a new top-level task。也就是说，每一个 detached task 都是在并发模型的顶级作用域的。这也就意味着，detached task 不会继承来自创建环境的优先级设置。
     
     @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
     public struct TaskPriority : RawRepresentable {
         public init(rawValue: UInt8)

         public static let high: TaskPriority

         public static let userInitiated: TaskPriority

         public static let `default`: TaskPriority

         public static let low: TaskPriority

         public static let utility: TaskPriority

         public static let background: TaskPriority
     }
     
     其中，我删掉了一些不必要的注释和代码，方便我们观察。在 TaskPriority 中一共有六个优先级。但真正起作用的只有四个，分别是：high / default / low / background，它们在所有平台的 Swift 上均可使用。而 userInitialized / utility 则是 macOS 平台上的别名，它们分别对应 high / low。
     */
    
}

extension TaskPriority: CustomStringConvertible {
    public var description: String {
        switch self {
        case .high, .userInitiated:
            return ".high"
        case .medium:
            return ".medium"
        case .low, .utility:
            return ".low"
        case .background:
            return ".background"
        default:
            return ".unknown"
        }
    }
}
