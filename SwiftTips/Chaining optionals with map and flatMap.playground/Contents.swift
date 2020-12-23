import UIKit

/*
 Using map() and flatMap() on optionals you can chain multiple operations without having to use lengthy if lets or guards:
 */

// BEFORE

guard let string = argument(at: 1) else {
    return
}

guard let url = URL(string: string) else {
    return
}

handle(url)

// AFTER

argument(at: 1).flatMap(URL.init).map(handle)
