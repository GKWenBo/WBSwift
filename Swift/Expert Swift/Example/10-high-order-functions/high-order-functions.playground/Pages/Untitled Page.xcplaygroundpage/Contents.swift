import UIKit

protocol ParagraphFormatterProtocol {
    func formatParagraph(_ text: String) -> String
}

class TextPrinter {
    var formatter: ParagraphFormatterProtocol
    
    init(formatter: ParagraphFormatterProtocol) {
        self.formatter = formatter
    }
    
    func printText(_ paragraphs: [String]) {
      for text in paragraphs {
        let formattedText = formatter.formatParagraph(text)
        print(formattedText)
      }
    }
}

class SimpleFormatter: ParagraphFormatterProtocol {
    func formatParagraph(_ text: String) -> String {
        guard !text.isEmpty else {
            return text
        }
        
        var formattedText = text.prefix(1).uppercased() + text.dropFirst()
        if let lastCharacter = formattedText.last, !lastCharacter.isPunctuation {
            formattedText += "."
        }
        return formattedText
    }
}

let simpleFormatter = SimpleFormatter()
let textPrinter = TextPrinter(formatter: simpleFormatter)

let exampleParagraphs = [
  "basic text example",
  "Another text example!!",
  "one more text example"
]

textPrinter.printText(exampleParagraphs)


extension Array where Element == String {
    func printFormatted(formatter: ParagraphFormatterProtocol) -> Void {
        let textPrinter = TextPrinter(formatter: formatter)
        textPrinter.printText(self)
    }
}

print("----------------------")

exampleParagraphs.printFormatted(formatter: simpleFormatter)

// MARK: - Your first higher-order function
func formatParagraph(_ text: String) -> String {
    guard !text.isEmpty else {
        return text
    }
    
    var formattedText = text.prefix(1).uppercased() + text.dropFirst()
    if let lastCharacter = formattedText.last, !lastCharacter.isPunctuation {
        formattedText += "."
    }
    return formattedText
}

extension Array where Element == String {
    func printFormatted(formatter: ((String) -> String)) {
        for string in self {
            let str = formatter(string)
            print(str)
        }
    }
}

exampleParagraphs.printFormatted(formatter: formatParagraph(_:))
print("----------------------")

let theFunction = formatParagraph
exampleParagraphs.printFormatted(formatter: theFunction)

// MARK: - Closures
print("----------------------")
exampleParagraphs.printFormatted { text in
    guard !text.isEmpty else { return text }
      var formattedText = text.prefix(1).uppercased() + text.dropFirst()
      if let lastCharacter = formattedText.last,
         !lastCharacter.isPunctuation {
        formattedText += "."
      }
      return formattedText
}

print("----------------------")
exampleParagraphs.printFormatted(formatter: { formatParagraph($0)})

// MARK: - Higher-order functions in the standard library
// map
var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
var newNumbers: [Int] = []

for number in numbers {
  newNumbers.append(number * number)
}

print(newNumbers)

let newNumbers2 = numbers.map { $0 * $0 }
print(newNumbers2)

func squareOperation(value: Int) -> Int {
  print("Original Value is: \(value)")
  let newValue = value * value
  print("New Value is: \(newValue)")
  return newValue
}

let newNumbers3 = numbers.map(squareOperation(value:))
print(newNumbers3)


// compactMap
func wordsToInt(_ str: String) -> Int? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter.number(from: str.lowercased()) as? Int
}

wordsToInt("Three") // 3
wordsToInt("Four") // 4
wordsToInt("Five") // 5
wordsToInt("Hello") // nil

func convertToInt(_ value: Any) -> Int? {
    if let value = value as? String {
        return wordsToInt(value)
    } else if let value = value as? Double {
        return Int(value)
    } else {
        return value as? Int
    }
}

convertToInt("one") // 1
convertToInt(1.1) // nil
convertToInt(1) // 1

