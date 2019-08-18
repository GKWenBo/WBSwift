import UIKit

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum CarError: Error {
    case outOfFuel
}

struct Car {
    var fueInLitre: Double
    
//    func start() -> Result<String> {
//        guard fueInLitre > 5 else {
//            return .failure(CarError.outOfFuel)
//        }
//
//        return .success("Ready to go")
//    }
    
    //理解Swift中的throw和catch
    func start() throws -> String {
        guard fueInLitre > 5 else {
            throw CarError.outOfFuel
        }
        return "Ready to go"
    }
    
    
}


let vw = Car(fueInLitre: 2)

//switch vw.start() {
//case let .success(message):
//    print(message)
//case let .failure(error):
//    if let carError = error as? CarError, carError == .outOfFuel {
//        print("Cannot start due to out of fuel")
//    }
//    else {
//        print(error.localizedDescription)
//    }
//
//}

do {
    let message = try vw.start()
    print(message)
}catch CarError.outOfFuel {
    print("Cannot start due to out of fuel")
}catch {
    print("We have something wrong")
}

