//
//  ViewController.swift
//  Combine4
//
//  Created by wenbo on 2020/12/2.
//

import UIKit

class HeadingViewController: UIViewController {

    @IBOutlet weak var permissionButton: UIButton!
    @IBOutlet weak var activateTrackingSwitch: UISwitch!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var locationPermissionLabel: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Event Response
    @IBAction func requestPermission(_ sender: UIButton) {
        
    }
    
    @IBAction func trackingToggled(_ sender: UISwitch) {
        
    }
    
}

