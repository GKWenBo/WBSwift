//
//  GithubAPI.swift
//  Combine2
//
//  Created by wenbo on 2020/12/2.
//

import Foundation
import Combine

enum APIFailureCondition: Error {
    case invalidServerResponse
}

struct GithubAPIUser: Codable {
    let login: String
    let public_repos: Int
    let avatar_url: String
}

struct GithubAPI {
    static let networkActivityPublisher = PassthroughSubject<Bool, Never>()
    
    static func retrieveGuthubUser(username: String) -> AnyPublisher<[GithubAPIUser], Never> {
        if username.count < 3 {
            return Just([]).eraseToAnyPublisher()
        }
        
        let assembledURL = String("https://api.github.com/users/\(username)")
        let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: assembledURL)!)
            .handleEvents(receiveSubscription: { (_) in
                networkActivityPublisher.send(true)
            }, receiveCompletion: { (_) in
                networkActivityPublisher.send(false)
            }, receiveCancel: {
                networkActivityPublisher.send(false)
            })
            .tryMap({ (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIFailureCondition.invalidServerResponse
                }
                return data
            })
            .decode(type: GithubAPIUser.self, decoder: JSONDecoder())
            .map({
                [$0]
            })
            .catch({ error in
                return Just([])
            })
            .eraseToAnyPublisher()
        return publisher
    }
}
