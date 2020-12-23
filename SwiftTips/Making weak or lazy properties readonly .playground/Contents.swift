import UIKit

/*
 If you have a property in Swift that needs to be weak or lazy, you can still make it readonly by using private(set).
 */

class Node {
    private(set) weak var parent: Node?
    private(set) lazy var children = [Node]()
    
    func add(child: Node) {
        children.append(child)
        child.parent = self
    }
}
