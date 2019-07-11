//
//  NewsFeedCell.swift
//  NewsFeed
//
//  Created by smallkot on 7/9/19.
//  Copyright © 2019 smallkot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

class NewsFeedCell: UITableViewCell {
  @IBOutlet weak var newsImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var shortContentLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var imageUrl: String?
  
  var disposeBag:DisposeBag = DisposeBag()
  
  func setupBind(viewModel: NewsViewModel) {
    newsImageView.image = nil
    
    viewModel.title.bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)
    viewModel.shortContent.bind(to: shortContentLabel.rx.text)
      .disposed(by: disposeBag)
    viewModel.publishedAt.bind(to: dateLabel.rx.text)
      .disposed(by: disposeBag)
    imageUrl = viewModel.urlImage
    
    if let url = imageUrl, let imageUrl = URL(string: url) {
      newsImageView.af_setImage(withURL: imageUrl)
    }
  }
}
