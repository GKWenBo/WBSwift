import UIKit

//处理不合法的JSON格式
struct Episodes: Codable {
    var title: String
}

func decode<T>(response: String, of: T.Type) throws -> T where T: Codable {
    let data = response.data(using: .utf8)!
    let decoder = JSONDecoder()
    
    do {
        let model = try decoder.decode(T.self, from: data)
        
        return model
    }
    catch DecodingError.typeMismatch(let type, let context) {
        dump(type)
        dump(context)
        exit(-1)
    }
}

let response = """
{
"1":{
"title": "Episode 1"
},
"2": {
"title": "Episode 2"
},
"3": {
"title": "Episode 3"

}
"""

try decode(response: response, of: Episodes.self)

