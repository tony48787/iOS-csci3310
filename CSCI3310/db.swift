//
//  db.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 17/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit

public class db {
  
  var itemName: [String]
  var monsterName: [String]
  
  public init(){
    
    self.itemName = ["Long Sword", "Chainsword", "Lightning Claw","Power Axe", "Grav-pistol",
                               "Genestealer Claw", "Plasma pistol", "Long Sword"]
    
   
    self.monsterName = ["Mournhag", "Warpsnake", "Vampboy","Abysspod", "The Bruised Abortion",
                               "The Agile Presence", "The Dangerous Teeth", "The Hidden Hunting Yak",
                               "The Barb-Tailed Sun Bear"]
  }
  
  func generateItem() -> Item {
    let name = self.itemName[0]
    
    let rareness = Rareness(rawValue: 0)!
    
    let hp = 10
    
    let dmg = 10
    
    return Item(name, rareness, hp, dmg)
  }
  
  func generateMonster() -> Monster {
  
    let name = self.monsterName[0]
    
    let hp = 10
    
    let dmg = 10
    
    return Monster(name, hp, dmg)
  }
  
}
