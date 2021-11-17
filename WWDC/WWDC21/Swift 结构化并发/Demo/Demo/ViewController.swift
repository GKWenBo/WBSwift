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
        
//        test()
        
//        Task {
//            await testGroup()
//        }
        
        Task {
            await start()
        }
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
    /*
     1.withUnsafeCurrentTask 本身不是异步函数，你也可以在普通的同步函数中使用它。如果当前的函数并没有运行在任何任务上下文环境中，也就是说，到 withUnsafeCurrentTask 为止的调用链中如果没有异步函数的话，这里得到的 task 会是 nil。
     2.使用 Task 的初始化方法，可以得到一个新的任务环境。在上一章中我们已经看到过几种开始任务的方式了。
     3.对于 foo 的调用，发生在上一步的 Task 闭包作用范围中，它的运行环境就是这个新创建的 Task。
     4.对于获取到的 task，可以访问它的 isCancelled 和 priority 属性检查它是否已经被取消以及当前的优先级。我们甚至可以调用 cancel() 来取消这个任务。
     */
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
//    func test() {
//        Task {
//            let t1 = Task {
//                print("t1: \(Task.isCancelled)")
//            }
//
//            let t2 = Task {
//                print("t2: \(Task.isCancelled)")
//            }
//
//            t1.cancel()
//            print("t: \(Task.isCancelled)")
//        }
//    }
    
    // MARK: - async let 异步绑定
//    func start() async {
//        print("Start")
//
//        async let v0 = work(0)
//        async let v1 = work(1)
//        async let v2 = work(2)
//
//        print("Task added")
//
//        let result =  await v0 + v1 + v2
//        print("Task added")
//        print("End. Result\(result)")
//    }
//
//    // MARK: - 任务组
//    func work(_ value: Int) async -> Int {
//        // 3
//        print("Start work \(value)")
//        await Task.sleep(UInt64(value) * NSEC_PER_SEC)
//        print("Work \(value) done")
//        return value
//    }
//
//    func testGroup() async {
////        await TaskGroupSample().start()
////        await TaskGroupSample().test()
//        await TaskGroupSample().start3()
//    }
    
    // MARK: - 隐式取消
    /*
     在使用 async let 时，编译器也没有强制我们书写类似 await v0 这样的等待语句。有了 TaskGroup 中的经验以及 Swift 里“默认安全”的行为规范，我们不难猜测出，对于没有 await 的异步绑定，编译器也帮我们做了某些“手脚”，以保证单进单出的结构化并发依然成立。

     如果没有 await，那么 Swift 并发会在被绑定的常量离开作用域时，隐式地将绑定的子任务取消掉，然后进行 await。也就是说，对于这样的代码
     */
//    func start() async {
//        async let v0 = work(0)
//
//        print("End")
//    }
    
    //  等效于
//    func start1() async {
//        async let v0 = work(0)
//
//        print("End")
//        // 下面是编译器自动生成的伪代码
//        // 注意和 Task group 的不同
//
//        // v0 绑定的任务被取消
//        // 伪代码，实际上绑定中并没有 `task` 这个属性
//        v0.task?.cancel()
//        // 隐式 await，满足结构化并发
//        _ = await v0
//    }
    
    
    // MARK: - 结构化并发的组合
    /*
     在只使用一次 withTaskGroup 或者一组 async let 的单一层级的维度上，我们可能很难看出结构化并发的优势，因为这时对于任务的调度还处于可控状态：我们完全可以使用传统的技术，通过添加一些信号量，来“手动”控制保证并发任务最终可以合并到一起。但是，随着系统逐渐复杂，可能会面临在一些并发的子任务中再次进行任务并发的需求。也就是，形成多个层级的子任务系统。在这种情况下，想依靠原始的信号量来进行任务管理会变得异常复杂。这也是结构化并发这一抽象真正能发挥全部功效的情况。

     通过嵌套使用 withTaskGroup 或者 async let，可以在一般人能够轻易理解的范围内，灵活地构建出这种多层级的并发任务。最简单的方式，是在 withTaskGroup 中为 group 添加 task 时再开启一个 withTaskGroup：
     */
//    func start() async {
//        // 第一任务组
//        await withTaskGroup(of: Int.self, body: { group in
//            group.addTask {
//
//                // 第二任务组
//                await withTaskGroup(of: Int.self, body: { innerGroup in
//                    innerGroup.addTask { [unowned self] in
//                        await self.work(0)
//                    }
//
//                    innerGroup.addTask { [unowned self] in
//                        await self.work(2)
//                    }
//
//                    return await innerGroup.reduce(0, { result, value in
//                        result + value
//                    })
//                })
//            }
//
//            group.addTask { [unowned self] in
//                await self.work(1)
//            }
//        })
//
//        print("End")
//    }
    /*
     对于上面使用 work 函数的例子来说，多加的一层 innerGroup 在执行时并不会造成太大区别：三个任务依然是按照结构化并发执行。不过，这种层级的划分，给了我们更精确控制并发行为的机会。在结构化并发的任务模型中，子任务会从其父任务中继承任务优先级以及任务的本地值 (task local value)；在处理任务取消时，除了父任务会将取消传递给子任务外，在子任务中的抛出也会将取消向上传递。不论是当我们需要精确地在某一组任务中设置这些行为，或者只是单纯地为了更好的可读性，这种通过嵌套得到更加细分的任务层级的方法，都会对我们的目标有所帮助。
     */
    
    /*
     相对于 withTaskGroup 的嵌套，使用 async let 会更有技巧性一些。async let 赋值等号右边，接受的是一个对异步函数的调用。这个异步函数可以是像 work 这样的具体具名的函数，也可以是一个匿名函数。比如，上面的 withTaskGroup 嵌套的例子，使用 async let，可以简单地写为：
     */
