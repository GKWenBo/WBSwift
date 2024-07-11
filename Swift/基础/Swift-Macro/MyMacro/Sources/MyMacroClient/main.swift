import MyMacro

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

@CaseDetection
enum Animal {
    case cat
}

let animal = Animal.cat

print("animal is cat \(animal.isCat)")
