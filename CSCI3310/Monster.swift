//
//  Monster.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 17/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit

public class Monster {
  
  var name: String
  var hp: Int
  var dmg: Int
  var icon: UIImage
  
  public init(_ name: String, _ hp: Int, _ dmg: Int, _ icon: UIImage){
    self.name = name
    self.hp = hp
    self.dmg = dmg
    self.icon = icon
  }
  
}
