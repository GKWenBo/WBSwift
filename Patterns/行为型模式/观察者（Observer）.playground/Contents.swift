import UIKit

/*
 一个目标对象管理所有相依于它的观察者对象，并且在它本身的状态改变时主动发出通知
 */

protocol PropertyObserver: class {
    func willChange(propertyName: String, newPropertyValue: Any?)
    func didChange(propertyName: String, oldPropertyValue: Any?)
}

final class TestChambers {
    weak var observer: PropertyObserver?
    
    private let testChambersName = "testChambersName"
    
    var testChamber: Int = 0 {
        willSet {
            observer?.willChange(propertyName: testChambersName, newPropertyValue: newValue)
        }
        
        didSet {
            observer?.didChange(propertyName: testChambersName, oldPropertyValue: oldValue)
        }
    }
}

final class Observer: PropertyObserver {
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if newPropertyValue as? Int == 1 {
            print("Okay. Look. We both said a lot of things that you're going to regret.")
        }
    }
    
    func didChange(propertyName: String, oldPropertyValue: Any?) {
        if oldPropertyValue as? Int == 0 {
            print("Sorry about the mess. I've really let the place go since you killed me.")
        }
    }
}

/// useage
var observerInstance = Observer()
var testChambers = TestChambers()
testChambers.observer = observerInstance
testChambers.testChamber += 1
