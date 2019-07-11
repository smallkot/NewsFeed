//
//  NewsService.swift
//  NewsFeed
//
//  Created by smallkot on 7/11/19.
//  Copyright © 2019 smallkot. All rights reserved.
//

import Foundation
import RxSwift

class NewsService {
  let articleEndpoint = Services.backend.article

  func getData(page: Int, pageSize: Int, fromBD: Bool = false) -> Observable<[Article]> {
    guard !fromBD else {
      let articles = RealmStorage.default.getArticles()
      return Observable.just(articles)
    }
    return articleEndpoint.getArticles(page: page, pageSize: pageSize)
      .flatMap({ (articles) -> Observable<[Article]> in
        articles.forEach({ (item) in
          RealmStorage.default.setArticle(item)
        })
        return Observable.just(articles)
      })
  }
}