let sampleArray: [Any] = [1, 2, 3.0, "Four", "Five", "sixx", 7.1, "Hello", "World", "!"]

let newArray = sampleArray.compactMap(convertToInt(_:)) // [1, 2, 4, 5]

// flatMap
func calculatePowers(_ number: Int) -> [Int] {
    var results: [Int] = []
    var value = number
    for _ in 0...2 {
        value *= number
        results.append(value)
    }
    return results
}

calculatePowers(3) // [9, 27, 81]

let exampleList = [1, 2, 3, 4, 5]
let result = exampleList.map(calculatePowers(_:))
// [[1, 1, 1], [4, 8, 16], [9, 27, 81], [16, 64, 256], [25, 125, 625]]
result.count // 5

let joinedResult = Array(result.joined())
let flatResult = exampleList.flatMap(calculatePowers(_:))

// MARK: - filter
func intToWord(_ number: Int) -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter.string(from: number as NSNumber)
}

let numbers1: [Int] = Array(0...100)
let words = numbers1.compactMap(intToWord(_:))
// ["zero", "one", "two", ....., "ninety-nine", "one hundred"]

func shouldKeep(word: String) -> Bool {
    return word.count == 4
}

let filteredWords = words.filter(shouldKeep(word:))
// ["zero", "four", "five", "nine"]

// MARK: - reduce
struct Score {
    var wins = 0, draws = 0, losses = 0
    var goalsScored = 0, goalsReceived = 0
    
    init() {}
    
    init(goalsScored: Int, goalsReceived: Int) {
        self.goalsScored = goalsScored
        self.goalsReceived = goalsReceived
        
        if goalsScored == goalsReceived {
            draws = 1
        } else if goalsScored > goalsReceived {
            wins = 1
        } else {
            losses = 1
        }
    }
}

var teamScores = [
    Score(goalsScored: 1, goalsReceived: 0),
    Score(goalsScored: 2, goalsReceived: 1),
    Score(goalsScored: 0, goalsReceived: 0),
    Score(goalsScored: 1, goalsReceived: 3),
    Score(goalsScored: 2, goalsReceived: 2),
    Score(goalsScored: 3, goalsReceived: 0),
    Score(goalsScored: 4, goalsReceived: 3)
]

extension Score {
    static func +(left: Score, right: Score) -> Score {
        var newScore = Score()
        
        newScore.wins = left.wins + right.wins
        newScore.losses = left.losses + right.losses
        newScore.draws = left.draws + right.draws
        newScore.goalsScored =
        left.goalsScored + right.goalsScored
        newScore.goalsReceived =
        left.goalsReceived + right.goalsReceived
        
        return newScore
    }
}


let firstSeasonScores = teamScores.reduce(Score(), +)

var secondSeasonMatches = [
    Score(goalsScored: 5, goalsReceived: 3),
    Score(goalsScored: 1, goalsReceived: 1),
    Score(goalsScored: 0, goalsReceived: 2),
    Score(goalsScored: 2, goalsReceived: 0),
    Score(goalsScored: 2, goalsReceived: 2),
    Score(goalsScored: 3, goalsReceived: 2),
    Score(goalsScored: 2, goalsReceived: 3)
]

let totalScores = secondSeasonMatches.reduce(firstSeasonScores, +)
// Score(wins: 7, draws: 4, losses: 3, goalsScored: 28, goalsReceived: 22)

// MARK: - sorted
let words1 = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]

let stringOrderedWords = words1.sorted()
// ["eight", "five", "four", "nine", "one", "seven", "six", "ten", "three", "two", "zero"]

func areMatchesSorted(first: Score, second: Score) -> Bool {
    if first.wins != second.wins { // 1
        return first.wins > second.wins
    } else if first.draws != second.draws { // 2
        return first.draws > second.draws
    } else { // 3
        let firstDifference = first.goalsScored - first.goalsReceived
        let secondDifference = second.goalsScored - second.goalsReceived
        
        if firstDifference == secondDifference {
            return first.goalsScored > second.goalsScored
        } else {
            return firstDifference > secondDifference
        }
    }
}