//    func start() async {
//        async let v02: Int = {
//            async let v0 = work(0)
//            async let v2 = work(2)
//            return await v0 + v2
//        }()
//
//        async let v1 = work(1)
//        _ = await v02 + v1
//    }
    /*
     这里在 v02 等号右侧的是一个匿名的异步函数闭包调用，其中通过两个新的 async let 开始了嵌套的子任务。特别注意，上例中的写法和下面这样的 await 有本质不同：
     func start() async {
       async let v02: Int = {
         return await work(0) + work(2)
       }()

       // ...
     }
     await work(0) + work(2) 将会顺次执行 work(0) 和 work(2)，并把它们的结果相加。这时两个操作不是并发执行的，也不涉及新的子任务。
     */
    
    /*
     TaskGroup.addTask 和 async let 是 Swift 并发中“唯二”的创建结构化并发任务的 API。它们从当前的任务运行环境中继承任务优先级等属性，为即将开始的异步操作创建新的任务环境，然后将新的任务作为子任务添加到当前任务环境中。
     */
    
    
    // MARK: - 非结构化任务
    /*
     TaskGroup.addTask 和 async let 是 Swift 并发中“唯二”的创建结构化并发任务的 API。它们从当前的任务运行环境中继承任务优先级等属性，为即将开始的异步操作创建新的任务环境，然后将新的任务作为子任务添加到当前任务环境中。
     
     这类任务具有最高的灵活性，它们可以在任何地方被创建。它们生成一棵新的任务树，并位于顶层，不属于任何其他任务的子任务，生命周期不和其他作用域绑定，当然也没有结构化并发的特性。对比三者，可以看出它们之间明显的不同：

     TaskGroup.addTask 和 async let - 创建结构化的子任务，继承优先级和本地值。
     Task.init - 创建非结构化的任务根节点，从当前任务中继承运行环境：比如 actor 隔离域，优先级和本地值等。
     Task.detached - 创建非结构化的任务根节点，不从当前任务中继承优先级和本地值等运行环境，完全新的游离任务环境。
     有一种迷思认为，我们在新建根节点任务时，应该尽量使用 Task.init 而避免选用生成一个完全“游离任务”的 Task.detached。其实这并不全然正确，有时候我们希望从当前任务环境中继承一些事实，但也有时候我们确实想要一个“干净”的任务环境。比如 @main 标记的异步程序入口和 SwiftUI task 修饰符，都使用的是 Task.detached。具体是不是有可能从当前任务环境中继承属性，或者应不应该继承这些属性，需要具体问题具体分析。

     创建非结构化任务时，我们可以得到一个具体的 Task 值，它充当了这个新建任务的标识。从 Task.init 或 Task.detached 的闭包中返回的值，将作为整个 Task 运行结束后的值。使用 Task.value 这个异步只读属性，我们可以获取到整个 Task 的返回值：
     */
//    func start() async {
//        Task {
//            await work(1)
//        }
//
//        Task {
//            await work(2)
//        }
//
//        print("End")
//    }
    
//    func start() async {
//        let t1 = Task {
//            await work(1)
//        }
//
//        let t2 = Task {
//            await work(2)
//        }
//
//        let v1 = await t1.value
//        let v2 = await t2.value
//
//        print("End")
//    }
    
    /*
     用 Task.init 或 Task.detached 明确创建的 Task，是没有结构化并发特性的。Task 值超过作用域并不会导致自动取消或是 await 行为。想要取消一个这样的 Task，必须持有返回的 Task 值并明确调用 cancel：
     */
//    func start() async {
//        let t1 = Task {
//            await work(1)
//        }
//
//        let t2 = Task {
//            await work(2)
//        }
//
//        t1.cancel()
//
//        print("End")
//    }
    
    /*
     这种非结构化并发中，外层的 Task 的取消，并不会传递到内层 Task。或者，更准确来说，这样的两个 Task 并没有任何从属关系，它们都是顶层任务：
     */
    func start() async {
        let outer = Task {
            let inner = Task {
                await work(1)
            }
            
            await work(2)
        }
        
//        outer.isCancelled // true
//        inner.isCancelled // false
    }
    
    // MARK: - Work
    func work(_ value: Int) async -> Int {
        // 3
        print("Start work \(value)")
        await Task.sleep(UInt64(value) * NSEC_PER_SEC)
        print("Work \(value) done")
        return value
    }
}

