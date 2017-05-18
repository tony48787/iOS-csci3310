//
//  ItemTableViewCell.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 18/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var itemNameView: UILabel!
  @IBOutlet weak var itemRareness: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  var item: Item? = nil {
    didSet {
      if let item = item {
        itemImageView.image = item.icon
        itemNameView.text = item.name
        itemRareness.text = String(item.rareness.rawValue)
        
      } else {
        itemNameView.text = "Default"
      }
    }
  }

}
