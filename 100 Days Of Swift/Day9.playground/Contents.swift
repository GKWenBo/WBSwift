import UIKit

// MARK: - How do Swift’s memberwise initializers work?
//struct Employee {
//    var name: String
//    var yearsActive = 0
//}
//
//let roslin = Employee(name: "aaa")
//let adama = Employee(name: "bbb", yearsActive: 21)


struct Employee {
    var name: String
    var yearsActive = 0
}

extension Employee {
    init() {
        self.name = "fafds"
    }
}


let roslin = Employee(name: "afds")
let anon = Employee()

// MARK: - When would you use self in a method?
struct Student {
    var name: String
    var bestFriend: String
    
    init(name: String, bestFriend: String) {
        self.name = name
        self.bestFriend = bestFriend
    }
    
}


// MARK: - Lazy properties
struct FamilyTree {
    init() {
        print("Creating family tree!")
    }
}

struct Person {
    var name: String
    lazy var familyTree = FamilyTree()
    init(name: String) {
        self.name = name
    }
}

var ed = Person(name: "ED")
ed.familyTree
