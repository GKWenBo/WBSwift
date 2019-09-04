import UIKit

struct Episode: Codable {
    var createAt: Date
    
    enum CodingKyes: String, CodingKey {
        case createAt = "created_at"
    }
}

struct EpisodeCodingOptions {
    enum Version {
        case v1
        case v2
    }
    
    let apiVersion: Version
    let dateFormatter: DateFormatter
    
    static let infoKey = CodingUserInfoKey(rawValue: "io.boxue.com")
}

let formatter = DateFormatter()
formatter.dateFormat = "MMM-dd-yyyy"
let options = EpisodeCodingOptions(apiVersion: .v1, dateFormatter: formatter)


extension Episode {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let options =
            encoder.userInfo[EpisodeCodingOptions.infoKey] as?
            EpisodeCodingOptions {
            let date = options.dateFormatter.string(from: createAt)
            try! container.encode(date, forKey: .createAt)
        }
        else {
            fatalError("Can not read coding options.")
        }
    }
}


