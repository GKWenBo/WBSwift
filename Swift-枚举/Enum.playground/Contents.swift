import UIKit

//定义枚举
enum CompassPoint {
    case north
    case south
    case east
    case west
}

let diretionToHead: CompassPoint = .south

switch diretionToHead {
case .north:
    print("north")
case .south:
    print("south")
case .east:
    print("east")
case .west:
    print("west")
}

/*
//枚举成员的遍历
enum Beverage: CaseIterable {
    case coffee, tea, juice
}

let numberOfChoices = Beverage.allCases.count
print(numberOfChoices)
for beverage in Beverage.allCases {
    print(beverage)
}

let caseList = Beverage.allCases
                       .map({ "\($0)" })
                       .joined(separator: ", ")
print(caseList)
 */


/*
//关联值
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}


var productBarCode = Barcode.upc(8, 666, 6666, 666666)
productBarCode = Barcode.qrCode("AAFFFDJLJFSDKL")

switch productBarCode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("\(numberSystem), \(manufacturer), \(product), \(check)")
case .qrCode(let qrcode):
    print("\(qrcode)")
}
 */



