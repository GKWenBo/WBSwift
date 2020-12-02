import UIKit
import Combine
import Contacts

// MARK: - Wrapping an asynchronous call with a Future to create a one-shot publisher

let futureAsyncPublisher = Future<Bool, Error> { promise in
    CNContactStore().requestAccess(for: .contacts) { granted, error in
        if let error = error {
            return promise(.failure(error))
        }
        return promise(.success(granted))
    }
}.eraseToAnyPublisher()

/// 只处理成功
let resolvedSuccessAsPublisher = Future<Bool, Error> { promise in
    promise(.success(true))
}.eraseToAnyPublisher()

enum ExampleFailure: Error {
    case oneCase
}

/// 只处理错误
let resolvedFailureAsPublisher = Future<Bool, Error> { promise in
    promise(.failure(ExampleFailure.oneCase))
}.eraseToAnyPublisher()

// MARK: - Using catch to handle errors in a one-shot pipeline
struct IPInfo: Codable {
    var ip: String
}

let myURL = URL(string: "http://ip.jsontest.com")
let remotePublisher = URLSession.shared.dataTaskPublisher(for: myURL!)
    .map({ inputType -> Data in
        return inputType.data
    })
    .decode(type: IPInfo.self, decoder: JSONDecoder())
    .catch({ error in
        return Just(IPInfo(ip: "8.8.8.8"))
    })
    .eraseToAnyPublisher()


// MARK: - Using flatMap and catch to handle errors without cancelling the pipeline
struct PostmanEchoTimeStampCheckResponse: Codable {
    var valid: Bool
}

enum TestFailureCondition: Error {
    case invalidServerResponse
}

let remoteDataPublisher = Just(myURL!)
    .flatMap { url in
        URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    throw TestFailureCondition.invalidServerResponse
            }
            return data
        }
        .decode(type: PostmanEchoTimeStampCheckResponse.self, decoder: JSONDecoder())
        .catch {_ in
            return Just(PostmanEchoTimeStampCheckResponse(valid: false))
        }
    }
    .eraseToAnyPublisher()

// MARK: - Requesting data from an alternate URL when the network is constrained
enum MyNetworkingError: Error {
    case invalidServerResponse
}

func adaptiveLoader(requestURL: URL, downLoadURL: URL) -> AnyPublisher<Data, Error> {
    var request = URLRequest(url: requestURL);
    request.allowsCellularAccess = false;
    return URLSession.shared.dataTaskPublisher(for: request)
        .tryCatch({ error -> URLSession.DataTaskPublisher in
            guard error.networkUnavailableReason == .constrained else {
                throw error
            }
            return URLSession.shared.dataTaskPublisher(for: downLoadURL)
        })
        .tryMap({ data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MyNetworkingError.invalidServerResponse
            }
            return data
        })
        .eraseToAnyPublisher()
    
}
