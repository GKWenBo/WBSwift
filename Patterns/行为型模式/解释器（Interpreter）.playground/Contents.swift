import UIKit
/*
 给定一种语言，定义他的文法的一种表示，并定义一个解释器，该解释器使用该表示来解释语言中句子。
 */

protocol IntegerExpression {
    func evaluate(_ context: IntegerContext) -> Int
    func replace(character name: Character, integerExpression: IntegerExpression) -> IntegerExpression
    func copied() -> IntegerExpression
}


final class IntegerContext {
    private var data: [Character : Int] = [:]
    
    func lookup(name: Character) -> Int {
        return self.data[name]!
    }
    
    func assign(expression: IntegerVariableExpression, value: Int) {
        self.data[expression.name] = value
    }
}

final class IntegerVariableExpression: IntegerExpression {
    let name: Character
    
    init(name: Character) {
        self.name = name
    }
    
    func evaluate(_ context: IntegerContext) -> Int {
        return context.lookup(name: self.name)
    }
    
    func replace(character name: Character, integerExpression: IntegerExpression) -> IntegerExpression {
        if name == self.name {
            return integerExpression.copied()
        } else {
            return IntegerVariableExpression(name: self.name)
        }
    }
    
    func copied() -> IntegerExpression {
        return IntegerVariableExpression(name: self.name)
    }
}


final class AddExpression: IntegerExpression {
    private var operation1: IntegerExpression
    private var operation2: IntegerExpression
    
    init(op1: IntegerExpression, op2: IntegerExpression) {
        self.operation1 = op1;
        self.operation2 = op2
    }
    
    func evaluate(_ context: IntegerContext) -> Int {
        return self.operation1.evaluate(context) + self.operation2.evaluate(context)
    }
    
    func replace(character name: Character, integerExpression: IntegerExpression) -> IntegerExpression {
        return AddExpression(op1: operation1.replace(character: name, integerExpression: integerExpression), op2: operation2.replace(character: name, integerExpression: integerExpression))
    }
    
    func copied() -> IntegerExpression {
        return AddExpression(op1: self.operation1, op2: self.operation2)
    }
}

// usage
var context = IntegerContext()

var a = IntegerVariableExpression(name: "A")
var b = IntegerVariableExpression(name: "B")
var c = IntegerVariableExpression(name: "C")

var expression = AddExpression(op1: a, op2: AddExpression(op1: b, op2: c)) // a + (b + c)

context.assign(expression: a, value: 2)
context.assign(expression: b, value: 1)
context.assign(expression: c, value: 3)

var result = expression.evaluate(context)
print(result)

