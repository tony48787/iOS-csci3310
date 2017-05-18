//
//  Item.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 17/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit

public enum Rareness : Int {
  case normal = 0
  case special = 1
  case rare = 2
  case legendary = 3
}

public class Item {
  
  var rareness:Rareness
  var name: String
  var hp: Int
  var dmg: Int
  var icon: UIImage
  
  public init(_ name: String, _ rareness: Rareness, _ hp: Int, _ dmg: Int, _ icon: UIImage){
    self.name = name
    self.rareness = rareness
    self.hp = hp
    self.dmg = dmg
    self.icon = icon
  }
  
}
