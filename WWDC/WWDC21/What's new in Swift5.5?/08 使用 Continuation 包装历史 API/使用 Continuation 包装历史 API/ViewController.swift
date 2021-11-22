//
//  ViewController.swift
//  使用 Continuation 包装历史 API
//
//  Created by WENBO on 2021/11/20.
//

/*
 1、改造基于handler回调
 2、改造基于delegate回调
 */

/*
 Swift 中绝大多数事件驱动的 API 都是基于回调函数的。 因此，升级到 Swift 5.5 之后，如何把这些已有的 API 嫁接到新的编程方式，也是一个必须认真考虑的问题。为此，Swift 提出了一个概念，叫做：Continuation。
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
            let news =  try await news()
            
            // test delegate
            let pickerDelegate = ImagePickerDelegate()
            let image = try? await pickerDelegate.chooseImageFromPhotoLibrary(vc: self)
        }
    }

    // 基于回调的函数
    func getNews(completion: @escaping ([News]?, Error?) -> Void) {
        /// do netowrk
        completion([], nil)
    }

    // MARK: - 改造基于handler回调
    /*
     withUnsafeContinuation 和 withUnsafeThrowingContinuation
     
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

// MARK: - 改造基于delegate回调
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

