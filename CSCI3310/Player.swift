//
//  Player.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 17/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit

public class Player {
  
  var name: String
  var inventory: [Item]
  var level: Int
  var hp: Int
  var dmg: Int
  
  public init(_ name: String, _ inventory: [Item], _ level: Int, _ hp: Int, _ dmg: Int){
    self.name = name
    self.inventory = inventory
    self.level = level
    self.hp = hp
    self.dmg = dmg
  }
  
  func addItem(_ item: Item){
    self.inventory.append(item)
  }
  
  func updateStatus(){
    
    var totalHP: Int = 0
    var totalDMG: Int = 0
    
    for item in self.inventory {
      totalHP += item.hp
      totalDMG += item.dmg
    }
    
    self.hp = totalHP
    self.dmg = totalDMG
    
  }
  
  func save() {
    //TODO
  }
  
  func load() {
    //TODO
  }
  
}
