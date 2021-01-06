import UIKit
import Foundation

class Point2D {
    var x: Double = 0
    var y: Double = 0
    
    // Designated init
    init(x: Double = 0, y: Double = 0) {
        self.x = x
        self.y = y
    }
    
    // Convenience init
    convenience init(at: (Double, Double)) {
        self.init(x: at.0, y: at.1)
    }
    
    //Failable init
    convenience init?(at: (String, String)) {
        guard let x = Double(at.0), let y = Double(at.1) else {
            return nil
        }
        
        self.init(at: (x, y))
    }
}

let point1 = Point2D(at: (1, 1))
print(point1)

class Point3D: Point2D {
    var z: Double = 0
    
    //重载init方法
    init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.z = z
        super.init(x: x, y: y)
    }
    
    override init(x: Double = 0, y: Double = 0) {
        self.z = 0
        super.init(x: x, y: y)
    }
    
    // Convenience init
    convenience init(at: (Double, Double)) {
        self.init(x: at.0, y: at.1, z: 0)
    }
}

let origin3D = Point3D()
let point11 = Point3D(x: 1, y: 1)
let point12 = Point3D(at: (0, 1))
