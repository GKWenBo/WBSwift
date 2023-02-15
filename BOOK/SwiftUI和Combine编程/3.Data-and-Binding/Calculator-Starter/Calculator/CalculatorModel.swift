//
//  CalculatorModel.swift
//  Calculator
//
//  Created by WENBO on 2023/2/14.
//  Copyright © 2023 OneV's Den. All rights reserved.
//

import Combine

class CalculatorModel: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var brain: CalculatorBrain = .left("0") {
        willSet {
            objectWillChange.send()
        }
    }
    
}
