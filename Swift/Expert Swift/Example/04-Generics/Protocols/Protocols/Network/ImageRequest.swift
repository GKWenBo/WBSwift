//
//  ImageRequest.swift
//  Protocols
//
//  Created by WENBO on 2022/5/10.
//

import Foundation
import UIKit

struct ImageRequest: Request {
    enum Error: Swift.Error {
        case invalidData
    }
    
    var url: URL
    var method: HTTPMethod { .get }
    
    func decode(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw Error.invalidData
        }
        return image
    }
}
