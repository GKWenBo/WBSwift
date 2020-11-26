//
//  ViewController.swift
//  CombineExample1
//
//  Created by wenbo on 2020/8/17.
//  Copyright © 2020 huibo2. All rights reserved.
//

import UIKit
import Combine

class Student {
    let name: String
    var score: Int

    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
}

struct Repository: Codable {
    var name: String
    var url: URL
}

class Counter {
    let publisher = PassthroughSubject<Int, Never>()
    private(set) var value = 0 {
        didSet { publisher.send(value) }
    }
    
    func increment() {
        value += 1
    }
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        example1()
//        example2()
//        example3()
        example4()
    }

    func example1() {
        let student = Student(name: "111", score: 90)
        
        let observer = Subscribers.Assign(object: student, keyPath: \Student.score)
        print(student.score)
        
        let publisher = PassthroughSubject<Int, Never>()
        publisher.subscribe(observer)
        publisher.send(91)
        print(student.score)
        publisher.send(100)
        print(student.score)
        
    }
    
    func example2() {
//        let justPubliser = AnyPublisher<String, NSError> { subscribe in
//            _ = subscribe.receive("hello")  // ignore demand
//            subscribe.receive(completion: .finished)
//        }
//        let subscriber = AnySubscriber<String, NSError>(receiveValue: { input in
//            print("Received input: \(input)")
//            return .unlimited
//        }, receiveCompletion: { completion in
//            print("Completed with \(completion)")
//        })
//        justPubliser.subscribe(subscriber)
        
    }
    
    func example3() {
        let url = URL(string: "https://api.github.com/repos/johnsundell/publish")!
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
        
        let cancellable = publisher.sink(
            receiveCompletion: { (completion) in
//            print(completion)
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Success")
                }
        }) { (value) in
//            print(value)
            let decoder = JSONDecoder()
            do {
                let repo = try decoder.decode(Repository.self, from: value.data)
                print(repo)
            } catch {
                print(error)
            }
            
        }
        
        let repoPublisher = publisher
            .map(\.data)
            .decode(type: Repository.self,
                    decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
        
        let cancelable1 = repoPublisher.sink(
            receiveCompletion: { (completion) in
            
        }) { (repo) in
            print(repo)
        }
    }
    
    func example4() {
        let counter = Counter()
        
        let cancellable = counter.publisher
            .filter({ $0 > 2 })
            .sink { (value) in
                print(value)
        }
        
        counter.increment()
        counter.increment()
        counter.increment()
        
        counter.publisher.send(48)
    }

}

