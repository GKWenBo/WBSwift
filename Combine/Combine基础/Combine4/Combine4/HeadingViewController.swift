//
//  ViewController.swift
//  Combine4
//
//  Created by wenbo on 2020/12/2.
//

import UIKit
import Combine
import CoreLocation

class HeadingViewController: UIViewController {

    @IBOutlet weak var permissionButton: UIButton!
    @IBOutlet weak var activateTrackingSwitch: UISwitch!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var locationPermissionLabel: UILabel!
    
    var headingSubscriber: AnyCancellable?
    let coreLocationProxy = LocationHeadingProxy()
    var headingBackgroundQueue: DispatchQueue = DispatchQueue(label: "headingBackgroundQueue")
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bindViewModel()
    }
    
    func bindViewModel() {
        updatePermissionStatus()
        
        headingSubscriber = coreLocationProxy
            .publisher
            .print("headingSubscriber")
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                print("completed")
            }, receiveValue: { someValue in
                self.headingLabel.text = String(someValue.trueHeading)
            })
    }

    // MARK: - Event Response
    @IBAction func requestPermission(_ sender: UIButton) {
        print("requesting coreloc ation permission")
        let _ = Future<Int, Never> { promise in
            self.coreLocationProxy.mgr.requestAlwaysAuthorization()
            return promise(.success(1))
        }
        .delay(for: 2.0, scheduler: headingBackgroundQueue)
        .receive(on: RunLoop.main)
        .sink(receiveValue: { _ in
            print("updating corelocation permission label")
            self.updatePermissionStatus()
        })
    }
    
    @IBAction func trackingToggled(_ sender: UISwitch) {
        switch sender.isOn {
        case true:
            self.coreLocationProxy.enable()
            print("Enabling heading tracking")
        default:
            self.coreLocationProxy.disable()
            print("Disabling heading tracking")
        }
    }
    
    // MARK: - Methods
    func updatePermissionStatus() {
        let x = CLLocationManager.authorizationStatus()
        switch x {
        case .authorizedWhenInUse:
            locationPermissionLabel.text = "Allowed when in use"
        case .notDetermined:
            locationPermissionLabel.text = "notDetermined"
        case .restricted:
            locationPermissionLabel.text = "restricted"
        case .denied:
            locationPermissionLabel.text = "denied"
        case .authorizedAlways:
            locationPermissionLabel.text = "authorizedAlways"
        @unknown default:
            locationPermissionLabel.text = "unknown default"
        }
    }
    
}

