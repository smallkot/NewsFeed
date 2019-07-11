//
//  NotInternetCell.swift
//  NewsFeed
//
//  Created by smallkot on 7/10/19.
//  Copyright © 2019 smallkot. All rights reserved.
//

import UIKit

class NotInternetCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    titleLabel.text = R.string.localizable.notInternet()
  }
}
