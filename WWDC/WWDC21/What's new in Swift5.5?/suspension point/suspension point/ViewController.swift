//
//  ViewController.swift
//  suspension point
//
//  Created by wenbo on 2021/11/18.
//

import UIKit

struct Post: Codable {
  let id: Int
  let userId: Int
  let title: String
  let body: String
  
  static let empty = Post(id: 0, userId: 0, title: "", body: "")
}

class Forum {
    
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
//        test()
        Task {
            await test2()
        }
    }

    func test() {
        Forum().update(userIds: Array(0..<100))
        Forum().update(userIds: Array(0..<100))
        Forum().update(userIds: Array(0..<100))
        Forum().update(userIds: Array(0..<100))
        Forum().update(userIds: Array(0..<100))
        RunLoop.main.run()
    }
    
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

