//
//  ViewController.swift
//  actor 是用来解决什么问题的
//
//  Created by WENBO on 2021/11/20.
//

/*
 actor 是 Swift 5.5 中新增的一个引用类型，它可以安全地在并发环境间共享数据。在开始研究它的各种细节之前，我们不妨先来看看，没有 actor 之前，引用类型究竟有什么问题。
 
 1、理解 data race
 */

// MARK: - 理解 data race
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
    func deposit(amount: Double) -> Double {
        balance += amount
        sleep(1)
        return balance
    }
}

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let account = BankAccount(number: 11, balance: 100)
//        print(account.deposit(amount: 100))
//        print(account.deposit(amount: 100))
        
        // 把这两次存款放到两个并行执行的环境里，并等待它们完成
        /*
         按照设想，我们应该在控制台看到 200 和 300，或者 300 和 200，这都是正常的，毕竟，我们不能确定哪个任务的 print 会先执行。但遗憾的是，我们有很大概率会在控制台看到两个 300，这就不对了。

         造成这种问题的原因，就是第一次增加了 balance 之后我们借助 sleep 触发了任务切换，转移到了第二个任务继续执行，此时余额就变成了 300。因此，两个 deposit 就都会返回 300 了。这种问题，就是一开始我们提到的 data race。一般来说，只要在不同的并发环境中访问同一个可以修改的对象（例如 account11），就有造成 data race 的风险。
         */
        Task {
            await withTaskGroup(of: Void.self, body: { group in
                
                group.addTask {
                    print(await account.deposit(amount: 100))
                }
                
                group.addTask {
                    print(await account.deposit(amount: 100))
                }
            })
        }
    }


}

