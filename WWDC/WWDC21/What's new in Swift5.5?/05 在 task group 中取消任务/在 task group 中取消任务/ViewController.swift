//
//  ViewController.swift
//  在 task group 中取消任务
//
//  Created by WENBO on 2021/11/20.
//

/*
 1、withThrowingTaskGroup
 2、CancellationError
 3、主动取消任务
 */

import UIKit

enum MyError: Error {
    case invalidNameError
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    // MARK: - 1、withThrowingTaskGroup
    /*
     1、这次，我们使用了 withThrowingTaskGroup 来创建 task group，表示其中并行执行的任务是可能出错的。而用于创建任务的 group 的类型，也因此变成了 ThrowingTaskGroup；
     2、在收集处理后的食材时，我们要使用 try await 等待每一个异步任务的结果
     */
    func doTaskError(_ name: String) async throws {
        try await withThrowingTaskGroup(of: Void.self, body: { group in
            if name == "" {
                throw MyError.invalidNameError
            }
            group.addTask { [unowned self] in
                // 当 task group 中有任务取消之后，checkCancellation 会抛出一个叫做 CancellationError 的错误，这会导致任务立即结束
                try Task.checkCancellation()
                
                // 或者，我们也可以像下面这样通过 isCancelled 属性检测取消状态并抛出错误：
                guard !Task.isCancelled else {
                    throw CancellationError()
                }
                
                await self.startDoTask()
            }
            
            // 主动取消任务
            // 一旦 task group 被取消，无论是当前还没执行完的，还是调用 cancelAll() 之后又创建的新任务，它们的结果都会被 task group 忽略。
            group.cancelAll()
        })
    }
    
    func startDoTask() async {
        print("start do task.")
    }
}

