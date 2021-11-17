//
//  TaskGroupSample.swift
//  Demo
//
//  Created by wenbo on 2021/11/16.
//

import Foundation

// 任务组
struct TaskGroupSample {
    func start() async {
        print("Start")
        
        // 1
        await withTaskGroup(of: Int.self, body: { group in
            for i in 0..<3 {
                group.addTask {
                    await work(i)
                }
            }
            
            print("Task added")
            
            // 4
            for await result in group {
                print("Get result: \(result)")
            }
            
            // 5
            print("Task ended")
            
        })
        
        print("End")
    }
    
    // MARK: - 隐式等待
    /*
     为了获取子任务的结果，我们在上例中使用 for await 明确地等待 group 完成。这从语义上明确地满足结构化并发的要求：子任务会在控制流到达底部前结束。不过一个常见的疑问是，其实编译器并没有强制我们书写 for await 代码。如果我们因为某种原因，比如由于用不到这些结果，而导致忘了等待 group，会发生什么呢？任务组会不会因为没有等待，而导致原来的控制流不会暂停，就这样继续运行并结束？这样是不是违反了结构化并发的需要？

     好消息是，即使我们没有明确 await 任务组，编译器在检测到结构化并发作用域结束时，会为我们自动添加上 await 并在等待所有任务结束后再继续控制流。比如，在上面的代码中，如果我们将 for await 部分删去：
     */
    func start1() async {
        print("Start")
        
        // 1
        await withTaskGroup(of: Int.self, body: { group in
            for i in 0..<3 {
                group.addTask {
                    await work(i)
                }
            }
            
            print("Task added")
            
            // 4
//            for await result in group {
//                print("Get result: \(result)")
//            }
            
            // 编译器自动生成的代码
            for await _ in group { }
            
            // 5
            print("Task ended")
            
        })
        
        print("End")
    }
    
    func start2() async {
        print("Start")
        
        // 1
        await withTaskGroup(of: Int.self, body: { group in
            for i in 0..<3 {
                group.addTask {
                    await work(i)
                }
            }
            
            print("Task added")
            
            for await result in group {
                print("Get result: \(result)")
                // 在首个子任务完成后就跳出
                break
            }
            
            // 5
            print("Task ended")
            
            // 编译器自动生成代码
            await group.waitForAll()
            
        })
        
        print("End")
    }
    
    // MARK: - 任务组的值捕获
    /*
     任务组中的每个子任务都拥有返回值，上面例子中 work 返回的 Int 就是子任务的返回值。当 for await 一个任务组时，就可以获取到每个子任务的返回值。任务组必须在所有子任务完成后才能完成，因此我们有机会“整理”所有子任务的返回结果，并为整个任务组设定一个返回值。比如把所有的 work 结果加起来：
     */
    func test() async {
        let v: Int = await withTaskGroup(of: Int.self) { group in
            var value = 0
            for i in 0..<3 {
                return await work(i)
            }
            
            for await result in group {
                value += result
            }
            
            return value
        }
        
        print("End. Result: \(v)")
    }
    
    // MARK: - 任务组逃逸
    /*
     和 withUnsafeCurrentTask 中的 task 类似，withTaskGroup 闭包中的 group 也不应该被外部持有并在作用范围之外使用。虽然 Swift 编译器现在没有阻止我们这样做，但是在 withTaskGroup 闭包外使用 group 的话，将完全破坏结构化并发的假设：
     */
    func start3() async {
        var g: TaskGroup<Int>? = nil
        await withTaskGroup(of: Int.self, body: { group in
            g = group
            
            g?.addTask {
                await work(1)
            }
            
            print("End")
        })
    }
    
    func work(_ value: Int) async -> Int {
        // 3
        print("Start work \(value)")
        await Task.sleep(UInt64(value) * NSEC_PER_SEC)
        print("Work \(value) done")
        return value
    }
    
}
