import UIKit
import XCTest

/*
 Struggling with mocking UserDefaults in a test? The good news is: you don't need mocking - just create a real instance:
 */

class LoginTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var manager: LoginManager!
    
    override func setUp() {
        super.setup()
        
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        
        manager = LoginManager(userDefaults: userDefaults)
    }
}
