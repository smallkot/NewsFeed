//
//  NewsFeedViewController.swift
//  NewsFeed
//
//  Created by smallkot on 7/9/19.
//  Copyright © 2019 smallkot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsFeedViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var newsFeedViewModel = NewsFeedViewModel()
  var disposeBag:DisposeBag! = DisposeBag()
  
  var isConnected = true
  
  private let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    setupBind()
    newsFeedViewModel.updateNews()
  
    title = R.string.localizable.newsFeedTitle()
  }
  
  // MARK: - SETUP
  func setupTableView() {
    tableView.register(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: "NewsFeedCell")
    tableView.register(UINib(nibName: "NotInternetCell", bundle: nil), forCellReuseIdentifier: "NotInternetCell")
    
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableView.automaticDimension
    tableView.delegate = self
    tableView.dataSource = self
    
    setupRefreshControl()
  }
  
  func setupRefreshControl() {
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }
    refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    refreshControl.tintColor = UIColor(red:1, green:0, blue:0, alpha:1.0)
    refreshControl.attributedTitle = NSAttributedString(string: R.string.localizable.refreshControlTitle())
  }
  
  func setupBind() {
    newsFeedViewModel.isConnected
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] (isConnected) in
        self?.isConnected = isConnected
        
        self?.refreshControl.endRefreshing()
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)
    
    newsFeedViewModel.newsViewModel
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        self?.refreshControl.endRefreshing()
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - ACTION
  @objc private func refreshWeatherData(_ sender: Any) {
    // Fetch Weather Data
    newsFeedViewModel.updateNews()
  }
}

extension NewsFeedViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = newsFeedViewModel.getArticlesCount()
    return isConnected ? count : count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if !isConnected && indexPath.row == newsFeedViewModel.getArticlesCount() {
      return tableView.dequeueReusableCell(withIdentifier: "NotInternetCell", for: indexPath)
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell", for: indexPath)
    if let newsCell = cell as? NewsFeedCell, let viewModel = newsFeedViewModel.getNewsViewModel(index: indexPath.row) {
      newsCell.setupBind(viewModel: viewModel)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if !isConnected && indexPath.row == newsFeedViewModel.getArticlesCount() { return }
    
    guard let viewModel = newsFeedViewModel.getNewsViewModel(index: indexPath.row) else { return }
    let newsDetailsViewController = NewsDetailsViewController()
    newsDetailsViewController.newsUrl = viewModel.article.url
    newsDetailsViewController.newsTitle = viewModel.article.title
    navigationController?.pushViewController(newsDetailsViewController, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    newsFeedViewModel.nextPage(indexPath: indexPath)
  }
}
