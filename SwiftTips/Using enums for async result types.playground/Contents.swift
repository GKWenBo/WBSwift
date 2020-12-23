import UIKit

/*
 I really like using enums for all async result types, even boolean ones. Self-documenting, and makes the call site a lot nicer to read too!
 */

enum PushNotificationStatus {
    case enabled
    case disabled
}

protocol PushNotificatonService {
    // Before
        func enablePushNotifications(completionHandler: @escaping (Bool) -> Void)
        
        // After
        func enablePushNotifications(completionHandler: @escaping (PushNotificationStatus) -> Void)
}


service.enablePushNotifications { status in
    if status == .enabled {
        enableNotificationsButton.removeFromSuperview()
    }
}
