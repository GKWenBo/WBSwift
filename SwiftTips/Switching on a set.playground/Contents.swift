import UIKit

/*
 You can switch on a set using array literals as cases in Swift! Can be really useful to avoid many if/else if statements.
 */

protocol Tile {}

enum Direction {
    case up, down, left, right
}

class RoadTile: Tile {
    
    var connectedDirections = Set<Direction>()
    var image: UIImage! = nil
    
    func render() {
                
        switch connectedDirections {
        case [.up, .down]:
            image = UIImage.init(named: "1")
        case [.left, .right]:
            image = UIImage.init(named: "2")
        default:
            image = UIImage.init(named: "3")
        }
    }
}