var teamScores1 = [
    Score(goalsScored: 1, goalsReceived: 0),
    Score(goalsScored: 2, goalsReceived: 1),
    Score(goalsScored: 0, goalsReceived: 0),
    Score(goalsScored: 1, goalsReceived: 3),
    Score(goalsScored: 2, goalsReceived: 2),
    Score(goalsScored: 3, goalsReceived: 0),
    Score(goalsScored: 4, goalsReceived: 3)
]

let sortedMatches = teamScores1.sorted(by: areMatchesSorted(first:second:))

// MARK: - Currying（柯里化）
func aHigherOrderFunction(_ operation: (Int) -> ()) {
    let numbers = 1...10
    numbers.forEach(operation)
}

func someOperation(_ p1: Int, _ p2: String) {
    print("number is: \(p1), and String is: \(p2)")
}

aHigherOrderFunction { someOperation($0, "a constant")}

func curried_SomeOperation(_ p1: Int) -> (String) -> () {
    return { str in
        print("number is: \(p1), and String is: \(str)")
    }
}

aHigherOrderFunction { curried_SomeOperation($0)("a constant1")}

func curried_SomeOperation(_ str: String) -> (Int) -> () {
    return { p1 in
        print("number is: \(p1), and String is: \(str)")
    }
}

aHigherOrderFunction{ curried_SomeOperation("a constant2")($0) }

// MARK: - A generic currying function
func curry<A, B, C>(_ originMethod: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in
        { b in
            originMethod(a, b)
        }
    }
}

print("-----------------------")
someOperation(1, "number one")
curry(someOperation)(1)("number one")

// MARK: - Generic argument flipping
func flip<A, B, C>(
  _ originalMethod: @escaping (A) -> (B) -> C
) -> (B) -> (A) -> C {
  return { b in { a in originalMethod(a)(b) } }
}

print("-----------------------")
aHigherOrderFunction(flip(curry(someOperation))("a constant"))


// MARK: - Generated class methods by Swift
extension Int {
    func word() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter.string(from: self as NSNumber)
    }
}

1.word() // one
10.word() // ten
36.word() // thirty-six

Int.word // (Int) -> () -> Optional<String>

Int.word(1)() // one
Int.word(10)() // ten
Int.word(36)() // thirty-six

func flip<A, C>(
    _ originalMethod: @escaping (A) -> () -> C
) -> () -> (A) -> C {
    return { { a in originalMethod(a)() } }
}

flip(Int.word)()(1) // one

var flippedWord = flip(Int.word)()
[1, 2, 3, 4, 5].map(flippedWord)
// ["one", "two", "three", "four", "five"]

func reduce<A, C>(
  _ originalMethod: @escaping (A) -> () -> C
) -> (A) -> C {
  return { a in originalMethod(a)() }
}

var reducedWord = reduce(Int.word)

// MARK: - Merging higher-order functions
extension Int {
    func word1() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter.string(from: self as NSNumber)
    }
    
    func squared() -> Int {
        return self * self
    }
    
    func squareAndWord() -> String? {
        self.squared().word1()
    }
}

func mergeFunctions<A, B, C>(
    _ f: @escaping (A) -> () -> B,
    _ g: @escaping (B) -> () -> C
) -> (A) -> C {
    return { a in
        let fValue = f(a)()
        return g(fValue)()
    }
}

var mergedFunctions = mergeFunctions(Int.squared, Int.word)
mergedFunctions(2) // four

func +<A, B, C>(
    left: @escaping (A) -> () -> B,
    right: @escaping (B) -> () -> C
) -> (A) -> C {
    return { a in
        let leftValue = left(a)()
        return right(leftValue)()
    }
}

var addedFunctions = Int.squared + Int.word
addedFunctions(2) // four
(Int.squared + Int.word)(2) // four
