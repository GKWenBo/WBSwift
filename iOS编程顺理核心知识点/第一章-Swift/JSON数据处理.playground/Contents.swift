import UIKit

//var str = "Hello, playground"

// MARK: - 使用JSONDecoder
/// 基本使用
//struct GroceryProduct: Codable {
//    var name: String
//    var points: Int
//    var description: String?
//}
//
//let json = """
//{
//    "name": "Durian",
//    "points": 600,
//    "description": "A fruit with a distinctive scent"
//}
//""".data(using: .utf8)!
//
//let decoder = JSONDecoder()
//let product = try decoder.decode(GroceryProduct.self, from: json)
//print(product)


/// 嵌套使用
//let json1 = """
//{
//    "name": "Durian",
//    "points": 600,
//    "ability": {
//        "mathematics": "excellent",
//        "physics": "bad",
//        "chemistry": "fine"
//    },
//    "description": "A fruit with a distinctive scent"
//}
//""".data(using: .utf8)!
//
//struct GroceryProduct: Codable {
//    var name: String
//    var points: Int
//    var ability: Ability
//    var description: String?
//
//    struct Ability: Codable {
//        var mathematics: Appraise
//        var physics: Appraise
//        var chemistry: Appraise
//    }
//
//    enum Appraise: String, Codable {
//        case excellent, bad, fine
//    }
//}
//
//let decoder = JSONDecoder()
//let product = try decoder.decode(GroceryProduct.self, from: json1)
//print(product.name)

// MARK: - CodingKey协议
let json2 = """
{
    "nick_name": "Tom",
    "points": 600,
}
""".data(using: .utf8)!

struct GroceryProduct: Codable {
    var nickName: String
    var points: Int
    
    enum CodingKeys: String, CodingKey {
        case nickName = "nick_name"
        case points
    }
    
}

// inout
