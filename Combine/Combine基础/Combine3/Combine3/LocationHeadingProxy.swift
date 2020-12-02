//
//  LocationHeadingProxy.swift
//  Combine3
//
//  Created by wenbo on 2020/12/2.
//

import UIKit
import Combine
import CoreLocation

final class LocationHeadingProxy: NSObject {

    let mgr: CLLocationManager
    private let headingPublisher: PassthroughSubject<CLHeading, Error>
    var publisher: AnyPublisher<CLHeading, Error>
    
    override init() {
        mgr = CLLocationManager()
        
        headingPublisher = PassthroughSubject<CLHeading, Error>()
        publisher = headingPublisher.eraseToAnyPublisher()
        
        super.init()
        
        mgr.delegate = self
    }
    
    func enable() {
        mgr.startUpdatingHeading()
    }
    
    func disable() {
        mgr.stopUpdatingHeading()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationHeadingProxy: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingPublisher.send(newHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        headingPublisher.send(completion: .failure(error))
    }
}
