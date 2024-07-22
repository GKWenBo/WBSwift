//
//  TestStruct.swift
//  CodablePropertyWrapper
//
//  Created by wenbo22 on 2024/7/16.
//

import Foundation

struct TestStruct: Decodable {
    @Default<String.Unnamed> var name: String
    @Default<String.Unknown> var text: String
}
