import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    print("Hello after 3 seconds")
}


