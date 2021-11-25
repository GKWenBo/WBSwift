//
//  ViewController.swift
//  Task Local Value
//
//  Created by WENBO on 2021/11/21.
//

/*
 1、定义 TLV
 2、访问和设置 TLV
 3、TLV 的嵌套
 4、TLV 在函数调用过程中的可见性
 5、TLV 在子任务中的继承
 6、没有任务上下文环境的情况
 */

/*
 如果之前你从事过多线程方面的开发，一定对线程局部存储（TLS）这个东西并不陌生。这种类型的对象把线程当作自己的容器，在线程开始时创建，线程结束时回收。这种技术被广泛地应用在多线程环境下的调试以及性能分析工具的开发中。比如：Thread.current.threadDictionary、dispatch_queue_set_specific、dispatch_get_specific函数

 但由于 Swift 5.5 的并发工作模型并不依赖操作系统的线程管理，TLS 并不适用于 Swift 中的多任务环境，这就给和结构化并发模型有关的调试和分析带来了一定的麻烦。为了解决这个问题，Swift 提出了一个新的概念，叫做 Task Local Value（以下我们就简称 TLV 了），它可以让我们把值绑定到单独的任务上。

 其实，如果回顾下之前我们提到过的内容就会发现，Swift 中的 Task 已经具备了“携带私有数据”的能力。例如：访问任务优先级的 Task.priority 以及查询取消状态的 Task.isCancelled。但由于它们是属于每个任务都必须具备的信息，Swift 在实现它们的时候，采取了一些优化手段。因此，虽然形式上类似，但TLV 并不能和这些数据保存在同一个地方。为此，Swift 提供了一个 property wrapper 以及一个 API，分别来定义和设置 TLV 的值。
 */

import UIKit

// MARK: - 1、定义 TLV
struct Work {
    /*
     为了定义一个 TVL 我们可以使用 @TaskLocal
     在 Swift 5.5 里，@TaskLocal 只能用于修饰某个静态存储属性，我们暂时还不能把一个全局变量修饰为 TLV。另外，自定义的 TLV 通常都是一个 optional 类型，并且默认值为 nil，因为不一定每个任务都需要设置和使用这个值。但这也有例外，如果把 Task.priority 也看成是一个 TLV 的话，它就有一个非 nil 的默认值 .unspecified。
     */
    @TaskLocal
    static var workID: String?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Task {
//            await test()
//            await test1()
//            await test2()
//            await test3()
//            await test4()
//            await test5()
        }
        
        test6()
    }
    
    func test() async {
        await withTaskGroup(of: Void.self, body: { group in
            group.addTask {
                await self.syncPrintWorkID(tag: "T1")
                await self.asyncPrintWorkID(tag: "T1")
            }
            
            group.addTask {
                await self.syncPrintWorkID(tag: "T2")
                await self.asyncPrintWorkID(tag: "T2")
            }
        })
    }
    
    // MARK: - 2、访问和设置 TLV
    // TLV 的设置，是通过一个叫做 withValue 的 API 完成的，我们不能像给一个普通变量赋值一样的去设置 TLV。
    // 可以看到，同样的 Work.workID，在两个不同的任务里，它们分别变成了 BX11 和 BX10。只是，为了访问 withValue，我们要使用 $workID 得到对应的 property wrapper 类型（在这个例子中，也就是 TaskLocal<String?>）。然后再访问它的 withValue 方法。withValue 的第一个参数表示要绑定到当前任务的值，第二个参数，是一个 closure，只有在这个 closure 里，workID 的值才是我们绑定的参数值。离开 closure 之后，就又回到了 Example 1 的情况，Work.workID 的值又会恢复成 nil。
    func test1() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { [unowned self] in
                await self.syncPrintWorkID(tag: "T1")          // no-work-id
                
                await Work.$workID.withValue("BX11") {
                    await syncPrintWorkID(tag: "T1")        // BX11
                    await asyncPrintWorkID(tag: "T1") // BX11
                }
                
                await asyncPrintWorkID(tag: "T1")   // no-work-id
            }
            
            group.addTask { [unowned self] in
                await self.syncPrintWorkID(tag: "T2")          // no-work-id
                
                await Work.$workID.withValue("BX10") {
                    await syncPrintWorkID(tag: "T2")        // BX10
                    await asyncPrintWorkID(tag: "T2") // BX10
                }
                
                await asyncPrintWorkID(tag: "T2")   // no-work-id
            }
        }
    }
    
    // MARK: - 3、TLV 的嵌套
    // 首先，设置 TLV 的 withValue 是可以嵌套的，嵌套之后的规则和一般变量名的覆盖规则是相同的：内层 TLV 的值会替换掉外层 TLV。因此，下面这个例子中，内层 Work.workID 的值是 BX10，回到外层之后，就会变回 BX11：
    func test2() async {
        Task(priority: .userInitiated) {
          Work.$workID.withValue("BX11") {
            syncPrintWorkID(tag: "Outer") // BX11
            
            Work.$workID.withValue("BX10") {
              syncPrintWorkID(tag: "Inner") // BX10
            }
            
            syncPrintWorkID(tag: "Outer") // BX11
          }
        }
    }
    
    // 当然，在 withValue 的 closure 里也存在着一种例外的情况：
    func test3() async {
        Work.$workID.withValue("BX10") {
          syncPrintWorkID(tag: "Inner") // BX10
          
          Task.detached(priority: .userInitiated) {
              await self.syncPrintWorkID(tag: "Detached")
          }
        }
    }
    
    // MARK: - 4、TLV 在函数调用过程中的可见性
    func test4() async {
        Task {
            let ret = await outer()
            print(ret as Any)
        }
    }
    
    func inner() -> String? {
        syncPrintWorkID(tag: "inner") // BX11
        return Work.workID
    }
    
    func middle() async -> String? {
        syncPrintWorkID(tag: "middle") // BX11
        return inner()
    }
    
    func outer() async -> String? {
        await Work.$workID.withValue("BX11") {
            syncPrintWorkID(tag: "outer")
            let ret = await middle()
            
            return ret
        }
    }
    
    // MARK: - 5、TLV 在子任务中的继承
    /*
     第三个场景，就是子任务继承父任务 TLV 的情况了。当我们在一个任务上下文环境中使用 withValue 设置了 TLV，在 withValue 的 closure 中继续创建子任务的时候，子任务中读到的 Work.workID 也会是 BX11。也就是说，父子任务的 TLV 不是独立的，它会继承到子任务。当然，子任务也可以在它自己的作用域里，覆盖掉父任务的值。
     */
    func test5() async {
        Work.$workID.withValue("BX11") {
            Task(priority: .userInitiated) {
                syncPrintWorkID(tag: "SubTask")
            }
        }
        
        await Work.$workID.withValue("BX11") {
            await withTaskGroup(of: String?.self) { group -> String? in
                group.addTask {
                    await self.syncPrintWorkID(tag: "SubTask")
                    return Work.workID
                }
                
                return await group.next()!
            }
        }
    }
    
    // MARK: - 6、没有任务上下文环境的情况
    func test6() {
        syncPrintWorkID(tag: "Outer") // BX11
        
        Work.$workID.withValue("BX10") {
            syncPrintWorkID(tag: "Inner") // BX10
        }
        
        syncPrintWorkID(tag: "Outer") // BX11
    }

    func asyncPrintWorkID(tag: String) async {
        print("\(tag) \(Work.workID ?? "no-work-id")")
    }
    
    func syncPrintWorkID(tag: String) {
      print("\(tag) \(Work.workID ?? "no-work-id")")
    }
}

