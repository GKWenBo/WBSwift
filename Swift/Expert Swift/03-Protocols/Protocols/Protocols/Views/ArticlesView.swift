//
//  ArticlesView.swift
//  Protocols
//
//  Created by WENBO on 2022/5/10.
//

import SwiftUI

struct ArticlesView: View {
    @ObservedObject private var viewModel = ArticlesViewModel(networker: Networker())
    
    var body: some View {
        List(viewModel.articles) { article in
            ArticleRow(article: article, image: .constant(nil))
                .onAppear {
                    viewModel.fetchImage(for: article)
                }
        }
        .onAppear {
            viewModel.fetchArticles()
        }
    }
}

struct ArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesView()
    }
}
