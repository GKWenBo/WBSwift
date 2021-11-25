//
//  ViewController.swift
//  理解和使用 unstructured task
//
//  Created by WENBO on 2021/11/20.
//

/*
 1、在异步环境中使用Task
 2、在同步环境中执行任务
 3、Unstructured task 的嵌套
 */

import UIKit

struct Meal {
    func eat() {
        print("Yum!")
    }
    
    /*
     Task 就是刚才提到的 unstructured task，它的两个泛形参数分别表示这个任务正常完成以及出错时的返回值。在 eat 的实现里，我们可以通过 Task 的 value 属性得到这个任务完成后的返回值，也就是 Meal 对象。之后，就可以调用 meal.eat 开吃了。
     */
    func eat(_ task: Task<Meal, Error>) async throws {
        let meal = try await task.value
        meal.eat()
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*
         Task 有两个版本的 init 方法：
         
         public init(
           priority: TaskPriority? = nil,
           operation: @escaping @Sendable () async -> Success)

         public init(
           priority: TaskPriority? = nil,
           operation: @escaping @Sendable () async throws -> Success)
         
         其中：
         1、第一个参数是 TaskPriority 类型的对象，表示任务的优先级；
         2、第二个参数是个异步 closure，表示这个任务要执行的代码，这两个 init 方法的区别，主要就是 closure 是否会抛出异常。这个 closure 没有参数，但允许让我们指定一个返回值，表示任务成功执行后的结果。在我们的例子中，当然就是 Meal 了。至于那个 @Sendable 修饰，我们暂时先忽略它就好了；
         */
        
        // MARK: - 2、在同步环境中执行任务
        Task {
            await asyncFunc()
        }
        
        // MARK: - 3、Unstructured task 的嵌套
        /*
         这一节最后，我们再回过头看看刚才写的同步 main 函数。我们使用了一个嵌套的 Task 结构，外面的叫做父任务，里面的叫做子任务。

         当在一个 Task 中创建子任务的时候，子任务会继承父任务的优先级，因此，即便我们没有指定内层任务的优先级，它的优先级也是 .userInitiated。我们可以把 main 改成这样来观察：
         */
        Task(priority: .userInitiated) {
            print("super task")
            Task {
                print("sub task")
                print(Task.currentPriority == .userInitiated)
                Task {
                    print("sub sub task")
                }
            }
        }
    }
    
    // 1、MARK: - 在异步环境中使用 Task
    func asyncFunc() async {
        Task(priority: .userInitiated) {
            await myFunc()
        }
    }
    
    func myFunc() async -> Int {
        return 0
    }
}

