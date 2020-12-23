import UIKit

/*
 Defining Swift closures as inline functions enables you to recursively call them, which is super useful for things like custom sequences.
 */

class Database {
    func records(matching query: Query) -> AnySequence<Record> {
        var recordIterator = loadRecords().makeIterator()
        
        func iterate() -> Record? {
            guard let nextRecord = recordIterator.next() else {
                return nil
            }
            
            guard nextRecord.matches(query) else {
                // Since the closure is an inline function, it can be recursively called,
                // in this case in order to advance to the next item.
                return iterate()
            }
            
            return nextRecord
        }
        
        // AnySequence/AnyIterator are part of the standard library and provide an easy way
        // to define custom sequences using closures.
        return AnySequence { AnyIterator(iterate) }
    }
}
