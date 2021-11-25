//
//  ViewController.swift
//  Actor isolation 隔离了什么
//
//  Created by WENBO on 2021/11/20.
//

import UIKit

// 为此，我们定义一个表示银行账号的类：
actor BankAccount {
    let number: Int
    var balance: Double
    
    init(number: Int, balance: Double) {
        self.number = number
        self.balance = balance
    }
}

extension BankAccount {
    enum BankError: Error {
        case insufficientFunds
    }
    
    func deposit(amount: Double) -> Double {
        balance += amount
        sleep(1)
        return balance
    }
    
    /*
     实际上，对 actor 来说，被隔离的元素一共有三类，分别是：
     1、可修改属性；
     2、下标操作符；
     3、方法；
     
     这些元素都只能通过 self 直接访问。因此，在 transfer 的实现里，我们不能通过一个非隔离对象，也就是 other，直接访问属于它的 actor 隔离属性，也就是 balance。此时的 other，叫做 corss-actor reference，对于这种引用，我们能执行的操作有两种：
     1、直接访问 actor 中的非隔离元素，例如常量属性。所以，我们可以直接使用 other.number；
     2、执行异步函数调用，等待被引用的 actor 对象完成操作。这就是为什么上一节末尾，我们要使用 await 调用 deposit 方法的原因了；
     
     group.addTask {
       print(await account.deposit(amount: 100))
     }
     
     在上面这个任务中，account 也是一个 cross-actor reference，当要访问它的方法时，必须使用异步调用。接下来发生的事情是这样的：
     1、首先，当前任务发起一个异步函数调用；
     2、其次，account 会有一个接受函数调用请求的“信箱”，deposit 调用会被包装成一个消息放在这个“信箱”里；
     3、第三，account 会串行处理“信箱”中的消息，在 deposit 完成前，发起调用的任务就会被挂起。但当前线程不会阻塞，CPU 会转而执行线程中的其它任务；
     4、最后，当 deposit 返回，发起调用的任务会从 await 的位置被重新调度执行，我们就可以看到打印的余额了；

     看到这里，你应该就能明白为什么要用异步方式调用 deposit 了吧。对 actor 的用户而言，它形式上永远都是“单线程”的，绝对不会有两个 actor 的方法并行执行在同一个 actor 对象上（这也正是 actor 是并发安全类型的原因）。这些方法调用，都会在“信箱”中被串行处理。因此，在非隔离环境里，必须等待它们的结果也是很正常的了。
     */
    func transfer(amount: Double, to other: BankAccount) async throws {
        if amount > balance {
          throw BankError.insufficientFunds
        }
        
        print("Transfering \(amount) from \(number) to \(other.number)")
        
        balance -= amount
//        other.balance += amount /// <1> Compile Time Error
        _ = await other.deposit(amount: amount)
      }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Task {
            await asyncFunc()
        }
    }
    
    func asyncFunc() async {
        let account10 = BankAccount(number: 10, balance: 100)
        let account11 = BankAccount(number: 11, balance: 100)
        
        await withThrowingTaskGroup(of: Void.self) { group in
            for _ in 0...4 {
                group.addTask {
                    try await account10.transfer(amount: 10, to: account11)
                }
            }
        }
        
        print("Account\(account11.number) balance: \(await account11.balance)")
    }
}

