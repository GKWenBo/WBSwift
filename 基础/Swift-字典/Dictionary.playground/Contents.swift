import UIKit

enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let defaultSettings: [String: Setting] = [
    "Airplane Mode" : .bool(false),
    "Name": .text("My iPhone")
]

defaultSettings["Name"]

/// - 可变性
var userSetting = defaultSettings
userSetting["Name"] = .text("Bob")
userSetting["Do Not Disturb"] = .bool(true)

let oldName = userSetting.updateValue(.text("Jane's iPhone"), forKey: "Name")
print(oldName as Any)


/// - 合并字典
var settings = defaultSettings
let overriddenSettings: [String: Setting] = ["Name" : .text("My iPhone")]
settings.merge(overriddenSettings, uniquingKeysWith: { $1 })


/// - 对字典的值做映射
let settingStrings = settings.mapValues({ setting -> String in
    switch setting {
    case .text(let text): return text
    case .int(let number): return String(number)
    case .bool(let value): return String(value)
    }
})


/// - 删除
//settings["Name"] = nil
settings.removeValue(forKey: "Name")
