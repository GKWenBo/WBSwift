//: [Previous](@previous)

import UIKit

let tabBar = UITabBar()

let appearance = UITabBarAppearance()
appearance.backgroundEffect = nil
appearance.backgroundColor = .orange

/*
 /// Describes the appearance attributes for the tabBar to use when an observable scroll view is scrolled to the bottom. If not set, standardAppearance will be used instead.
 @available(iOS 15.0, *)
 @NSCopying open var scrollEdgeAppearance: UITabBarAppearance?
 */
if #available(iOS 15.0, *) {
    tabBar.scrollEdgeAppearance = appearance
}

let scrollView = UIScrollView()
let controller = UIViewController()
controller.setContentScrollView(scrollView)

//: [Next](@next)
