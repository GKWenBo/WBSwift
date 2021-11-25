//
//  ViewController.swift
//  suspension point
//
//  Created by wenbo on 2021/11/18.
//

/*
 1、await 表达式的用法
 
 await 必须出现在每一个 suspension point 的位置。落实到具体的应用，有这么几点：
 1、首先，await 没有等待任何东西，就像 async 函数并没有真正实现并发一样，它只是 Swift 语法中的一个标记，用来表达代码中有可能发生挂起的位置；
 2、其次，await 最基础的用法，就是放在 async 函数调用前面；
 3、第三，当异步函数有可能抛出错误时，try 必须写在 await 前面；
 4、第四，await 可以标记一个表达式中所有潜在的 suspension point，因此，不必在一个表达式的每一个异步函数调用前使用 await；
 5、第五，await 不能用于等待同步函数，当你理解了 await 的作用时，理解这个决定也就没什么问题了；
 6、第六，await 还可以用于等待 async let 定义的变量，以及在遍历 AsyncSequence 时，等待其中的每一个元素。
 */

import UIKit

struct Post: Codable {
  let id: Int
  let userId: Int
  let title: String
  let body: String
  
  static let empty = Post(id: 0, userId: 0, title: "", body: "")
}

class Forum {
    
    /// 获取文章信息
    /// - Parameter userIds: 用户ids
    func update(userIds: Array<Int>) {
        let urlSession = URLSession.shared
        
        for userId in userIds {
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(userId)")!
            let dataTask = urlSession.dataTask(with: url) {
                data, response, error in
                guard let data = data,
                      let post = try? JSONDecoder().decode(Post.self, from: data)
                else { return }
                
                print("Decode post ID: \(post.id) @Thread: \(Thread.current)")
            }
            
            dataTask.resume()
        }
    }
    
    func updateAsync(userIds: Array<Int>) async {
        await withThrowingTaskGroup(of: Post.self) { group in
            for userId in userIds {
                let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(userId)")!
                group.addTask {
                    /*
                     /// Convenience method to load data using an URL, creates and resumes an URLSessionDataTask internally.
                     ///
                     /// - Parameter url: The URL for which to load data.
                     /// - Parameter delegate: Task-specific delegate.
                     /// - Returns: Data and response.
                     public func data(from url: URL, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse)
                     */
                    let (data, _ /*response*/) = try await URLSession.shared.data(from: url)
                    guard let post = try? JSONDecoder().decode(Post.self, from: data) else {
                        return Post.empty
                    }
                    
                    print("Decode post ID: \(post.id) @Thread: \(Thread.current)")
                    
                    return post
                }
            }
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Task {
//            test()
            
            await test2()
        }
    }

    // 传统异步方式
    func test() {
        for _ in 0..<5 {
            Forum().update(userIds: Array(0..<100))
        }
        RunLoop.main.run()
    }
    
    // 使用 async
    func test2() async {
        await withTaskGroup(of: Void.self, body: { group in
            for _ in 0..<5 {
                group.addTask {
                    await Forum().updateAsync(userIds: Array(0..<100))
                }
            }            
        })
    }
}

