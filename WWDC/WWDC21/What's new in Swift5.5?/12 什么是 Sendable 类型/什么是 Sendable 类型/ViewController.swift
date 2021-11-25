//
//  ViewController.swift
//  什么是 Sendable 类型
//
//  Created by WENBO on 2021/11/20.
//

/*
 1、Sendable Types
 2、Sendable class
 3、Sendable struct
 4、Sendable type
 */

// MARK: - 1、Sendable Types
/*
 为了避免这类问题，Swift 提出了一个概念，叫做 Sendable。关于它的详细信息，大家可以参考 SE-0302。

 这份提议很长，我们找一些重点的部分来说说。首先，Sendable 是一个特别的协议，叫做 marker protocol。这种协议可以理解为是一个编译期常量，用于指导编译器的行为，它和运行时没有任何关联。当我们把一个类型标记为 Sendable 之后，就意味着这个类型的对象可以安全地在并发环境间共享。
 
 因此，给类型添加这个标记，必然也有一些限制。默认情况下，在 Swift 中，以下类型都是 Sendable 的：
 1、所有的值类型；
 2、actor；
 3、不可修改状态的类；
 4、在内部自己实现了状态同步语义的类；
 5、标记为 @Sendable 的函数；
 */

// MARK: - 2、Sendable class
// 第一种，是直接改造 Person：
/*
final class Person : Sendable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}
 
 让一个 class 满足 Sendable，我们有两种选择：一个是自己实现类属性的同步机制，确保它是并发安全的；另一种，也是我们的做法：
 1、让它是一个 final class，因为 Sendable 标记的类不能被继承，也就是说，不能依赖运行时机制；
 2、让它的所有属性只读；
 
 Task.detached {
   let account = await boxueAccount.primaryOwner()
   account.name = "bx10"; /// Compile Time Error
 }
 
 Task.detached {
   var account = await boxueAccount.primaryOwner()
   account.name = "BX10"; // Won't affect actor internal state
 }
 
 */

// MARK: - 3、Sendable struct
/*
 struct Person {
   var name: String
   
   init(name: String) {
     self.name = name
   }
 }
 */

// MARK: - 4、Sendable type
/*
 最后一种做法，是修改 primaryOwner 本身，根据方法实际的需求，让它返回一个 Sendable 类型。例如在我们的例子中，如果只是需要使用姓名，就不应该让它返回 Person，而是应该返回 String。由于 String 是个 Sendable 类型，返回它是并发安全的，我们也无法通过它间接修改 actor 的内部属性。
 
 func primaryOwner() -> String {
   return owners[0].name
 }

 
 */

import UIKit

// 定义一个表示人的类 Person
class Person {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

// 其次，给我们的 BankAccount 添加一个 owners 属性，表示一个由多人共享的账号：
actor BankAccount {
    let number: Int
    var balance: Double
    let owners: [Person]
    var isOpen: Bool = true
    
    init(number: Int, balance: Double, owners: [Person]) {
        self.number = number
        self.balance = balance
        self.owners = owners
    }
}

// 最后，我们给 BankAccount 添加一个可以获取主账号的方法
extension BankAccount {
    func primaryOwner() -> Person {
        return owners[0]
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 这样一来，我们就有办法脱离开 actor 的保护，在任意位置修改 actor 属性了：
        let boxueAccount = BankAccount(
          number: 1110, balance: 100,
          owners: [
            Person(name: "10"),
            Person(name: "11")
          ])

        Task.detached {
          let account = await boxueAccount.primaryOwner()
          account.name = "bx10";
        }

        Task.detached {
          let account = await boxueAccount.primaryOwner()
          account.name = "BX10";
        }
    }
}

