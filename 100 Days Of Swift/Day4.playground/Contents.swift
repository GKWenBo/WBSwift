import UIKit

// MARK: For Loops
let count = 1...10
for number in count {
    print("Number is \(number)")
}

let albums = ["red", "1989", "Reputation"]
for album in albums {
    print("\(album) is on Apple Music")
}

print("Players gonna")
for _ in 1...5 {
    print("play")
}

var number = 1

while number <= 20 {
    print(number)
    number += 1
}

print("Ready or not, here i come!")

var number1 = 1

repeat {
    print(number1)
    number1 += 1
} while number1 <= 20

print("Ready or not, here I come!")

while false {
    print("This is false")
}

repeat {
    print("This is false")
} while false

let numbers = [1, 2, 3, 4, 5]
//var random = numbers.shuffled()
//
//while random == numbers {
//    random = numbers.shuffled()
//}

var random: [Int]
repeat {
    random = numbers.shuffled()
} while random == numbers

// MARK: - Exiting loops
var countDown = 10
//while countDown >= 0 {
//    print(countDown)
//    countDown -= 1
//}
//print("Blast off!")

while countDown >= 0 {
    print(countDown)
    
    if countDown == 4 {
        print("I'm bored, Let's go now!")
        break
    }
    countDown -= 1
}

// MARK: - Exiting multiple loops
for i in 1...10 {
    for j in 1...10 {
        let proudct = i * j
        print("\(i) * \(j) is \(proudct)")
    }
}

outerLoop: for i in 1...10 {
    for j in 1...10 {
        let proudct = i * j
        print("\(i) * \(j) is \(proudct)")
        
        if proudct == 50 {
            break outerLoop
        }
    }
}

// MARK: - Skipping items
for i in 1...10 {
    if i % 2 == 1 {
        continue
    }

    print(i)
}

// MARK: - Infinite loops
var counter = 0
while true {
    print(" ")
    counter += 1
    
    if counter == 273 {
        break
    }
}

while true {
    print("I'm alive!")
}

print("I've snuffed it!")

