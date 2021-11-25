//
//  ViewController.swift
//  使用 Continuation 包装历史 API
//
//  Created by WENBO on 2021/11/20.
//

/*
 1、改造基于handler回调
 2、改造基于delegate回调
 3、包装Operation
 */

/*
 Swift 中绝大多数事件驱动的 API 都是基于回调函数的。 因此，升级到 Swift 5.5 之后，如何把这些已有的 API 嫁接到新的编程方式，也是一个必须认真考虑的问题。为此，Swift 提出了一个概念，叫做：Continuation。
 */

// MARK: - UnsafeContinuation
/*
 struct UnsafeContinuation<T, E: Error> {
   func resume(returning: T)
   func resume(throwing: E)
   func resume(with result: Result<T, E>)
 }

 extension UnsafeContinuation where T == Void {
   func resume() { resume(returning: ()) }
 }

 extension UnsafeContinuation where E == Error {
   // 允许 Result 版本使用更严格的 Error 类型
   func resume<ResultError: Error>(with result: Result<T, ResultError>)
 }

 func withUnsafeContinuation<T>(
     _ operation: (UnsafeContinuation<T, Never>) -> ()
 ) async -> T

 func withUnsafeThrowingContinuation<T>(
     _ operation: (UnsafeContinuation<T, Error>) throws -> ()
 ) async throws -> T
 
 注意：
 在调用 withUnsafeContinuation 后，每个分支上都必须调用一次且仅一次 resume 方法。Unsafe*Continuation 是一个不安全的接口，所以同一个 continuation 多次调用 resume 方法属于未定义的行为。在任务被恢复之前，它会一直处于暂停状态；如果 continuation 被释放掉了，并且从未被恢复，那么任务将一直处于暂停状态，直到进程结束，它所拥有的任何资源都会泄漏。
 */

// MARK: - CheckedContinuation
/*
 struct CheckedContinuation<T, E: Error> {
   func resume(returning: T)
   func resume(throwing: E)
   func resume(with result: Result<T, E>)
 }

 extension CheckedContinuation where T == Void {
   func resume()
 }

 extension CheckedContinuation where E == Error {
   // Allow covariant use of a `Result` with a stricter error type than
   // the continuation:
   func resume<ResultError: Error>(with result: Result<T, ResultError>)
 }

 func withCheckedContinuation<T>(
     _ operation: (CheckedContinuation<T, Never>) -> ()
 ) async -> T

 func withCheckedThrowingContinuation<T>(
   _ operation: (CheckedContinuation<T, Error>) throws -> ()
 ) async throws -> T
 */

import UIKit

struct News {
    var id: Int?
    var title: String?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Task {
            let _ =  try await news()
            
            // test delegate
            let pickerDelegate = ImagePickerDelegate()
            let _ = try? await pickerDelegate.chooseImageFromPhotoLibrary(vc: self)
        }
    }

    // 基于回调的函数
    func getNews(completion: @escaping ([News]?, Error?) -> Void) {
        /// do netowrk
        completion([], nil)
    }

    // MARK: - 1、改造基于handler回调
    /*
     withUnsafeContinuation、withUnsafeThrowingContinuation、withCheckedThrowingContinuation、withCheckedContinuation
     
     resume 方法有几个重载的版本：
     1、如果是 resume(returning:)，那么 withUnsafeThrowingContinuation 就会返回 returning 参数的值作为自己的返回值
     2、如果是 resume(throwing:)，那么 withUnsafeThrowingContinuation 就会抛出 throwing 参数指定的错误
     
     其实，resume 还有一个接受 Result<T, E> 作为参数的版本，用来包装那些给回调函数传递 Result 表示结果的 API
     */
    func news() async throws -> [News]?  {
        return try await withCheckedThrowingContinuation({ continuation in
            getNews { news, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: news)
                }
            }
        })
    }
}

// MARK: - 2、改造基于delegate回调
class ImagePickerDelegate: NSObject, UINavigationControllerDelegate & UIImagePickerControllerDelegate {
    var continatin: CheckedContinuation<UIImage?, Never>?
    
    func chooseImageFromPhotoLibrary(vc: UIViewController) async throws -> UIImage? {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        print(">>>>>>>> 图片选择 \(Thread.current)")
        vc.present(vc, animated: true, completion: nil)
        return await withCheckedContinuation({ continuation in
            self.continatin = continuation
        })
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.continatin?.resume(returning: nil)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        self.continatin?.resume(returning: image)
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 3、包装Operation
struct OperationResult {
    
}

class MyOperation: Operation {
    let continuation: UnsafeContinuation<OperationResult, Never>
    var result: OperationResult?
    
    init(continuation: UnsafeContinuation<OperationResult, Never>) {
        self.continuation = continuation
    }
    
    override var completionBlock: (() -> Void)? {
        didSet {
            continuation.resume(returning: result!)
        }
    }
}

func doOperation() async -> OperationResult {
    return await withUnsafeContinuation({ continuation in
        MyOperation(continuation: continuation).start()
    })
}
