import UIKit

struct Fahrenheit {
    var temperature: Double
    
    //构造器
    init() {
        temperature = 32.0
    }
}


class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}

class Bicycle: Vehicle {
    override init() {
        super.init()
    }
}

//指定构造器和便利构造器实践
class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    convenience init() {
        self.init(name: "[Unname]]")
    }
}

let food = Food()
print(food.name)


class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

//可失败构造器
struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty {
            return nil
        }
        self.species = species
    }
}

/*
//必要构造器
//在类的构造器前添加 required 修饰符表明所有该类的子类都必须实现该构造器
class SomeClass {
    required init() {
        
    }
}

class SomeSubClass: SomeClass {
    required init() {
        
    }
}
*/

///通过闭包或函数设置属性的默认值
class SomeClass {
    let someProperty: Int = {
        return 5
    }()
    
}

