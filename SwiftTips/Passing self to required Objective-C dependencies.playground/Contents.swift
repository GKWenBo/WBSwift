import UIKit

/*
 Using lazy properties in Swift, you can pass self to required Objective-C dependencies without having to use force-unwrapped optionals.
 */

class DataLoader: NSObject, URLSessionDelegate {
    lazy var urlSession: URLSession = self.makeURLSession()
    
    private func makeURLSession() -> URLSession {
            return URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        }
}

class Renderer {
    lazy var displayLink: CADisplayLink = self.makeDisplayLink()
    
    private func makeDisplayLink() -> CADisplayLink {
        return CADisplayLink(target: self, selector: #selector(screenDidRefresh))
    }
    
    @objc func screenDidRefresh() {
        
    }
}
