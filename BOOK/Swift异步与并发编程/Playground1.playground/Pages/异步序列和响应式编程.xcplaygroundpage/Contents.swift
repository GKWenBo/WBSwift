//: [Previous](@previous)

import Foundation
import Combine

extension Publisher {
    var asAsyncStream: AsyncThrowingStream<Output, Error> {
        AsyncThrowingStream(Output.self) { continuation in
            let cancellable = sink { completion in
                switch completion {
                case .finished:
                    continuation.finish()
                case .failure(let error):
                    continuation.finish(throwing: error)
                }
            } receiveValue: { output in
                continuation.yield(output)
            }
            continuation.onTermination = {
                @Sendable _ in
                cancellable.cancel()
            }
        }
    }
}

//: [Next](@next)
