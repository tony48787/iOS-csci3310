//
//  MainViewController.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 17/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit
import CoreLocation
let storedItemsKey = "storedItems"
class MainViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var monsterBtnView: UIButton!
  
  @IBAction func monsterBtn(_ sender: Any) {
    performSegue(withIdentifier: "mainToMinigame", sender: self)
  }
  
  let locationManager = CLLocationManager()
  var spawnCount = 0
  var beacons = [Beacon]()
  
  var tbvc: ParentTBViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.requestAlwaysAuthorization()
    locationManager.delegate = self
    
    tableView.dataSource = self
    tableView.delegate = self
    
    loadBeacons()
    
    self.view.bringSubview(toFront: monsterBtnView)
    
    tbvc = self.tabBarController as? ParentTBViewController
    
    monsterBtnView.isUserInteractionEnabled = false
    
    // Do any additional setup after loading the view.
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    monsterBtnView.isUserInteractionEnabled = false
    monsterBtnView.setImage(UIImage(named: "egg"), for: .normal)
    self.view.bringSubview(toFront: monsterBtnView)
    spawnCount = 0
    stopBeacons()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    startBeacons()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func loadBeacons() {
    // todo: hard code an array of Beacon object
    //    guard let storedItems = UserDefaults.standard.array(forKey: storedItemsKey) as? [Data] else { return }
    //    for itemData in storedItems {
    //      guard let beacon = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? Beacon else { continue }
    //      beacons.append(beacon)
    //      startMonitoringItem(beacon)
    //    }
    // Development Mode
    if(beacons.count == 0){
      let beacon = Beacon(name: "Development", icon: 0, uuid: UUID.init(uuidString: "77777777-49A7-4DBF-914C-760D07FBB87B")!, majorValue: 7, minorValue: 8)
      beacons.append(beacon)
      startMonitoringItem(beacon)
    }
  }
  
  func startBeacons(){
    for beacon in beacons {
      startMonitoringItem(beacon)
    }
  }
  
  func stopBeacons(){
    for beacon in beacons {
      stopMonitoringItem(beacon)
    }
  }
  
  //  func persistItems() {
  //    var itemsData = [Data]()
  //    for item in items {
  //      let itemData = NSKeyedArchiver.archivedData(withRootObject: item)
  //      itemsData.append(itemData)
  //    }
  //    UserDefaults.standard.set(itemsData, forKey: storedItemsKey)
  //    UserDefaults.standard.synchronize()
  //  }
  
  func startMonitoringItem(_ beacon: Beacon) {
    let beaconRegion = beacon.asBeaconRegion()
    
    locationManager.startMonitoring(for: beaconRegion)
    locationManager.startRangingBeacons(in: beaconRegion)
  }
  
  func stopMonitoringItem(_ beacon: Beacon) {
    let beaconRegion = beacon.asBeaconRegion()
    locationManager.stopMonitoring(for: beaconRegion)
    locationManager.stopRangingBeacons(in: beaconRegion)
  }
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
//   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//   // Get the new view controller using segue.destinationViewController.
//   // Pass the selected object to the new view controller.
//  
//    if(segue.identifier == "mainToMinigame"){
//      let controller = segue.destination as! MiniGameViewController
//      
//      controller.player = tbvc?.player
//      controller.monster = tbvc?.monster
//    }
//  }
 
}

// MARK: UITableViewDataSource
extension MainViewController : UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beacons.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Beacon", for: indexPath) as! BeaconTableViewCell
    cell.beacon = beacons[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      stopMonitoringItem(beacons[indexPath.row])
      tableView.beginUpdates()
      beacons.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      tableView.endUpdates()
      
      //persistItems()
    }
  }
}

// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let item = beacons[indexPath.row]
    let detailMessage = "UUID: \(item.uuid.uuidString)\nMajor: \(item.majorValue)\nMinor: \(item.minorValue)"
    let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .alert)
    detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(detailAlert, animated: true, completion: nil)
  }
}


extension MainViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    print("Failed monitoring region: \(error.localizedDescription)")
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location manager failed: \(error.localizedDescription)")
  }
  
  func locationManager(_ manager: CLLocationManager, didRangeBeacons _beacons: [CLBeacon], in region: CLBeaconRegion) {
    // Find the same beacons in the table.
    var indexPaths = [IndexPath]()
    for _beacon in _beacons {
      for row in 0..<self.beacons.count {
        // Determine if item is equal to ranged beacon
        if self.beacons[row] == _beacon {
          self.beacons[row].beacon = _beacon
          indexPaths += [IndexPath(row: row, section: 0)]
          
        }
      }
    }
    
    // Update beacon locations of visible rows.
    if let visibleRows = tableView.indexPathsForVisibleRows {
      let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
      for row in rowsToUpdate {
        let cell = tableView.cellForRow(at: row) as! BeaconTableViewCell
        cell.refreshLocation()
      }
    }
    
    //Spawn a monster if close
    for row in 0..<self.beacons.count {
      
      let proximity = self.beacons[row].getProximity()
      
      if (proximity == "Immediate" || proximity == "Near") && spawnCount == 0{
        
        
        
        //Spawn
        
        tbvc?.monster = db.generateMonster()
        
        monsterBtnView.setImage(tbvc?.monster!.icon, for: .normal)
        
        monsterBtnView.isUserInteractionEnabled = true
        
        spawnCount += 1
      }
      
      
    }
    
  }
}
