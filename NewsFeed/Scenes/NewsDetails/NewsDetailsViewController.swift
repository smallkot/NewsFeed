//
//  NewsDetailsViewController.swift
//  NewsFeed
//
//  Created by smallkot on 7/9/19.
//  Copyright © 2019 smallkot. All rights reserved.
//

import WebKit
import UIKit

class NewsDetailsViewController: UIViewController {
  
  @IBOutlet weak var webView: WKWebView!
  
  var newsUrl: String?
  var newsTitle: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let newsUrl = newsUrl, let url = URL(string: newsUrl) else { return }
    
    let urlRequest = URLRequest(url: url)
    webView.load(urlRequest)
    
    title = newsTitle
  }
}

