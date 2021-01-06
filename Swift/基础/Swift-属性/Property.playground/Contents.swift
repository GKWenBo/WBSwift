import UIKit

//只读计算属性
struct Cuboid {
    var width = 0.0
    var height = 0.0
    var depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}

//属性观察器
class StepCounter {
    var totalSteps : Int = 0 {
        willSet(newTotalSteps) {
            print("将 totalSteps的值设置为\(newTotalSteps)")
        }
        
        didSet {
            if totalSteps > oldValue {
                print("增加了\(totalSteps - oldValue)")
            }
        }
    }
}

let stepCounter = StepCounter()
stepCounter.totalSteps = 200
