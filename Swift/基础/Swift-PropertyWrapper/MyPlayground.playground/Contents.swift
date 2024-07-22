import UIKit

// MARK: - Capitalized

@propertyWrapper
struct Capitalized {
    var wrappedValue: String {
        didSet {
            wrappedValue = wrappedValue.capitalized
        }
    }
    
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
    
}

struct User {
    @Capitalized var firstName: String
    @Capitalized var lastName: String
}

// John Appleseed
var user = User(firstName: "john", lastName: "appleseed")
// John Sundell
user.lastName = "sundell"


// MARK: - UserDefaultsBacked
@propertyWrapper
struct UserDefaultsBacked<Value> {
    let key: String
    private let storage: UserDefaults = .standard
    private let defaultValue: Value
    init(wrappedValue defaultValue: Value,
         key: String) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: Value {
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                storage.set(newValue, forKey: key)
            }
        }
        get {
            let value = storage.value(forKey:key) as? Value
            return value ?? defaultValue
        }
    }
}

extension UserDefaultsBacked where Value: ExpressibleByNilLiteral {
    init(key: String) {
        self.init(wrappedValue: nil, key: key)
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

struct SettingViewModel {
    @UserDefaultsBacked<String>(key: "mark-as-read") var autoMarkMessageAsRead = "777"
    @UserDefaultsBacked(key: "signature") var messageSignature: String?
}

var setModelOne = SettingViewModel()
print(setModelOne.autoMarkMessageAsRead as Any)

@propertyWrapper
struct Progressable {
    private var value: Float = 0
    
    var wrappedValue: Float {
        set {
            if newValue > 1.0 {
                value = 1.0
            } else if newValue < 0 {
                value = 0.0
            }
        }
        get {
            return value
        }
    }
}

struct Progress {
    @Progressable var progress: Float
}


var progress = Progress()
progress.progress = 99.0
print(progress.progress)
