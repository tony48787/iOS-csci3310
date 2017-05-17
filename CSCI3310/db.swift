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
    
    let randomIndex = getRandomInt(self.itemName.count)
    
    let name = self.itemName[randomIndex]
    
    let rareness = Rareness(rawValue: getRandomInt(4))!
    
    let hp = getRandomInt(10)
    
    let dmg = getRandomInt(10)
    
    return Item(name, rareness, hp, dmg)
  }
  
  func generateMonster() -> Monster {
  
    let randomIndex = getRandomInt(self.monsterName.count)
    
    let name = self.monsterName[randomIndex]
    
    let hp = getRandomInt(100)
    
    let dmg = getRandomInt(100)
    
    return Monster(name, hp, dmg)
  }
  
  func getRandomInt(_ range: Int) -> Int {
    return Int(arc4random()) % range
  }
  
}
