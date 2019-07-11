//
//  NewsViewModel.swift
//  NewsFeed
//
//  Created by smallkot on 7/10/19.
//  Copyright © 2019 smallkot. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NewsViewModel {
  let article: Article
  
  var newsImage = BehaviorSubject<UIImage?>(value: nil)
  var urlImage: String?
  var title = BehaviorSubject<String?>(value: "")
  var shortContent = BehaviorSubject<String?>(value: "")
  var publishedAt = BehaviorSubject<String?>(value: "")
  
  let disposeBag = DisposeBag()
  
  init(article: Article) {
    self.article = article
    
    urlImage = article.urlToImage
    title.onNext(article.title)
    shortContent.onNext(article.content)
    publishedAt.onNext(article.publishedAt?.shortTime(format: "dd.MM HH:mm"))
  }
}
