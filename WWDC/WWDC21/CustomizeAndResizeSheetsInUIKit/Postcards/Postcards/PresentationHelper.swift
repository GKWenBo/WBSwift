/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A helper class for injecting presentation settings.
*/

import UIKit

/*
 单例配置类
 */
class PresentationHelper {
    static let sharedInstance = PresentationHelper()
    var largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier = .medium
    var prefersScrollingExpandsWhenScrolledToEdge: Bool = false
    var prefersEdgeAttachedInCompactHeight: Bool = true
    var widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = true
}
