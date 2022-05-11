import UIKit

enum Language {
    case english, german, croation
}

protocol Localizable {
    static var supportedLanguages: [Language] {get}
}

protocol ImmutableLocalizable: Localizable {
    func changed(to language: Language) -> Self
}

protocol MutableLocalizable: Localizable {
    mutating func change(to language: Language)
}

struct Text: ImmutableLocalizable {
    static let supportedLanguages: [Language] = [.english]
    
    var content = "Help"
    
    func changed(to language: Language) -> Self {
        let newContent: String
        switch language {
        case .english: newContent = "Help"
        case .german: newContent = "Hilfe"
        case .croation: newContent = "Pomoc"
        }
        return Text(content: newContent)
    }
}


extension UILabel: MutableLocalizable {
    static var supportedLanguages: [Language] = [.english, .german]
    
    func change(to language: Language) {
        switch language {
        case .english: text = "Help"
        case .german: text = "Hilfe"
        case .croation: text = "Promoc"
        }
    }
}

extension Localizable {
    static var supportedLanguages: [Language] {
        return [.english]
    }
}

struct Image: Localizable {
    // no nned to add 'supportedLanguages' here
}

protocol UIKitLocalizable: AnyObject, Localizable {
    func change(to language: Language)
}

protocol LocalizableViewController where Self: UIViewController {
    func showLocalizedAlert(text: String)
}

// MARK: - Dealing with extensions
protocol Greetable {
    func greet() -> String
}

extension Greetable {
    func greet() -> String {
        return "Hello"
    }
    
    func leave() -> String {
        return "Bye"
    }
}

struct GermanGreeter: Greetable {
    func greet() -> String {
        return "Hallo"
    }
    
    func leave() -> String {
      return "Tschüss"
    }
}

struct EnglishGreeter: Greetable {}

let greeter: Greetable = GermanGreeter()
print(greeter.greet())
print(greeter.leave())

// MARK: - Using protocols as types
func greet(with greeter: Greetable) -> Void {}
let englishGreeter: Greetable = EnglishGreeter()
let allGreeters: [Greetable] = [englishGreeter]

func localizedGreet(with greeter: Greetable & Localizable) {}


extension UITableViewDelegate where Self: UIViewController {
    func showAlertForSelectedCell(at index: IndexPath) {}
}

extension Array where Element: Greetable {
    var allGreetings: String {
        self.map { $0.greet() }.joined()
    }
}

extension Array: Localizable where Element: Localizable {
    static var supportedLanguages: [Language] {
        Element.supportedLanguages
    }
}
