//
//  ReactiveFormModel.swift
//  SwiftUIExample1
//
//  Created by wenbo on 2020/12/3.
//

import Foundation
import Combine

class ReactiveFormModel: ObservableObject {
    
    private let firstEntryPublisher = CurrentValueSubject<String, Never>("")
    
    @Published var firstEntry: String = "" {
        didSet {
            firstEntryPublisher.send(firstEntry)
        }
    }
    
    private let secondEntryPubliser = CurrentValueSubject<String, Never>("")
    @Published var secondEntry: String = "" {
        didSet {
            secondEntryPubliser.send(secondEntry)
        }
    }
    
    @Published var validatonMessages = [String]()
    private var cancellableSet: Set<AnyCancellable> = []
    
    var submitAllowed: AnyPublisher<Bool, Never>
    
    init() {
        let validationPipeline = Publishers.CombineLatest(firstEntryPublisher, secondEntryPubliser)
            .map { (arg) -> [String] in
                let (value, value_repeat) = arg
                var diagMsgs = [String]()
                
                if !(value_repeat == value) {
                    diagMsgs.append("Values for fields must match.")
                }
                
                if value.count < 5 || value_repeat.count < 5 {
                    diagMsgs.append("Please enter values of at least 5 characters.")
                }
                return diagMsgs
            }
            .share()
        
        submitAllowed = validationPipeline
            .map({ (stringArray) -> Bool in
                return stringArray.count < 1
            })
            .eraseToAnyPublisher()
        
        let _ = validationPipeline
            .assign(to: \.validatonMessages, on: self)
            .store(in: &cancellableSet)
        
    }
    
}
