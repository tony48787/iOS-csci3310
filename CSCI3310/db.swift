//
//  db.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 17/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit

public class db {
  
  static var itemName = ["Long Sword", "Chainsword", "Lightning Claw","Power Axe", "Grav-pistol",
  "Genestealer Claw", "Plasma pistol", "Long Sword"]
  static var monsterName = ["Mournhag", "Warpsnake", "Vampboy","Abysspod", "The Bruised Abortion",
  "The Agile Presence", "The Dangerous Teeth", "The Hidden Hunting Yak",
  "The Barb-Tailed Sun Bear"]
  
  static func generateItem() -> Item {
    
    let randomIndex = getRandomInt(self.itemName.count)
    
    let name = self.itemName[randomIndex]
    
    let rareness = Rareness(rawValue: getRandomInt(4))!
    
    let hp = getRandomInt(10)
    
    let dmg = getRandomInt(10)
    
    let random = getRandomInt(1)
    
    var icon = UIImage()
    
    if(random == 0){
      icon = getRandomArmor()
    } else {
      icon = getRandomWeapon()
    }
    
    return Item(name, rareness, hp, dmg, icon)
  }
  
  static func generateMonster() -> Monster {
  
    let randomIndex = getRandomInt(self.monsterName.count)
    
    let name = self.monsterName[randomIndex]
    
    let hp = getRandomInt(100)
    
    let dmg = getRandomInt(20)
    
    let icon = getRandomIcon()
    
    return Monster(name, hp, dmg, icon)
  }
  
  static func getRandomInt(_ range: Int) -> Int {
    return Int(arc4random()) % range
  }
  
  static func getRandomIcon() -> UIImage {
    let randomIndex = getRandomInt(10)
    
    return UIImage(named: "icon\(randomIndex).png")!
  }
  
  static func getRandomArmor() -> UIImage {
    let randomIndex = getRandomInt(3)
    
    return UIImage(named: "armor\(randomIndex).png")!
  }
  
  static func getRandomWeapon() -> UIImage {
    let randomIndex = getRandomInt(3)
    
    return UIImage(named: "sword\(randomIndex).png")!
  }
  
}
