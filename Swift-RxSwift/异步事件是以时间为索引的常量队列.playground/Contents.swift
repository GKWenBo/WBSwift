import UIKit

let stringArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

let fullFilter = stringArray.compactMap {
    Int($0)
}
.filter {
    $0 % 2 == 0
}

print(fullFilter)

let partialFilter = stringArray[4 ..< stringArray.count].compactMap({
    Int($0)
}).filter({
    $0 % 2 == 0
})

print(partialFilter)

