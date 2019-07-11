//
//  NewsFeedViewModel.swift
//  NewsFeed
//
//  Created by smallkot on 7/10/19.
//  Copyright © 2019 smallkot. All rights reserved.
//

import Foundation
import RxSwift
import Reachability
import RxReachability

class NewsFeedViewModel {
  var articles = [Article]() {
    didSet {
      createNewsViewModel(articles: self.articles)
    }
  }
  
  var page: Int = 1
  var pageSize: Int = 5
  var allNewsLoaded = false
  var isLoading = false
  var fromDB = false
  
  var error = PublishSubject<Error>()
  var disposeBag: DisposeBag! = DisposeBag()
  var isConnected = BehaviorSubject(value: true)
  var newsViewModel = BehaviorSubject(value: [NewsViewModel]())
  
  init() {
    Reachability.rx.isReachable
      .subscribe(onNext: { [weak self] isReachable in
        print("Is reachable: \(isReachable)")
        self?.isConnected.onNext(isReachable)
      })
      .disposed(by: disposeBag)
  }
  
  private func loadArticles() {
    isLoading = true
    Services.news.getData(page: page, pageSize: pageSize, fromBD: fromDB)
      .observeOn(MainScheduler.instance)
      .subscribe(
        onNext: {[weak self] (articles) in
          self?.isLoading = false
          if self?.page == 1 {
            self?.articles.removeAll()
          }
          
          if let pageSize = self?.pageSize, articles.count < pageSize {
            self?.allNewsLoaded = true
          }
          
          self?.articles.append(contentsOf: articles)
      },
        onError: {[weak self] (error) in
          self?.isLoading = false
          print(error)
      })
      .disposed(by: disposeBag)
  }
  
  private func createNewsViewModel(articles: [Article]) {
    let newNewsViewModel = articles.map { (item) -> NewsViewModel in
      return NewsViewModel(article: item)
    }
    newsViewModel.onNext(newNewsViewModel)
  }
  
  // MARK: - PUBLICK
  func getArticlesCount() -> Int {
    return articles.count
  }
  
  func getNewsViewModel(index: Int) -> NewsViewModel? {
    return (try? newsViewModel.value())?[index]
  }

  func nextPage(indexPath: IndexPath) {
    guard !fromDB else { return }
    guard !allNewsLoaded else { return }
    guard indexPath.row >= getArticlesCount() - 5 else { return }
    guard let isConnected = try? isConnected.value(), isConnected else { return }
    guard !isLoading else { return }
    guard page < 5 else { return }
    page += 1
    loadArticles()
  }
  
  func updateNews() {
    guard !isLoading else { return }
    page = 1
    allNewsLoaded = false
    loadArticles()
  }
  
  deinit {
    disposeBag = nil
  }
}
