//
//  InventoryViewController.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 17/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController {
  
  @IBOutlet weak var playerIconView: UIImageView!
  @IBOutlet weak var playerName: UILabel!
  @IBOutlet weak var playerLevel: UILabel!
  @IBOutlet weak var playerHP: UILabel!
  @IBOutlet weak var playerDMG: UILabel!
  
  var tbvc: ParentTBViewController?
  
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tbvc = self.tabBarController as? ParentTBViewController
    
    tableView.dataSource = self
    tableView.delegate = self
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
    guard let player = tbvc?.player else { return }
    playerName.text = player.name
    playerLevel.text = "Level: \(player.level)"
    playerHP.text = "HP: \(player.hp)"
    playerDMG.text = "Dmg: \(player.dmg)"
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

// MARK: UITableViewDataSource
extension InventoryViewController : UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (self.tbvc?.player.inventory.count)!
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemTableViewCell
    cell.item = self.tbvc?.player.inventory[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      tableView.beginUpdates()
      self.tbvc?.player.inventory.remove(at: indexPath.row)
      self.tbvc?.player.updateStatus()
      tableView.deleteRows(at: [indexPath], with: .automatic)
      tableView.endUpdates()
    
    }
  }
}

// MARK: UITableViewDelegate
extension InventoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let item = self.tbvc?.player.inventory[indexPath.row]
    var detailMessage = ""
    if let name = item?.name, let rareness = item?.rareness, let hp = item?.hp, let dmg = item?.dmg {
      detailMessage = "Name: \(name)\nRareness: \(rareness)\nhp: \(hp)\ndmg: \(dmg)"
    }
    let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .alert)
    detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(detailAlert, animated: true, completion: nil)
  }
}



