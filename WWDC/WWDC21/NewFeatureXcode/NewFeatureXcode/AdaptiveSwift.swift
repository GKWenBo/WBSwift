//
//  Adaptive.swift
//  NewFeatureXcode
//
//  Created by wenbo on 2021/11/19.
//

import Foundation
import UIKit



#if canImport(Combine) && os(iOS) && !os(watchOS)
import Combine

import UIKit

// 类引入时系统版本
@available(iOS 9.0, *)
class AdaptiveSwift {
    
    @available(iOS 13.0, *)
    var newProperty: Bool?
    
    init() {
        
        /// available
        if #available(iOS 15.0, *) {
            
        } else {
            
        }
        
        // NSObject responds
        let tableView = UITableView()
        if tableView.responds(to: #selector(getter: UITableView.contentInsetAdjustmentBehavior)) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        
        // 根据系统版本
        if Float(UIDevice.current.systemVersion)! > 11.0 {
            
        } else {
            /// fallback statements 
        }
        
        #if targetEnvironment(macCatalyst)
        
        #endif
        
        /// 判断模拟器还是真机
        #if targetEnvironment(simulator)
        
        #else
        
        #endif
    }
}

#endif
