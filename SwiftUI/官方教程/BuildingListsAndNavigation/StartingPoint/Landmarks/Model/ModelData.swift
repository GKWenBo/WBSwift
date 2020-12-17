//
//  ModelData.swift
//  Landmarks
//
//  Created by WENBO on 2020/12/17.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

var landmarks: [Landmark] = load("landmarkData.json")


func load<T: Decodable>(_ fileName: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("Couldn't find \(fileName) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(fileName) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        
        return try decoder.decode(T.self, from: data)
    } catch  {
        fatalError("Couldn't parse \(fileName) as \(T.self):\n\(error)")
    }
    
}
