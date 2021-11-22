/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The view controller that displays options for presenting sheets.
*/

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var largestUndimmedDetentIdentifierControl: UISegmentedControl!
    @IBOutlet weak var prefersScrollingExpandsWhenScrolledToEdgeSwitch: UISwitch!
    @IBOutlet weak var prefersEdgeAttachedInCompactHeightSwitch: UISwitch!
    @IBOutlet weak var widthFollowsPreferredContentSizeWhenEdgeAttachedSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        largestUndimmedDetentIdentifierControl.selectedSegmentIndex =
        PresentationHelper.sharedInstance.largestUndimmedDetentIdentifier == .medium ?
        0 : 1
        
        prefersScrollingExpandsWhenScrolledToEdgeSwitch.isOn =
        PresentationHelper.sharedInstance.prefersScrollingExpandsWhenScrolledToEdge
        
        prefersEdgeAttachedInCompactHeightSwitch.isOn =
        PresentationHelper.sharedInstance.prefersEdgeAttachedInCompactHeight
        
        widthFollowsPreferredContentSizeWhenEdgeAttachedSwitch.isOn =
        PresentationHelper.sharedInstance.widthFollowsPreferredContentSizeWhenEdgeAttached
    }
    
    @IBAction func largestUndimmedDetentChanged(_ sender: UISegmentedControl) {
        PresentationHelper.sharedInstance.largestUndimmedDetentIdentifier = sender.selectedSegmentIndex == 0 ?
            .medium : .large
    }
    
    @IBAction func prefersScrollingExpandsWhenScrolledToEdgeSwitchChanged(_ sender: UISwitch) {
        PresentationHelper.sharedInstance.prefersScrollingExpandsWhenScrolledToEdge = sender.isOn
    }
    
    @IBAction func prefersEdgeAttachedInCompactHeightSwitchChanged(_ sender: UISwitch) {
        PresentationHelper.sharedInstance.prefersEdgeAttachedInCompactHeight = sender.isOn
    }
    
    @IBAction func widthFollowsPreferredContentSizeWhenEdgeAttachedChanged(_ sender: UISwitch) {
        PresentationHelper.sharedInstance.widthFollowsPreferredContentSizeWhenEdgeAttached = sender.isOn
    }
    
}
