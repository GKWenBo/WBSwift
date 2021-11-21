//
//  ViewController.swift
//  在 Actor 中使用异步方法
//
//  Created by WENBO on 2021/11/20.
//

/*
 actor 中的同步和异步方法有什么区别呢？简单来说，有两点：
 1、同步函数在执行的过程中是不会被打断的，它类似线程同步中的关键区；
 2、异步函数是可重入的，可中断的位置是函数中的所有的 await 语句；
 
 因此，即使我们在多个并发环境中调用 actor 中的同步方法，这些方法也不会带来数据同步的问题，它们在 actor 对象的“信箱”中会逐个完成。但异步函数就需要注意了，由于它们是可重入的，这就导致当 await 调用返回后，之前 actor 的某些属性已经发生改变了。
 */

import UIKit

class Bank {
    func requestToClose(
        _ accountNumber: Int) async {
            print("Closing account: \(accountNumber).")
        }
}

actor BankAccount {
    let number: Int = 0
    var balance: Double = 0.0
    var isOpen: Bool = true
    // ...
    
    /*
     在 close 的实现里，我们先判断了账号的状态，如果已经关闭了，就抛出 alreadyClosed 错误。否则，就调用并等待异步方法 requestToClose 返回。值得注意的是，requestToClose 返回后，我们重新检查了 isOpen。这是因为，遇到 await 后，当前的 close 就会被挂起，转到其它任务执行。但在等待的过程中，账号的状态完全有可能在别的任务中已经被成功关闭了。等到 close 重新恢复执行时，如果不检查这个状态就关闭账号，同样会造成重复关闭的问题。这就是异步函数可重入之后带来的一个副作用。因此，我们在使用 actor 的时候，最好遵循下面两个准则：
     1、尽可能把属性的修改放在同步方法中，actor 的同步方法类似关键区，在执行的过程中不会被打断；
     2、如果一定要在异步函数中修改属性，在每一个 await 语句之后，不要对属性的值做任何假设；
     */
    func close() async throws {
        if isOpen {
            await Bank().requestToClose(self.number)
            
            if isOpen {
                isOpen = false
            } else {
                throw BankError.alreadyClosed
            }
        } else {
            throw BankError.alreadyClosed
        }
    }
}

enum BankError: Error {
    case insufficientFunds
    case alreadyClosed
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

