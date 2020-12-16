import UIKit

//class Dog {
//    var name: String
//    var breed: String
//
//    init(name: String, breed: String) {
//        self.name = name
//        self.breed = breed
//    }
//}

// MARK: - Class inheritance
//class Poodle: Dog {
//    init(name: String) {
//        super.init(name: name, breed: "Poodle")
//    }
//}

// MARK: - Overriding methods
//class Dog {
//    func makeNoise() {
//        print("Woof!")
//    }
//}
//
//class Poodle: Dog {
//    override func makeNoise() {
//        print("Yip!")
//    }
//}
//
//let poopy = Poodle()
//poopy.makeNoise()

// MARK: - Final classes
final class Dog {
    func makeNoise() {
        print("Woof!")
    }
}

// MARK: - Copying objects
class Singer {
    deinit {
        
    }
    var name = "Taylor Swift"
}

var singer = Singer()
print(singer.name)

var singerCopy = singer
singerCopy.name = "aaa"

print(singer.name)
