import UIKit

// MARK: - Functions
func favoriteAlbum() {
    print("My favorite is Fearless")
}

func favoriteAlbum(name: String) {
    print("My favorite is \(name)")
}

favoriteAlbum(name: "111")


// MARK: - External and internal parameter names
func countLettersInString(myString str: String) {
    print("The string \(str) has \(str.count) letters.")
}

countLettersInString(myString: "Hello")

// MARK: - Optional chaining


// MARK: - Enumerations
/// Enums with additional values
enum WeatherType {
    case sun
    case cloud
    case rain
    case wind(speed: Int)
    case snow
}

func getHaterStatus(weather: WeatherType) -> String? {
    switch weather {
    case .sun:
        return nil
    case .wind(let speed) where speed < 10:
        return "meh"
    case .cloud, .wind:
        return "dislike"
    case .rain, .snow:
        return "hate"
    }
}

getHaterStatus(weather: WeatherType.wind(speed: 5))


// MARK: - Structs

// MARK: - Classes
/*
 You don't get an automatic memberwise initializer for your classes; you need to write your own.
 You can define a class as being based off another class, adding any new things you want.
 When you create an instance of a class it’s called an object. If you copy that object, both copies point at the same data by default – change one, and the copy changes too.
 */


class Person {
    var clothes: String
    var shoes: String

    init(clothes: String, shoes: String) {
        self.clothes = clothes
        self.shoes = shoes
    }
}

/// Working with Objective-C code
/*
 If you want to have some part of Apple’s operating system call your Swift class’s method, you need to mark it with a special attribute: @objc. This is short for “Objective-C”, and the attribute effectively marks the method as being available for older Objective-C code to run – which is almost all of iOS, macOS, watchOS, and tvOS. For example, if you ask the system to call your method after one second has passed, you’ll need to mark it with @objc.

 Don’t worry too much about @objc for now – not only will I be explaining it in context later on, but Xcode will always tell you when it’s needed. Alternatively, if you don’t want to use @objc for individual methods you can put @objcMembers before your class to automatically make all its methods available to Objective-C.
 */
