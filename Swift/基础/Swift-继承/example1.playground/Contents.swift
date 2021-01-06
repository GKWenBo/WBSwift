import UIKit

class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    
    func makeNoise()  {
        print("makeNoise")
    }
}

//重写方法
class Train: Vehicle {
    override func makeNoise() {
        super.makeNoise()
    }
}

let train = Train()
train.makeNoise()


//重写属性
class Car: Vehicle {
    var year = 1
    
    override var description: String {
        return super.description + "\(year)"
    }
    
}

let car = Car()
print(car.description)


//防止重写
class AutomaticCar: Car {
    
    final func run() {
        
    }
}
