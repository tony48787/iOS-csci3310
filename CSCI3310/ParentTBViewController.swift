//
//  ParentTBViewController.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 18/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit

class ParentTBViewController: UITabBarController {
  
  var player = Player("Hong", [], 1, 10, 10)
  var monster: Monster?
  
  var spawnPoint = [String: Int]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    //Init modal here
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
