//
//  Adaptive.swift
//  NewFeatureXcode
//
//  Created by wenbo on 2021/11/19.
//

// MARK: - Swift API Availability
/*
 WWDC2019引入
 
 ## 定义规范：
 @available(platform version , platform version ..., *)
 1、platform（可用平台）： iOS, macCatalyst, macOS / OSX, tvOS, or watchOS, or any of those with ApplicationExtension appended (e.g. macOSApplicationExtension).
 2、version（版本号），用(.)分割
 3、（,）逗号分隔多个版本平台
 4、（*）号标识该API可适用于其它平台
 
 例子：
 @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
*/
 
// MARK: - Introduced, Deprecated, Obsoleted, and Unavailable
/*
 // With introduced, deprecated, and/or obsoleted
 @available(platform | *
           , introduced: version , deprecated: version , obsoleted: version
           , renamed: "..."
           , message: "...")
 
 // With unavailable
 @available(platform | *, unavailable , renamed: "..." , message: "...")
 1、platform：平台，（*）指所有平台
 2、introduced: version：第一个可用版本
 3、deprecated: version：第一个弃用版本
 4、obsoleted: version：第一个编译报错版本
 5、unavailable：导致编译API编译错误
 6、message：被列入编译器警告或错误字符串
 
 例子：
 @available(macOS, introduced: 10.15)
 @available(iOS, introduced: 13)
 @available(watchOS, introduced: 6)
 @available(tvOS, introduced: 13)
 
 @available(iOS 13.0, *)
 open class UICollectionViewCompositionalLayout : UICollectionViewLayout { … }
 
 // 当 API 在 iOS 中被标记为可用时，它在 tvOS 和 Mac Catalyst 上被隐式标记为可用，因为这两个平台都是 iOS 的衍生物。这就是为什么，例如， 尽管其声明仅提及.UICollectionViewCompositionalLayoutiOS 13.0，如有必要，您可以使用附加@available属性将这些派生平台明确标记为不可用：
 @available(iOS 13, *)
 @available(tvOS, unavailable)
 @available(macCatalyst, unavailable)
 func handleShakeGesture() { … }
*/
 
 // MARK: - Swift Language Availability
/*
 @available(swift version)
 
 例子：
 import Foundation

 @available(swift 5.1)
 @available(iOS 13.0, macOS 10.15, *)
 @propertyWrapper
 struct WebSocketed<Value: LosslessStringConvertible> {
     private var value: Value
     var wrappedValue: URLSessionWebSocketTask.Message {
         get { .string(value) }
         set {
             if case let .string(description) = newValue {
                 value = Value(description)
             }
         }
     }
 }
 */

import Foundation
import UIKit

// MARK: - canImport && os
// 是否能引人某框架 && 系统是
#if canImport(Combine) && os(iOS) && !os(watchOS)
import Combine
import UIKit


@available(swift 5)
// 类引入时系统版本
@available(iOS 9.0, *)
class AdaptiveSwift {
    
    @available(iOS 13.0, *)
    var newProperty: Bool?
    
    // MARK: - 标记属性弃用
    @available(iOS, deprecated: 15.0, message: "属性已被弃用了")
    var deprecatedProperty: Bool?
    
    // MARK: - 标记不可用
    @available(iOS, unavailable)
    var unavailableProperty: Bool?
    
    init() {
        deprecatedProperty = true // compiler warning
//        unavailableProperty // compiler error
        
        // MARK: - #available
        /// available
        if #available(iOS 15.0, *) {
            
        } else {
            /// fallback statements 
        }
        
        // MAKR: - NSObject responds
        // NSObject responds
        let tableView = UITableView()
        if tableView.responds(to: #selector(getter: UITableView.contentInsetAdjustmentBehavior)) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        
        // MARK: - 根据系统版本
        // 根据系统版本
        if Float(UIDevice.current.systemVersion)! > 11.0 {
            
        } else {
            /// fallback statements 
        }
        
        #if targetEnvironment(macCatalyst)
        
        #endif
        
        // MARK: - 运行环境
        /// 判断模拟器还是真机
        #if targetEnvironment(simulator)
        
        #else
        
        #endif
    }
}

#endif
