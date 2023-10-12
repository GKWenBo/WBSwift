//
//  ArticlesViewModel.swift
//  Protocols
//
//  Created by WENBO on 2022/5/10.
//

import Foundation
import Combine
import SwiftUI

class ArticlesViewModel: ObservableObject {
    private var networker: Networking
    @Published private(set) var articles: [Article] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(networker: Networking) {
        self.networker = networker
        self.networker.delegate = self
    }
    
    func fetchArticles() {
        let request = ArticleRequest()
        networker.fetch(request)
            .tryMap([Article].init)
            .replaceError(with: [])
            .assign(to: \.articles, on: self)
            .store(in: &cancellables)
    }
    
    func fetchImage(for article: Article) {
        guard article.downloadedImage == nil, let articleIndex = articles.firstIndex(where: { $0.id == article.id }) else {
            print("Already downloaded")
            return
        }
        
        let request = ImageRequest(url: article.image)
        networker.fetch(request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): print(error)
                default: break
                }
            }, receiveValue: { [weak self] image in
                self?.articles[articleIndex].downloadedImage = image
            })
            .store(in: &cancellables)
    }
}

extension ArticlesViewModel: NetworkDelegate {
    func headers(for networking: Networking) -> [String : String] {
        return ["Content-Type": "application/vnd.api+json; charset=utf-8"]
    }
    
    func networkging(_ networkging: Networking, transformPublisher publisher: AnyPublisher<Data, URLError>) -> AnyPublisher<Data, URLError> {
        publisher.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
}
