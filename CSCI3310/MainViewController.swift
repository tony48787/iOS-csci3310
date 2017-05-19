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
  
  var monsters = [String: Monster]()
  
  var tbvc: ParentTBViewController?
  
  var prev_dist: CLLocationAccuracy?
  
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
  
    monsterBtnView.isHidden = true
        
        // Do any additional setup after loading the view.
  }
    
    override func viewDidDisappear(_ animated: Bool) {
        monsterBtnView.isUserInteractionEnabled = false
        monsterBtnView.setImage(UIImage(named: "egg"), for: .normal)
        spawnCount = 0
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
            let beacon = Beacon(name: "Development A", icon: 0, uuid: UUID.init(uuidString: "77777777-49A7-4DBF-914C-760D07FBB87A")!, majorValue: 7, minorValue: 8)
            let beacon2 = Beacon(name: "Development B", icon: 0, uuid: UUID.init(uuidString: "77777777-49A7-4DBF-914C-760D07FBB87B")!, majorValue: 7, minorValue: 8)
            
            beacons.append(beacon)
            beacons.append(beacon2)
            startMonitoringItem(beacon)
            startMonitoringItem(beacon2)
        }
        print("Loaded", beacons.count)
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
        
        // Track User Location
        var curr_dists: [CLLocationAccuracy] = [99, 99, 99]
        var pass = 0
        for row in 0..<self.beacons.count {
            if let accuracy = self.beacons[row].beacon?.accuracy {
                if (accuracy != -1) {
                    curr_dists[row] = accuracy
                    pass = pass + 1
                }
            }
        }
        
        
        if (pass >= 2) {
            print(curr_dists)
            let nearest_beacon1 = curr_dists.index(of: curr_dists.sorted(by: <)[0])!
            let nearest_beacon2 = curr_dists.index(of: curr_dists.sorted(by: <)[1])!
            
            if let prev_dist = prev_dist {
                if (nearest_beacon1 == 0 && nearest_beacon2 == 1) {
                    let diff = abs(prev_dist - curr_dists[nearest_beacon1])
                    print(diff)
                    if (diff > 0.5) {
                        monsterBtnView.center = CGPoint(x: monsterBtnView.center.x, y: monsterBtnView.center.y - 10)
                    }
                    
                }
                if (nearest_beacon1 == 1 && nearest_beacon2 == 0) {
                    let diff = abs(prev_dist - curr_dists[nearest_beacon1])
                    print(diff)
                    if (diff > 0.5) {
                        monsterBtnView.center = CGPoint(x: monsterBtnView.center.x, y: monsterBtnView.center.y + 10)
                    }
                }
                if (nearest_beacon1 == 1 && nearest_beacon2 == 2) {
                    let diff = abs(prev_dist - curr_dists[nearest_beacon1])
                    if (diff > 0.5) {
                        monsterBtnView.center = CGPoint(x: monsterBtnView.center.x + 10, y: monsterBtnView.center.y)
                    }
                }
                if (nearest_beacon1 == 2 && nearest_beacon2 == 1) {
                    let diff = abs(prev_dist - curr_dists[nearest_beacon1])
                    if (diff > 0.5) {
                        monsterBtnView.center = CGPoint(x: monsterBtnView.center.x - 10, y: monsterBtnView.center.y)
                    }
                }
                
            } else {
                print("init location")
                monsterBtnView.isHidden = false
                print(nearest_beacon1)
                print(nearest_beacon2)
                if (nearest_beacon1 == 0 && nearest_beacon2 == 1) {
                    print("case1")
                    print("diff: ")
                    print((curr_dists[nearest_beacon1]/curr_dists[nearest_beacon2]))
                    let offset = 79 * (curr_dists[nearest_beacon1]/curr_dists[nearest_beacon2])
                    monsterBtnView.center = CGPoint(x: 260, y: 250 - offset)
                }
                if (nearest_beacon1 == 1 && nearest_beacon2 == 0) {
                    print("case2")
                    print("diff: ")
                    let offset = 79 * (curr_dists[nearest_beacon1]/curr_dists[nearest_beacon2])
                    monsterBtnView.center = CGPoint(x: 260, y: 92 + offset)
                }
                if (nearest_beacon1 == 1 && nearest_beacon2 == 2) {
                    print("case3")
                    monsterBtnView.center = CGPoint(x: 260, y: 92)
                }
                if (nearest_beacon1 == 2 && nearest_beacon2 == 1) {
                    print("case4")
                    monsterBtnView.center = CGPoint(x: 109, y: 92)
                }
            }
//            prev_dist = curr_dists[nearest_beacon1]
        }
        
        //Spawn a monster if close
        for row in 0..<self.beacons.count {
            
            let proximity = self.beacons[row].getProximity()
          
          
          
            if (proximity == "Immediate" || proximity == "Near") && tbvc?.spawnPoint[self.beacons[row].uuid.uuidString] != 1 {
                
                
                
              //Spawn
              
              monsters[self.beacons[row].uuid.uuidString] = db.generateMonster()
              let imageView = UIImageView(frame: CGRect(x: monsterBtnView.center.x + CGFloat(db.getRandomInt(20)), y: monsterBtnView.center.y + CGFloat(db.getRandomInt(20)), width: 30.0, height: 30.0))
              
              imageView.image = monsters[self.beacons[row].uuid.uuidString]?.icon
              
              imageView.tag = row
              
              let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
              imageView.isUserInteractionEnabled = true
              imageView.addGestureRecognizer(tapGestureRecognizer)
              
              self.view.addSubview(imageView)
              
              self.view.bringSubview(toFront: imageView)
                
              tbvc?.spawnPoint[self.beacons[row].uuid.uuidString] = 1
            }
            else if(tbvc?.spawnPoint[self.beacons[row].uuid.uuidString] != 1){
              //Delete
          }
            
            
        }
        
    }
  
  func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
  {
    let tappedImage = tapGestureRecognizer.view as! UIImageView
    
    tbvc?.spawnPoint[self.beacons[tappedImage.tag].uuid.uuidString] = 0
    
    tbvc?.monster = monsters[self.beacons[tappedImage.tag].uuid.uuidString]
    
    performSegue(withIdentifier: "mainToMinigame", sender: self)
    
    tappedImage.removeFromSuperview()
    // Your action
  }
}
