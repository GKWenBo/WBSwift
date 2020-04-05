import UIKit

//在实例方法中修改值类型
struct Point {
    var x = 0.0, y = 0.0
    
    init(x: Double, y: Double) {
        self.x = x;
        self.y = y
    }
    
    mutating func moveBy(x deltaX: Double, y deltaY: Double) -> Void {
        self.x += deltaX
        self.y += deltaY
        
        //在可变方法中给 self 赋值
        self = Point(x: 2, y: 4)
    }
}

var somePoint = Point(x: 1.0, y: 1.0)
somePoint.moveBy(x: 2.0, y: 3.0)
print("The point is now at (\(somePoint.x), \(somePoint.y))")
