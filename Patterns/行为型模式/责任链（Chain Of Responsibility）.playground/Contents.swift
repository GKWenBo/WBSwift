import UIKit

/*
 在软件工程中， 行为型模式为设计模式的一种类型，用来识别对象之间的常用交流模式并加以实现。如此，可在进行这些交流活动时增强弹性。
 */


/*
 责任链模式在面向对象程式设计里是一种软件设计模式，它包含了一些命令对象和一系列的处理对象。每一个处理对象决定它能处理哪些命令对象，它也知道如何将它不能处理的命令对象传递给该链中的下一个处理对象。
 */

protocol WithDrawing {
    func withdraw(amount: Int) -> Bool
}


final class MoneyPile: WithDrawing {
    let value: Int
    var quantity: Int
    var next: WithDrawing?
    
    init(value: Int, quantity: Int, next: WithDrawing?) {
        self.value = value
        self.quantity = quantity
        self.next = next
    }
    
    func withdraw(amount: Int) -> Bool {
        var amount = amount
        
        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.value) > 0
        }
        
        var quantity = self.quantity
        
        while canTakeSomeBill(want: amount) {
            if quantity == 0 {
                break
            }
            
            amount -= self.value
            quantity -= 1
        }
        
        guard amount > 0 else {
            return true
        }
        
        if let next = self.next {
            return next.withdraw(amount: amount)
        }
        
        return false
    }
}


final class ATM: WithDrawing {
    private var hundred: WithDrawing
    private var fifty: WithDrawing
    private var twenty: WithDrawing
    private var ten: WithDrawing
    
    private var startPile: WithDrawing {
        return self.hundred
    }
    
    init(handred: WithDrawing, fifty: WithDrawing, twenty: WithDrawing, ten: WithDrawing) {
        self.hundred = handred
        self.fifty = fifty
        self.twenty = twenty
        self.ten = ten
    }
    
    func withdraw(amount: Int) -> Bool {
        return startPile.withdraw(amount: amount)
    }
}


/// usage
// 创建一系列的钱堆，并将其链接起来：10<20<50<100
let ten = MoneyPile(value: 10, quantity: 6, next: nil)
let twenty = MoneyPile(value: 20, quantity: 2, next: ten)
let fifty = MoneyPile(value: 50, quantity: 2, next: twenty)
let hundred = MoneyPile(value: 100, quantity: 1, next: fifty)

// 创建 ATM 实例
var atm = ATM(handred: hundred, fifty: fifty, twenty: twenty, ten: ten)
atm.withdraw(amount: 310) // Cannot because ATM has only 300
atm.withdraw(amount: 100) // Can withdraw - 1x100
