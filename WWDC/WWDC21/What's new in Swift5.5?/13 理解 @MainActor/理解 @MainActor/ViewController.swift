//
//  ViewController.swift
//  理解 @MainActor
//
//  Created by WENBO on 2021/11/20.
//

/*
 1、@globalActor
 2、@MainActor
 */

import UIKit

// MARK: - 1、@globalActor
/*
 类似这种“有效期”覆盖程序所有作用域的 actor，叫做 global actor。我们可以像下面这样自定义一个 global actor：
 
 可以看到，定义 global actor 和定义 propery wrapper 是类似的，只是类型修饰变成了 @globalActor。另外，可以成为 global actor 的类型不仅限于 struct， enum，actor 以及 final class 也可以，这主要根据我们要实现的保护语义有关。
 
 @globalActor 会让修饰的类型成为一个实现了 GlobalActor 协议的类型，这个协议唯一的要求，就是提供一个叫做 shared 的 actor 属性。Global actor 就是通过它来保护各种元素的。
 */
@globalActor
struct MyGlobalActor {
    actor MyActor {}
    static let shared = MyActor()
}

// MARK: - 2、@MainActor
/*
 了解了 global actor 之后，我们来看 @MainActor。它就是一个 global actor，用来把属于它的所有元素，都隔离在主线程执行。在 Xcode 13 里，UIKit 中所有和 UI 有关的类型，都加上了这个修饰。
 */

struct DataError: Error {}

struct Todo: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
    
    static func load(id: Int) async throws -> Todo {
        try await withUnsafeThrowingContinuation { continuation in
            var request = URLRequest(
                url: URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)")!)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data else {
                    return
                }
                
                if let todo = try? JSONDecoder().decode(Todo.self, from: data) {
                    continuation.resume(returning: todo)
                }
                else {
                    continuation.resume(throwing: DataError())
                }
                
            }.resume()
        }
    }
}

class ViewController: UIViewController {
    
    var titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(titleLabel)
        
        self.loadTodo(id: 1)
    }
    
    /*
     由于 UIViewController 被 @MainActor 修饰，因此它的派生类 ViewController 也会自动被 @MainActor 修饰。那么，把一个类型修饰为 @MainActor 究竟意味着什么呢？这意味着访问它所有的属性、方法以及下标操作符的行为，都会被隔离在主线程中完成。
     */
    func loadTodo(id: Int) {
        print(Thread.current)
        
        Task {
            print(Thread.current)
            
            do {
                let todo = try await Todo.load(id: id)
                titleLabel.text = todo.title
                
                titleLabel.sizeToFit()
                titleLabel.center = self.view.center
            } catch {
                print("Cannot load todo item of id\(id)")
            }
        }
    }
    
}

