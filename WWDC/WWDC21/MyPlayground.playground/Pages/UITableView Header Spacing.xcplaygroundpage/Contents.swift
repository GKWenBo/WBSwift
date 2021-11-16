//: [Previous](@previous)

import UIKit

/*
 /// Padding above each section header. The default value is `UITableViewAutomaticDimension`.
 @available(iOS 15.0, *)
 open var sectionHeaderTopPadding: CGFloat
 */
if #available(iOS 15.0, *) {
    let tableView = UITableView()
    tableView.sectionHeaderTopPadding = 0
}

/// 在APP启动全局设置
if #available(iOS 15.0, *) {
    UITableView.appearance().sectionHeaderTopPadding = 0
} else {
    /// fall back
}

//: [Next](@next)
