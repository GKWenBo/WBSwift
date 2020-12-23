import UIKit

/*
 Avoid memory leaks when accidentially refering to self in closures by overriding it locally with a weak reference:
 */

/*
dataLoader.loadData(from: url) { [weak self] result in
    guard let self = self else {
        return
    }

    self.cache(result)
    
    ...
 */
