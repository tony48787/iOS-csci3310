//
//  BeaconTableViewCell.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 18/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit

class BeaconTableViewCell: UITableViewCell {
  
  @IBOutlet weak var imgIcon: UIImageView!
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblLocation: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  var beacon: Beacon? = nil {
    didSet {
      if let beacon = beacon {
        imgIcon.image = Icons(rawValue: beacon.icon)?.image()
        lblName.text = beacon.name
        lblLocation.text = beacon.locationString()
        
      } else {
        imgIcon.image = nil
        lblName.text = ""
        lblLocation.text = ""
      }
    }
  }
  
  func refreshLocation() {
    lblLocation.text = beacon?.locationString() ?? ""
  }
  
}
